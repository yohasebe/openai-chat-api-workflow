# frozen_string_literal: true

require 'minitest/autorun'
require 'tmpdir'
require 'json'
require 'fileutils'
require 'securerandom'

# Test the upload file saving logic in isolation
# (WEBrick endpoint is tested in integration; this tests the core logic)

class TestUploadEndpoint < Minitest::Test
  def setup
    @tmpdir = Dir.mktmpdir
    @uploads_dir = File.join(@tmpdir, "uploads")
  end

  def teardown
    FileUtils.rm_rf(@tmpdir)
  end

  # Replicate the file saving logic from the /upload endpoint
  def save_upload(file_data, original_name, uploads_dir)
    Dir.mkdir(uploads_dir) unless Dir.exist?(uploads_dir)

    ext = File.extname(original_name)
    filename = "upload_#{Time.now.to_i}_#{SecureRandom.hex(4)}#{ext}"
    path = File.join(uploads_dir, filename)
    File.binwrite(path, file_data)

    { "path" => path, "filename" => original_name, "size" => file_data.bytesize }
  end

  def test_save_text_file
    result = save_upload("Hello world", "test.txt", @uploads_dir)
    assert File.exist?(result["path"])
    assert_equal "test.txt", result["filename"]
    assert_equal 11, result["size"]
    assert_equal "Hello world", File.read(result["path"])
  end

  def test_save_binary_file
    binary_data = (0..255).map(&:chr).join
    result = save_upload(binary_data, "test.bin", @uploads_dir)
    assert File.exist?(result["path"])
    assert_equal 256, result["size"]
    assert_equal binary_data, File.binread(result["path"])
  end

  def test_save_image_file
    # Simulate a small PNG header
    png_header = "\x89PNG\r\n\x1a\n" + "\x00" * 100
    result = save_upload(png_header, "photo.png", @uploads_dir)
    assert result["path"].end_with?(".png")
    assert_equal "photo.png", result["filename"]
  end

  def test_save_pdf_file
    pdf_data = "%PDF-1.4 test content"
    result = save_upload(pdf_data, "document.pdf", @uploads_dir)
    assert result["path"].end_with?(".pdf")
    assert_equal "document.pdf", result["filename"]
  end

  def test_save_audio_file
    audio_data = "RIFF" + "\x00" * 100
    result = save_upload(audio_data, "recording.webm", @uploads_dir)
    assert result["path"].end_with?(".webm")
    assert_equal "recording.webm", result["filename"]
  end

  def test_creates_uploads_directory
    refute Dir.exist?(@uploads_dir)
    save_upload("test", "test.txt", @uploads_dir)
    assert Dir.exist?(@uploads_dir)
  end

  def test_unique_filenames
    result1 = save_upload("data1", "same.txt", @uploads_dir)
    result2 = save_upload("data2", "same.txt", @uploads_dir)
    refute_equal result1["path"], result2["path"]
  end

  def test_large_file
    large_data = "x" * (1024 * 1024) # 1MB
    result = save_upload(large_data, "large.bin", @uploads_dir)
    assert_equal 1024 * 1024, result["size"]
    assert File.exist?(result["path"])
  end

  def test_result_is_valid_json
    result = save_upload("test", "file.txt", @uploads_dir)
    json = JSON.generate(result)
    parsed = JSON.parse(json)
    assert_includes parsed.keys, "path"
    assert_includes parsed.keys, "filename"
    assert_includes parsed.keys, "size"
  end
end
