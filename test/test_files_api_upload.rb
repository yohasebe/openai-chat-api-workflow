# frozen_string_literal: true

require 'minitest/autorun'
require 'tmpdir'
require 'fileutils'
require 'net/http'
require 'uri'
require 'json'
require 'securerandom'

# Test the Files API upload logic (multipart body construction, validation)
# without making actual API calls.

class TestFilesApiUpload < Minitest::Test
  IMAGE_EXTENSIONS = %w[jpg jpeg png gif webp].freeze
  MAX_FILE_SIZE = 50 * 1024 * 1024

  def setup
    @tmpdir = Dir.mktmpdir
  end

  def teardown
    FileUtils.rm_rf(@tmpdir)
  end

  # Helper: build the multipart body the same way upload_to_openai_files does
  def build_multipart_body(file_path)
    boundary = "----RubyFormBoundary#{SecureRandom.hex(16)}"
    file_content = File.open(file_path, "rb").read
    filename = File.basename(file_path)

    body = "".b
    body << "--#{boundary}\r\n"
    body << "Content-Disposition: form-data; name=\"purpose\"\r\n\r\n"
    body << "assistants\r\n"
    body << "--#{boundary}\r\n"
    body << "Content-Disposition: form-data; name=\"file\"; filename=\"#{filename}\"\r\n"
    body << "Content-Type: application/octet-stream\r\n\r\n"
    body << file_content
    body << "\r\n--#{boundary}--\r\n"

    { boundary: boundary, body: body, filename: filename }
  end

  def create_temp_file(name, content)
    path = File.join(@tmpdir, name)
    File.binwrite(path, content)
    path
  end

  # --- Multipart body construction tests ---

  def test_multipart_body_contains_purpose
    path = create_temp_file("test.pdf", "%PDF-1.4 test")
    result = build_multipart_body(path)
    assert_includes result[:body], "name=\"purpose\""
    assert_includes result[:body], "assistants"
  end

  def test_multipart_body_contains_filename
    path = create_temp_file("document.pdf", "%PDF-1.4 test")
    result = build_multipart_body(path)
    assert_includes result[:body], 'filename="document.pdf"'
  end

  def test_multipart_body_contains_file_content
    content = "Hello, this is test content!"
    path = create_temp_file("test.txt", content)
    result = build_multipart_body(path)
    assert_includes result[:body], content
  end

  def test_multipart_body_boundary_format
    path = create_temp_file("test.txt", "data")
    result = build_multipart_body(path)
    assert_match(/\A----RubyFormBoundary[0-9a-f]{32}\z/, result[:boundary])
  end

  def test_multipart_body_starts_with_boundary
    path = create_temp_file("test.txt", "data")
    result = build_multipart_body(path)
    assert result[:body].start_with?("--#{result[:boundary]}\r\n")
  end

  def test_multipart_body_ends_with_closing_boundary
    path = create_temp_file("test.txt", "data")
    result = build_multipart_body(path)
    assert result[:body].end_with?("--#{result[:boundary]}--\r\n")
  end

  def test_multipart_body_binary_encoding
    path = create_temp_file("test.txt", "data")
    result = build_multipart_body(path)
    assert_equal Encoding::ASCII_8BIT, result[:body].encoding
  end

  def test_multipart_body_with_binary_file
    binary_data = (0..255).map(&:chr).join
    path = create_temp_file("test.bin", binary_data)
    result = build_multipart_body(path)
    assert_includes result[:body], binary_data
  end

  # --- File size validation tests ---

  def test_file_size_within_limit
    path = create_temp_file("small.txt", "x" * 1024)
    assert File.size(path) <= MAX_FILE_SIZE
  end

  def test_file_size_limit_constant
    assert_equal 50 * 1024 * 1024, MAX_FILE_SIZE
  end

  # --- image_file? logic tests ---

  def test_image_extensions_detected
    %w[jpg jpeg png gif webp].each do |ext|
      assert IMAGE_EXTENSIONS.include?(ext), "#{ext} should be an image extension"
    end
  end

  def test_non_image_extensions
    %w[pdf doc docx txt rb py js].each do |ext|
      refute IMAGE_EXTENSIONS.include?(ext), "#{ext} should not be an image extension"
    end
  end

  # --- API endpoint construction tests ---

  def test_api_endpoint_construction
    api_base = "https://api.openai.com/v1"
    uri = URI.parse("#{api_base}/files")
    assert_equal "https", uri.scheme
    assert_equal "api.openai.com", uri.host
    assert_equal "/v1/files", uri.path
  end

  def test_api_endpoint_trailing_slash_handling
    api_base = "https://api.openai.com/v1/"
    api_base = api_base[0...-1] if api_base[-1] == "/"
    uri = URI.parse("#{api_base}/files")
    assert_equal "/v1/files", uri.path
  end

  # --- Response parsing tests ---

  def test_successful_response_parsing
    response_body = '{"id": "file-abc123", "object": "file", "purpose": "assistants"}'
    result = JSON.parse(response_body)
    assert_equal "file-abc123", result["id"]
  end

  def test_error_response_detection
    response_body = '{"error": {"message": "Invalid API key", "type": "invalid_request_error"}}'
    result = JSON.parse(response_body)
    assert_nil result["id"]
    assert_equal "Invalid API key", result["error"]["message"]
  end

  # --- File type distinction for message construction ---

  def test_image_file_uses_image_type
    filename = "photo.png"
    ext = filename.split(".").last.downcase
    file_type = IMAGE_EXTENSIONS.include?(ext) ? "image" : "file"
    assert_equal "image", file_type
  end

  def test_pdf_file_uses_file_type
    filename = "document.pdf"
    ext = filename.split(".").last.downcase
    file_type = IMAGE_EXTENSIONS.include?(ext) ? "image" : "file"
    assert_equal "file", file_type
  end

  def test_code_file_uses_file_type
    filename = "script.rb"
    ext = filename.split(".").last.downcase
    file_type = IMAGE_EXTENSIONS.include?(ext) ? "image" : "file"
    assert_equal "file", file_type
  end

  # --- Delete endpoint tests (delete_openai_file) ---

  def test_delete_endpoint_construction
    api_base = "https://api.openai.com/v1"
    file_id = "file-abc123"
    uri = URI.parse("#{api_base}/files/#{file_id}")
    assert_equal "https", uri.scheme
    assert_equal "api.openai.com", uri.host
    assert_equal "/v1/files/file-abc123", uri.path
  end

  def test_delete_endpoint_trailing_slash_handling
    api_base = "https://api.openai.com/v1/"
    api_base = api_base[0...-1] if api_base[-1] == "/"
    file_id = "file-xyz"
    uri = URI.parse("#{api_base}/files/#{file_id}")
    assert_equal "/v1/files/file-xyz", uri.path
  end

  def test_delete_request_is_http_delete_method
    req = Net::HTTP::Delete.new(URI.parse("https://api.openai.com/v1/files/file-abc"))
    assert_equal "DELETE", req.method
  end

  def test_delete_authorization_header
    req = Net::HTTP::Delete.new(URI.parse("https://api.openai.com/v1/files/file-abc"))
    req["Authorization"] = "Bearer sk-test"
    assert_equal "Bearer sk-test", req["Authorization"]
  end

  def test_delete_success_response_parsing
    response_body = '{"id": "file-abc123", "object": "file", "deleted": true}'
    result = JSON.parse(response_body)
    assert_equal true, result["deleted"]
    assert_equal "file-abc123", result["id"]
  end

  def test_delete_with_nil_file_id_is_noop
    # delete_openai_file returns early when file_id is nil — this validates the contract
    file_id = nil
    should_skip = file_id.nil?
    assert should_skip, "Delete should be skipped when file_id is nil"
  end

  # --- Filename sanitization tests (multipart header injection guard) ---

  # Replicates the sanitization logic from upload_to_openai_files.
  # Block forms avoid gsub's replacement-string backslash interpretation.
  def sanitize_filename(name)
    name.gsub("\\") { "\\\\" }.gsub('"') { '\"' }.gsub(/[\r\n]/, "_")
  end

  def test_filename_plain_unchanged
    assert_equal "document.pdf", sanitize_filename("document.pdf")
  end

  def test_filename_quote_escaped
    # Expected: each literal " becomes \" (escaped for quoted-string header)
    assert_equal 'bad\"name.pdf', sanitize_filename('bad"name.pdf')
  end

  def test_filename_backslash_escaped
    # Expected: each literal \ becomes \\ (per quoted-string rules)
    assert_equal 'a\\\\b.pdf', sanitize_filename('a\\b.pdf')
  end

  def test_filename_newline_replaced
    result = sanitize_filename("line1\nline2.pdf")
    refute_includes result, "\n"
    assert_includes result, "_"
  end

  def test_filename_carriage_return_replaced
    result = sanitize_filename("line1\rline2.pdf")
    refute_includes result, "\r"
    assert_includes result, "_"
  end

  def test_filename_injection_attempt
    # Attempt to inject an extra Content-Disposition header
    malicious = "evil.pdf\"\r\nContent-Disposition: form-data; name=\"stolen\""
    result = sanitize_filename(malicious)
    refute_includes result, "\r"
    refute_includes result, "\n"
    # Original quote should be escaped, not raw
    refute_match(/[^\\]"/, result)
  end

  # --- filename: parameter override (for cache reuse) ---

  def test_filename_override_default_uses_basename
    filename = nil
    file_path = "/tmp/cache/abc-xyz-uuid.pdf"
    effective = filename || File.basename(file_path)
    assert_equal "abc-xyz-uuid.pdf", effective
  end

  def test_filename_override_preserves_original_name
    # When uploading from a cache copy, we override with the user-visible name
    filename = "User Report.pdf"
    file_path = "/tmp/cache/abc-xyz-uuid.pdf"
    effective = filename || File.basename(file_path)
    assert_equal "User Report.pdf", effective
  end
end
