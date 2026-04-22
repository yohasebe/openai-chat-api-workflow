# frozen_string_literal: true

require 'minitest/autorun'
require 'json'

# Test truncation configuration logic
# (replaces the old compaction-based context management)

class TestTruncation < Minitest::Test
  # Build Responses API request data with truncation (mirrors openai_chat_streaming.rb)
  def build_responses_data(model:, messages:, reasoning_effort: nil)
    data = {
      "model" => model,
      "input" => messages,
      "instructions" => "You are a helpful assistant.",
      "stream" => true,
      "store" => false
    }

    # Add reasoning only when effort is not "none"
    if reasoning_effort && reasoning_effort != "none"
      data["reasoning"] = { "effort" => reasoning_effort }
    end

    # Always use truncation for long conversation handling
    data["truncation"] = "auto"

    data
  end

  def test_truncation_is_always_set
    data = build_responses_data(model: "gpt-5.4-mini", messages: [])
    assert_equal "auto", data["truncation"]
  end

  def test_store_is_false
    data = build_responses_data(model: "gpt-5.4-mini", messages: [])
    assert_equal false, data["store"]
  end

  def test_no_context_management_key
    data = build_responses_data(model: "gpt-5.4-mini", messages: [])
    refute data.key?("context_management"), "context_management should not be present"
  end

  def test_reasoning_omitted_when_none
    data = build_responses_data(model: "gpt-5.4", messages: [], reasoning_effort: "none")
    refute data.key?("reasoning"), "reasoning should be omitted when effort is 'none'"
  end

  def test_reasoning_included_when_not_none
    data = build_responses_data(model: "gpt-5-mini", messages: [], reasoning_effort: "minimal")
    assert_equal({ "effort" => "minimal" }, data["reasoning"])
  end

  def test_reasoning_included_when_medium
    data = build_responses_data(model: "gpt-5.3-chat-latest", messages: [], reasoning_effort: "medium")
    assert_equal({ "effort" => "medium" }, data["reasoning"])
  end

  def test_reasoning_omitted_when_nil
    data = build_responses_data(model: "gpt-5.4", messages: [], reasoning_effort: nil)
    refute data.key?("reasoning"), "reasoning should be omitted when effort is nil"
  end

  def test_valid_json_output
    data = build_responses_data(
      model: "gpt-5.4-mini",
      messages: [{ "role" => "user", "content" => "Hello" }],
      reasoning_effort: "low"
    )
    json = JSON.generate(data)
    parsed = JSON.parse(json)
    assert_equal "auto", parsed["truncation"]
    assert_equal false, parsed["store"]
    assert_equal "low", parsed.dig("reasoning", "effort")
  end
end
