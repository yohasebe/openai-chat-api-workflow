# frozen_string_literal: true

require 'minitest/autorun'
require 'tmpdir'
require 'json'
require 'fileutils'

ALFRED_WORKFLOW_DIR = ENV["ALFRED_WORKFLOW_DIR"] || File.join(
  File.expand_path("~/Library/CloudStorage/Dropbox/alfred/Alfred.alfredpreferences/workflows"),
  "user.workflow.9B4A6B7F-DA97-4FBA-9034-E793AB9E39C2"
)

require File.join(ALFRED_WORKFLOW_DIR, "generate_chat_html")

class TestBuildChatHtml < Minitest::Test
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

  # --- nil / empty cases ---

  def test_nil_path_returns_nil
    assert_nil build_chat_html(nil)
  end

  def test_missing_file_returns_nil
    assert_nil build_chat_html(File.join(@tmpdir, "nonexistent.json"))
  end

  def test_empty_file_returns_nil
    path = File.join(@tmpdir, "empty.json")
    File.write(path, "")
    assert_nil build_chat_html(path)
  end

  def test_empty_messages_array
    json_path = write_json({ "model" => "gpt-5.4", "messages" => [] })
    result = build_chat_html(json_path)
    assert_kind_of Hash, result
    assert_includes result[:html], "history_json"
    refute_includes result[:html], "message user"
    refute_includes result[:html], "message assistant"
  end

  # --- system messages skipped ---

  def test_system_message_skipped
    json_path = write_json({
      "messages" => [
        { "role" => "system", "content" => "You are a helpful assistant." }
      ]
    })
    result = build_chat_html(json_path)
    # System messages should not appear as visible message divs
    refute_includes result[:html], "message system"
    # The text may still appear inside history_json (raw JSON export), but not in message divs
    refute_includes result[:html], '<div class="message system">'
  end

  # --- user messages ---

  def test_user_message_string_content
    json_path = write_json({
      "messages" => [
        { "role" => "user", "content" => "What is Ruby?" }
      ]
    })
    result = build_chat_html(json_path)
    assert_includes result[:html], "message user"
    assert_includes result[:html], "<pre>"
    assert_includes result[:html], "What is Ruby?"
  end

  def test_user_message_array_content
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
    result = build_chat_html(json_path)
    assert_includes result[:html], "Describe this image"
  end

  # --- assistant messages ---

  def test_assistant_message_markdown_raw
    json_path = write_json({
      "messages" => [
        { "role" => "assistant", "content" => "# Title\n\n**bold** text" }
      ]
    })
    result = build_chat_html(json_path)
    assert_includes result[:html], "message assistant"
    assert_includes result[:html], "markdown-raw"
    assert_includes result[:html], "# Title"
    assert_includes result[:html], "**bold** text"
  end

  # --- image handling ---

  def test_image_preview_for_jpg
    json_path = write_json({
      "messages" => [
        {
          "role" => "user",
          "content" => [{ "type" => "text", "text" => "Look" }],
          "image_id" => "photo.jpg"
        }
      ]
    })
    result = build_chat_html(json_path)
    assert_includes result[:html], "message image"
    assert_includes result[:html], "/images/photo.jpg"
  end

  def test_image_preview_for_png
    json_path = write_json({
      "messages" => [
        {
          "role" => "user",
          "content" => [{ "type" => "text", "text" => "See" }],
          "image_id" => "SCREEN.PNG"
        }
      ]
    })
    result = build_chat_html(json_path)
    assert_includes result[:html], "message image"
  end

  def test_pdf_excluded_from_image_preview
    json_path = write_json({
      "messages" => [
        {
          "role" => "user",
          "content" => [{ "type" => "text", "text" => "Read this" }],
          "image_id" => "doc.pdf"
        }
      ]
    })
    result = build_chat_html(json_path)
    refute_includes result[:html], "message image"
  end

  def test_null_image_id_ignored
    json_path = write_json({
      "messages" => [
        {
          "role" => "user",
          "content" => "hello",
          "image_id" => "null"
        }
      ]
    })
    result = build_chat_html(json_path)
    refute_includes result[:html], "message image"
  end

  # --- multiple messages ---

  def test_multiple_exchanges
    json_path = write_json({
      "messages" => [
        { "role" => "system", "content" => "You are helpful." },
        { "role" => "user", "content" => "First question" },
        { "role" => "assistant", "content" => "First answer" },
        { "role" => "user", "content" => "Second question" },
        { "role" => "assistant", "content" => "Second answer" }
      ]
    })
    result = build_chat_html(json_path)

    # System message should be skipped
    refute_includes result[:html], "message system"

    # All user and assistant messages should be present
    assert_includes result[:html], "First question"
    assert_includes result[:html], "First answer"
    assert_includes result[:html], "Second question"
    assert_includes result[:html], "Second answer"
  end

  # --- JSON export ---

  def test_history_json_embedded
    json_path = write_json({
      "model" => "gpt-5.4",
      "messages" => [{ "role" => "assistant", "content" => "hi" }]
    })
    result = build_chat_html(json_path)
    assert_includes result[:html], "history_json"
    assert_includes result[:html], "display:none"
    assert_kind_of String, result[:json_content]
    parsed = JSON.parse(result[:json_content])
    assert_equal "gpt-5.4", parsed["model"]
  end

  # --- HTML escaping ---

  def test_html_escaping_in_user_content
    json_path = write_json({
      "messages" => [
        { "role" => "user", "content" => "<script>alert('xss')</script>" }
      ]
    })
    result = build_chat_html(json_path)
    refute_includes result[:html], "<script>alert"
    assert_includes result[:html], "&lt;script&gt;"
  end

  def test_html_escaping_in_assistant_content
    json_path = write_json({
      "messages" => [
        { "role" => "assistant", "content" => "<img onerror=alert(1)>" }
      ]
    })
    result = build_chat_html(json_path)
    refute_includes result[:html], "<img onerror"
    assert_includes result[:html], "&lt;img onerror"
  end

  def test_html_escaping_in_image_id
    json_path = write_json({
      "messages" => [
        {
          "role" => "user",
          "content" => "test",
          "image_id" => "x\"><script>alert(1)</script>.jpg"
        }
      ]
    })
    result = build_chat_html(json_path)
    refute_includes result[:html], "<script>alert"
  end
end
