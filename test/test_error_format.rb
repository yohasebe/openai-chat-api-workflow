# frozen_string_literal: true

require 'minitest/autorun'

# Test the error formatting helpers used by openai_chat_streaming.rb and
# openai_image_generation.rb. These are duplicated across both files, so we
# validate the contract here.

class TestErrorFormat < Minitest::Test
  # Replicate the helpers under test (same implementation as in both .rb files)

  def _html_escape(str)
    str.to_s.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;").gsub('"', "&quot;").gsub("'", "&#39;")
  end

  def _extract_request_id(msg)
    m = msg.to_s.match(/(req_[a-f0-9]+)/i)
    m ? m[1] : nil
  end

  def format_error_html(title:, status: nil, code: nil, message: nil, request_id: nil, raw: nil, debug_info: nil)
    rows = []
    rows << "<dt>Status</dt><dd>#{_html_escape(status)}</dd>" if status
    rows << "<dt>Code</dt><dd>#{_html_escape(code)}</dd>" if code
    rows << "<dt>Message</dt><dd>#{_html_escape(message)}</dd>" if message
    rows << "<dt>Request ID</dt><dd><code>#{_html_escape(request_id)}</code></dd>" if request_id
    rows << "<dt>Response</dt><dd><code>#{_html_escape(raw)}</code></dd>" if raw

    details = rows.empty? ? "" : "<dl class='error-details'>#{rows.join}</dl>"

    debug_block = ""
    if debug_info && !debug_info.empty?
      debug_block = "<details class='error-debug'><summary>Debug information</summary><pre>#{_html_escape(debug_info)}</pre></details>"
    end

    "<div class='error-box'><div class='error-title'>❗️ #{_html_escape(title)}</div>#{details}#{debug_block}</div>"
  end

  # --- HTML escape tests ---

  def test_html_escape_ampersand
    assert_equal "a&amp;b", _html_escape("a&b")
  end

  def test_html_escape_angle_brackets
    assert_equal "&lt;script&gt;", _html_escape("<script>")
  end

  def test_html_escape_quotes
    assert_equal "&quot;test&quot;", _html_escape('"test"')
  end

  def test_html_escape_apostrophe
    assert_equal "it&#39;s", _html_escape("it's")
  end

  def test_html_escape_xss_payload
    payload = "<script>alert('xss')</script>"
    escaped = _html_escape(payload)
    refute_includes escaped, "<script>"
    refute_includes escaped, "</script>"
    assert_includes escaped, "&lt;script&gt;"
  end

  def test_html_escape_nil
    assert_equal "", _html_escape(nil)
  end

  # --- Request ID extraction tests ---

  def test_extract_request_id_standard
    msg = "Your request was rejected. Include the request ID req_a4f80358fc004a1e965ca01b957acd2f"
    assert_equal "req_a4f80358fc004a1e965ca01b957acd2f", _extract_request_id(msg)
  end

  def test_extract_request_id_short
    assert_equal "req_abc123", _extract_request_id("Error with req_abc123 occurred")
  end

  def test_extract_request_id_absent
    assert_nil _extract_request_id("Some error without any request id")
  end

  def test_extract_request_id_case_insensitive
    assert_equal "REQ_ABCDEF", _extract_request_id("Error: REQ_ABCDEF failed")
  end

  def test_extract_request_id_nil
    assert_nil _extract_request_id(nil)
  end

  # --- format_error_html structure tests ---

  def test_error_box_basic_structure
    html = format_error_html(title: "Test error")
    assert_includes html, "<div class='error-box'>"
    assert_includes html, "<div class='error-title'>❗️ Test error</div>"
    assert html.end_with?("</div>")
  end

  def test_error_box_with_all_fields
    html = format_error_html(
      title: "API error",
      status: "400 Bad Request",
      code: "moderation_blocked",
      message: "Your request was rejected",
      request_id: "req_abc123"
    )
    assert_includes html, "<dt>Status</dt><dd>400 Bad Request</dd>"
    assert_includes html, "<dt>Code</dt><dd>moderation_blocked</dd>"
    assert_includes html, "<dt>Message</dt><dd>Your request was rejected</dd>"
    assert_includes html, "<dt>Request ID</dt><dd><code>req_abc123</code></dd>"
  end

  def test_error_box_omits_nil_fields
    html = format_error_html(title: "Error", message: "Only this")
    refute_includes html, "Status"
    refute_includes html, "Code"
    refute_includes html, "Request ID"
    assert_includes html, "<dt>Message</dt><dd>Only this</dd>"
  end

  def test_error_box_no_details_when_all_nil
    html = format_error_html(title: "Bare error")
    refute_includes html, "<dl"
  end

  def test_error_box_escapes_title
    html = format_error_html(title: "<script>alert(1)</script>")
    refute_includes html, "<script>"
    assert_includes html, "&lt;script&gt;alert(1)&lt;/script&gt;"
  end

  def test_error_box_escapes_message
    html = format_error_html(title: "Error", message: 'Bad "input" <dangerous>')
    refute_includes html, '<dangerous>'
    assert_includes html, "&lt;dangerous&gt;"
    assert_includes html, "&quot;input&quot;"
  end

  def test_error_box_escapes_request_id
    html = format_error_html(title: "Error", request_id: "req_<injected>")
    refute_includes html, "<injected>"
    assert_includes html, "req_&lt;injected&gt;"
  end

  def test_error_box_raw_field_uses_code_tag
    html = format_error_html(title: "Error", raw: "unexpected HTML response body")
    assert_includes html, "<dt>Response</dt><dd><code>unexpected HTML response body</code></dd>"
  end

  # --- Debug info tests ---

  def test_debug_info_creates_collapsible_section
    html = format_error_html(title: "Error", debug_info: "stack trace here")
    assert_includes html, "<details class='error-debug'>"
    assert_includes html, "<summary>Debug information</summary>"
    assert_includes html, "<pre>stack trace here</pre>"
  end

  def test_debug_info_absent_no_details_section
    html = format_error_html(title: "Error")
    refute_includes html, "error-debug"
    refute_includes html, "<details"
  end

  def test_debug_info_empty_string_omits_section
    html = format_error_html(title: "Error", debug_info: "")
    refute_includes html, "<details"
  end

  def test_debug_info_escaped
    html = format_error_html(title: "Error", debug_info: "at <frame> in /path/file.rb")
    refute_includes html, "<frame>"
    assert_includes html, "&lt;frame&gt;"
  end
end
