# frozen_string_literal: true

require 'minitest/autorun'
require 'json'
require 'tmpdir'
require 'fileutils'
require 'stringio'

ALFRED_WORKFLOW_DIR = ENV["ALFRED_WORKFLOW_DIR"] || File.join(
  File.expand_path("~/Library/CloudStorage/Dropbox/alfred/Alfred.alfredpreferences/workflows"),
  "user.workflow.9B4A6B7F-DA97-4FBA-9034-E793AB9E39C2"
)

REQUEST_TEST_CACHE = Dir.mktmpdir
ENV["alfred_workflow_cache"] = REQUEST_TEST_CACHE
require File.join(ALFRED_WORKFLOW_DIR, "openai_chat_streaming")

# The request body is read from what the real code sends, not rebuilt here. An
# earlier version of this test copied the construction logic, so it kept
# passing when the code and the copy disagreed.
module CapturedRequest
  class << self
    attr_accessor :body
  end
end

class Net::HTTP
  def request(req, *_args)
    CapturedRequest.body = JSON.parse(req.body)
    reply = { "status" => "completed", "output" => [
      { "type" => "message", "role" => "assistant", "content" => [{ "type" => "output_text", "text" => "OK" }] }
    ] }.to_json
    response = Net::HTTPOK.new("1.1", "200", "OK")
    response.instance_variable_set(:@read, true)
    response.instance_variable_set(:@body, reply)
    block_given? ? yield(response) : response
  end
end

class IO
  class << self
    alias_method :_original_popen, :popen
    def popen(cmd, *args, &blk)
      return nil if cmd.to_s.include?("pbcopy")
      _original_popen(cmd, *args, &blk)
    end
  end
end

class TestRequestBody < Minitest::Test
  DATA_PATH = File.join(REQUEST_TEST_CACHE, "data.json")

  def setup
    File.delete(DATA_PATH) if File.exist?(DATA_PATH)
    CapturedRequest.body = nil
  end

  def send_query(model:, effort: :omit, mode: "general", history: nil)
    File.write(DATA_PATH, history.to_json) if history
    args = { mode: mode, text: "hello", apikey: "test-key", model: model, max_tokens: 4000, speak: false,
             max_characters: 10_000, timeout_sec: 30, api_base: "https://api.openai.com/v1", debug: false,
             memory_span: 20, silent: true, data_path: DATA_PATH }
    args[:reasoning_effort] = effort unless effort == :omit
    text_query(**args)
    CapturedRequest.body
  end

  def test_none_is_sent_explicitly
    body = send_query(model: "gpt-6-luna", effort: "none")
    assert_equal({ "effort" => "none" }, body["reasoning"],
                 "leaving reasoning out makes the API use medium, so none has to be sent")
  end

  def test_a_supported_effort_is_kept
    assert_equal "medium", send_query(model: "gpt-6-luna", effort: "medium").dig("reasoning", "effort")
  end

  def test_an_omitted_effort_becomes_the_models_lowest
    assert_equal "none", send_query(model: "gpt-6-luna").dig("reasoning", "effort")
    assert_equal "low", send_query(model: "gpt-6-astra").dig("reasoning", "effort")
  end

  def test_an_unsupported_effort_falls_back
    assert_equal "low", send_query(model: "gpt-6-astra", effort: "none").dig("reasoning", "effort")
    assert_equal "low", send_query(model: "gpt-6.1-sol", effort: "none").dig("reasoning", "effort")
  end

  def test_a_removed_model_falls_back_to_the_default
    body = send_query(model: "gpt-5-mini", effort: "minimal")
    assert_equal ModelConfig::DEFAULT_CHAT_MODEL, body["model"]
    assert_equal "none", body.dig("reasoning", "effort")
  end

  # A continued chat reads its saved model and effort back from data.json.
  # Those must not overwrite the values text_query has already checked.
  def test_saved_history_does_not_undo_the_checks
    history = { "model" => "gpt-5-mini", "reasoning_effort" => "minimal", "messages" => [
      { "role" => "system", "content" => "SYSTEM" },
      { "role" => "user", "content" => [{ "type" => "text", "text" => "earlier" }] },
      { "role" => "assistant", "content" => "answer" }
    ] }
    body = send_query(model: "gpt-6-astra", effort: "none", mode: "chat", history: history)
    assert_equal "gpt-6-astra", body["model"]
    assert_equal "low", body.dig("reasoning", "effort")
    assert_equal "SYSTEM", body["instructions"]
  end

  def test_max_output_tokens_is_not_sent_to_reasoning_models
    refute send_query(model: "gpt-6-luna", effort: "none").key?("max_output_tokens")
  end

  def test_truncation_and_store
    body = send_query(model: "gpt-6-luna", effort: "none")
    assert_equal "auto", body["truncation"]
    assert_equal false, body["store"]
    refute body.key?("context_management")
  end
end
