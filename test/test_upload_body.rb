# frozen_string_literal: true

require 'minitest/autorun'
require 'json'
require 'tmpdir'
require 'fileutils'

require_relative "workflow_dir"

UPLOAD_TEST_CACHE = Dir.mktmpdir
ENV["alfred_workflow_cache"] = UPLOAD_TEST_CACHE
require File.join(ALFRED_WORKFLOW_DIR, "openai_chat_streaming")

# Runs the real upload_to_openai_files and inspects the bytes it would send.
# The tests in test_files_api_upload.rb rebuild the body themselves, so they
# could not see that a non-ASCII filename broke the real one.
module CapturedUpload
  class << self
    attr_accessor :body
  end
end

class Net::HTTP
  def request(req, *_args)
    CapturedUpload.body = req.body
    response = Net::HTTPOK.new("1.1", "200", "OK")
    response.instance_variable_set(:@read, true)
    response.instance_variable_set(:@body, { "id" => "file-test" }.to_json)
    block_given? ? yield(response) : response
  end
end

class TestUploadBody < Minitest::Test
  BINARY = "PK\x03\x04\xFF\xFE\x00\x80binary".b

  def setup
    @dir = Dir.mktmpdir
    CapturedUpload.body = nil
  end

  def teardown
    FileUtils.rm_rf(@dir)
  end

  def upload(name, filename: nil)
    path = File.join(@dir, name)
    File.binwrite(path, BINARY)
    id = upload_to_openai_files(apikey: "test-key", file_path: path, filename: filename)
    [id, CapturedUpload.body]
  end

  def test_an_ascii_filename
    id, body = upload("slides.pptx")
    assert_equal "file-test", id
    assert_includes body, 'filename="slides.pptx"'.b
    assert_includes body, BINARY
  end

  # A Japanese filename with binary content raised "incompatible character
  # encodings: UTF-8 and ASCII-8BIT" before anything was sent.
  def test_a_non_ascii_filename_with_binary_content
    id, body = upload("cache-copy.pptx", filename: "会議資料.pptx")
    assert_equal "file-test", id
    assert_includes body, "filename=\"会議資料.pptx\"".b
    assert_includes body, BINARY
  end

  def test_a_non_ascii_name_taken_from_the_path
    _id, body = upload("報告書.docx")
    assert_includes body, "filename=\"報告書.docx\"".b
  end
end

Minitest.after_run { FileUtils.rm_rf(UPLOAD_TEST_CACHE) }
