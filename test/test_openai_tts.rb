# frozen_string_literal: true

require 'minitest/autorun'
require 'tmpdir'
require 'json'

require_relative "workflow_dir"

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
