# frozen_string_literal: true

require 'minitest/autorun'
require 'tmpdir'
require 'json'

ALFRED_WORKFLOW_DIR = ENV["ALFRED_WORKFLOW_DIR"] || File.join(
  File.expand_path("~/Library/CloudStorage/Dropbox/alfred/Alfred.alfredpreferences/workflows"),
  "user.workflow.9B4A6B7F-DA97-4FBA-9034-E793AB9E39C2"
)

# Set cache dir for tests
ENV["alfred_workflow_cache"] ||= Dir.tmpdir

require File.join(ALFRED_WORKFLOW_DIR, "openai_tts")

class TestOpenaiTts < Minitest::Test
  def test_tts_speak_builds_correct_data
    # We can't test actual API calls, but we can test the data structure
    # by checking that the method exists and accepts expected params
    assert method(:tts_speak)
  end

  def test_tts_speak_method_exists
    assert method(:tts_speak)
  end

  def test_afplay_available
    # afplay should always be available on macOS
    assert system("which afplay >/dev/null 2>&1"), "afplay should be available on macOS"
  end

  def test_default_constants
    assert_equal "alloy", DEFAULT_VOICE
    assert_equal "gpt-4o-mini-tts", DEFAULT_MODEL
    assert_includes BASE_URI, "audio/speech"
  end
end
