# frozen_string_literal: true

require 'minitest/autorun'
require 'tmpdir'
require 'json'
require 'fileutils'

ALFRED_WORKFLOW_DIR = ENV["ALFRED_WORKFLOW_DIR"] || File.join(
  File.expand_path("~/Library/CloudStorage/Dropbox/alfred/Alfred.alfredpreferences/workflows"),
  "user.workflow.9B4A6B7F-DA97-4FBA-9034-E793AB9E39C2"
)

require File.join(ALFRED_WORKFLOW_DIR, "generate_history_html")

class TestBuildHistoryHtml < Minitest::Test
  def setup
    @tmpdir = Dir.mktmpdir
  end

  def teardown
    FileUtils.rm_rf(@tmpdir)
  end

  def write_json(data)
    path = File.join(@tmpdir, "data.json")
    File.write(path, JSON.generate(data))
    path
  end

  def test_basic_assistant_message
    json_path = write_json({
      "model" => "gpt-5.4",
      "messages" => [
        { "role" => "assistant", "content" => "Hello **world**" }
      ]
    })

    result = build_history_html(json_path)
    assert_includes result[:html], "message assistant"
    assert_includes result[:html], "openai-response"
    # Assistant content should be wrapped in markdown-raw for client-side rendering
    assert_includes result[:html], "markdown-raw"
    assert_includes result[:html], "Hello **world**"
  end

  def test_user_message_with_text_string
    json_path = write_json({
      "messages" => [
        { "role" => "user", "content" => "What is Ruby?" }
      ]
    })

    result = build_history_html(json_path)
    assert_includes result[:html], "message user"
    assert_includes result[:html], "<pre>"
    assert_includes result[:html], "What is Ruby?"
  end

  def test_user_message_with_content_array
    json_path = write_json({
      "messages" => [
        {
          "role" => "user",
          "content" => [
            { "type" => "text", "text" => "Describe this image" },
            { "type" => "image", "image_url" => { "url" => "data:image/png;base64,abc" } }
          ]
        }
      ]
    })

    result = build_history_html(json_path)
    assert_includes result[:html], "Describe this image"
  end

  def test_image_preview_non_pdf
    json_path = write_json({
      "messages" => [
        {
          "role" => "user",
          "content" => [{ "type" => "text", "text" => "Look" }],
          "image_id" => "photo.jpg"
        }
      ]
    })

    result = build_history_html(json_path)
    assert_includes result[:html], "message image"
    assert_includes result[:html], "/images/photo.jpg"
  end

  def test_image_preview_pdf_excluded
    json_path = write_json({
      "messages" => [
        {
          "role" => "user",
          "content" => [{ "type" => "text", "text" => "Read this" }],
          "image_id" => "doc.pdf"
        }
      ]
    })

    result = build_history_html(json_path)
    refute_includes result[:html], "message image"
  end

  def test_parameters_section
    json_path = write_json({
      "model" => "gpt-5.4",
      "temperature" => 0.7,
      "messages" => []
    })

    result = build_history_html(json_path)
    assert_includes result[:html], "model: gpt-5.4"
    assert_includes result[:html], "temperature: 0.7"
    refute_includes result[:html], "<li>messages:"
  end

  def test_json_content_embedded
    json_path = write_json({
      "model" => "gpt-5.4",
      "messages" => [{ "role" => "assistant", "content" => "hi" }]
    })

    result = build_history_html(json_path)
    assert_includes result[:html], "history_json"
    assert_kind_of String, result[:json_content]
    JSON.parse(result[:json_content])
  end

  def test_html_escaping_in_user_content
    json_path = write_json({
      "messages" => [
        { "role" => "user", "content" => "<script>alert('xss')</script>" }
      ]
    })

    result = build_history_html(json_path)
    refute_includes result[:html], "<script>alert"
    assert_includes result[:html], "&lt;script&gt;"
  end

  def test_empty_messages
    json_path = write_json({ "messages" => [] })

    result = build_history_html(json_path)
    assert_includes result[:html], "openai-response"
    assert_kind_of String, result[:html]
  end

  def test_system_role_message
    json_path = write_json({
      "messages" => [
        { "role" => "system", "content" => "You are a helpful assistant." }
      ]
    })

    result = build_history_html(json_path)
    assert_includes result[:html], "message system"
    assert_includes result[:html], "<pre>"
  end

  def test_assistant_markdown_raw_wrapper
    json_path = write_json({
      "messages" => [
        { "role" => "assistant", "content" => "# Title\n\n**bold** text" }
      ]
    })

    result = build_history_html(json_path)
    # Should wrap in markdown-raw div for client-side rendering
    assert_includes result[:html], "markdown-raw"
    # Raw markdown should be HTML-escaped (for safety)
    assert_includes result[:html], "# Title"
    assert_includes result[:html], "**bold** text"
  end

  def test_generate_history_page_creates_file
    json_path = write_json({
      "model" => "gpt-5.4",
      "messages" => [
        { "role" => "user", "content" => "Hello" },
        { "role" => "assistant", "content" => "Hi there!" }
      ]
    })

    output_path = File.join(@tmpdir, "history.html")

    # Need to run from workflow dir for template files
    Dir.chdir(ALFRED_WORKFLOW_DIR) do
      result = generate_history_page(
        json_path: json_path,
        cache_file: output_path,
        ui_mode_setting: "light"
      )
      assert_equal "true", result
    end

    assert File.exist?(output_path)
    content = File.read(output_path)
    assert_includes content, "<!DOCTYPE html>"
    assert_includes content, "marked.min.js"
    assert_includes content, "Hi there!"
  end
end
