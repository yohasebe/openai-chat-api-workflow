# frozen_string_literal: true

require 'minitest/autorun'
require 'tmpdir'
require 'json'

# Load the module under test
WORKFLOW_DIR = File.expand_path("../../", __FILE__)
ALFRED_WORKFLOW_DIR = ENV["ALFRED_WORKFLOW_DIR"] || File.join(
  File.expand_path("~/Library/CloudStorage/Dropbox/alfred/Alfred.alfredpreferences/workflows"),
  "user.workflow.9B4A6B7F-DA97-4FBA-9034-E793AB9E39C2"
)

require File.join(ALFRED_WORKFLOW_DIR, "detect_browser")

class TestDetectBrowser < Minitest::Test
  def test_returns_string
    result = detect_default_browser
    assert_kind_of String, result
  end

  def test_returns_known_browser_or_false
    result = detect_default_browser
    # Should return a browser name or "false"
    refute_nil result
    refute result.empty?, "Result should not be empty"
  end

  def test_result_matches_duti_output
    # Compare with duti if available (regression test)
    duti_result = `duti -x html 2>/dev/null | awk 'NR==1'`.strip
    return if duti_result.empty? # duti not installed, skip

    our_result = detect_default_browser

    # duti returns "Google Chrome.app", ours returns "Google Chrome"
    duti_app_name = duti_result.sub(/\.app$/, "")
    assert_equal duti_app_name, our_result,
      "detect_default_browser should match duti output"
  end

  def test_output_does_not_contain_path
    result = detect_default_browser
    return if result == "false"

    refute result.include?("/"), "Result should be app name, not a path"
    refute result.end_with?(".app"), "Result should not end with .app"
  end

  def test_cli_output
    # Test when run as a script
    output = `ruby "#{File.join(ALFRED_WORKFLOW_DIR, 'detect_browser.rb')}" 2>/dev/null`.strip
    refute output.empty?
    assert_equal detect_default_browser, output
  end
end
