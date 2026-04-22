# frozen_string_literal: true

require 'minitest/autorun'
require 'tmpdir'
require 'fileutils'

ALFRED_WORKFLOW_DIR = ENV["ALFRED_WORKFLOW_DIR"] || File.join(
  File.expand_path("~/Library/CloudStorage/Dropbox/alfred/Alfred.alfredpreferences/workflows"),
  "user.workflow.9B4A6B7F-DA97-4FBA-9034-E793AB9E39C2"
)

require File.join(ALFRED_WORKFLOW_DIR, "assemble_page")

class TestAssemblePage < Minitest::Test
  def setup
    @tmpdir = Dir.mktmpdir
  end

  def teardown
    FileUtils.rm_rf(@tmpdir)
  end

  def write_file(name, content)
    path = File.join(@tmpdir, name)
    File.write(path, content)
    path
  end

  def test_basic_assembly
    css = write_file("css.html", "<style>body { color: red; }</style>")
    top = write_file("top.html", "<div id='top'>Header</div>")
    bottom = write_file("bottom.html", "<div id='bottom'>Footer</div>")

    html = assemble_page(
      head_files: [css],
      before_body_files: [top],
      after_body_files: [bottom],
      body_content: "<p>Hello</p>"
    )

    assert_includes html, "<!DOCTYPE html>"
    assert_includes html, "<style>body { color: red; }</style>"
    assert_includes html, "<div id='top'>Header</div>"
    assert_includes html, "<p>Hello</p>"
    assert_includes html, "<div id='bottom'>Footer</div>"
  end

  def test_title
    html = assemble_page(title: "My Custom Title")
    assert_includes html, "<title>My Custom Title</title>"
  end

  def test_title_escaping
    html = assemble_page(title: "Test <script>alert(1)</script>")
    refute_includes html, "<script>alert(1)</script>"
    assert_includes html, "&lt;script&gt;"
  end

  def test_output_to_file
    output = File.join(@tmpdir, "output.html")
    result = assemble_page(
      body_content: "<p>test</p>",
      output_path: output
    )

    assert_equal true, result
    assert File.exist?(output)
    content = File.read(output)
    assert_includes content, "<p>test</p>"
  end

  def test_multiple_head_files
    css1 = write_file("css1.html", "<style>.a{}</style>")
    css2 = write_file("css2.html", "<style>.b{}</style>")

    html = assemble_page(head_files: [css1, css2])
    assert_includes html, "<style>.a{}</style>"
    assert_includes html, "<style>.b{}</style>"
  end

  def test_empty_content
    html = assemble_page(body_content: "")
    assert_includes html, "<!DOCTYPE html>"
    assert_includes html, "</html>"
  end

  def test_markdown_content_preserved
    # Markdown should pass through unchanged (for client-side rendering)
    md = "# Hello\n\n**bold** and *italic*\n\n```ruby\nputs 'hi'\n```"
    html = assemble_page(body_content: md)
    assert_includes html, "# Hello"
    assert_includes html, "**bold**"
    assert_includes html, "```ruby"
  end

  def test_h_escapes_html_entities
    assert_equal "&amp;", h("&")
    assert_equal "&lt;script&gt;", h("<script>")
    assert_equal "a&quot;b", h('a"b')
  end

  def test_h_escapes_single_quotes
    assert_equal "it&#39;s", h("it's")
  end

  def test_h_handles_nil
    assert_equal "", h(nil)
  end

  def test_template_caching
    ENV["alfred_workflow_cache"] = @tmpdir
    css = write_file("css.html", "<style>.x{}</style>")
    top = write_file("top.html", "<div>top</div>")
    out1 = File.join(@tmpdir, "out1.html")
    out2 = File.join(@tmpdir, "out2.html")

    assemble_page(
      head_files: [css],
      before_body_files: [top],
      body_content: "<p>first</p>",
      output_path: out1
    )

    # Second call should use cache
    assemble_page(
      head_files: [css],
      before_body_files: [top],
      body_content: "<p>second</p>",
      output_path: out2
    )

    assert_includes File.read(out1), "<p>first</p>"
    assert_includes File.read(out2), "<p>second</p>"
    # Both should have the same template structure
    assert_includes File.read(out2), "<style>.x{}</style>"
  end

  def test_cache_invalidation_on_file_change
    ENV["alfred_workflow_cache"] = @tmpdir
    css = write_file("css.html", "<style>.old{}</style>")
    out1 = File.join(@tmpdir, "out1.html")
    out2 = File.join(@tmpdir, "out2.html")

    assemble_page(head_files: [css], body_content: "a", output_path: out1)

    sleep 0.1
    File.write(css, "<style>.new{}</style>")

    assemble_page(head_files: [css], body_content: "b", output_path: out2)

    assert_includes File.read(out2), "<style>.new{}</style>"
  end

  def test_detect_ui_suffix_light
    assert_equal "", detect_ui_suffix("light")
  end

  def test_detect_ui_suffix_dark
    assert_equal "-dark", detect_ui_suffix("dark")
  end

  def test_detect_ui_suffix_auto
    result = detect_ui_suffix("auto")
    assert_includes ["", "-dark"], result
  end
end
