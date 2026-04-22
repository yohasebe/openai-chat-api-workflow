# frozen_string_literal: true

require 'minitest/autorun'
require 'json'

# Test phase detection logic from openai_chat_streaming.rb in isolation

class TestPhaseSupport < Minitest::Test
  # Simulate the phase detection from response.output_item.added events
  def detect_phase(event_json)
    event_json.dig("item", "phase")
  end

  def test_phase_commentary_detected
    event = {
      "type" => "response.output_item.added",
      "item" => {
        "type" => "reasoning",
        "phase" => "commentary",
        "id" => "item_001"
      }
    }
    assert_equal "commentary", detect_phase(event)
  end

  def test_phase_final_answer_detected
    event = {
      "type" => "response.output_item.added",
      "item" => {
        "type" => "message",
        "phase" => "final_answer",
        "id" => "item_002"
      }
    }
    assert_equal "final_answer", detect_phase(event)
  end

  def test_no_phase_field
    # Non-phase models don't have phase field
    event = {
      "type" => "response.output_item.added",
      "item" => {
        "type" => "message",
        "id" => "item_003"
      }
    }
    assert_nil detect_phase(event)
  end

  def test_phase_control_message_format
    # The control message sent via WebSocket
    phase = "commentary"
    msg = "PHASE:#{phase}"
    assert_equal "PHASE:commentary", msg
    assert msg.start_with?("PHASE:")
    assert_equal "commentary", msg.sub("PHASE:", "")
  end

  def test_phase_control_message_final_answer
    phase = "final_answer"
    msg = "PHASE:#{phase}"
    assert_equal "PHASE:final_answer", msg
    assert_equal "final_answer", msg.sub("PHASE:", "")
  end

  def test_end_of_stream_not_confused_with_phase
    msg = "END_OF_STREAM"
    refute msg.start_with?("PHASE:")
  end

  def test_regular_text_not_confused_with_phase
    msg = "Hello world"
    refute msg.start_with?("PHASE:")
    refute_equal "END_OF_STREAM", msg
  end
end
