# frozen_string_literal: true

require 'minitest/autorun'
require 'tmpdir'
require 'fileutils'

require_relative "workflow_dir"
require File.join(ALFRED_WORKFLOW_DIR, "api_key")

# Every value here is synthetic. The 1Password CLI is replaced by a small
# script on PATH, and the keychain lookup is replaced by a stub, so nothing
# real is read.
class TestApiKey < Minitest::Test
  SYNTHETIC = "sk-test-SYNTHETIC-0000"

  def setup
    @dir = Dir.mktmpdir
    @path = ENV["PATH"]
    @locations = ApiKey::OP_LOCATIONS
    # Keep a real `op` installed on this Mac out of the picture.
    replace_const(:OP_LOCATIONS, [])
  end

  def teardown
    ENV["PATH"] = @path
    replace_const(:OP_LOCATIONS, @locations)
    FileUtils.rm_rf(@dir)
  end

  def replace_const(name, value)
    ApiKey.send(:remove_const, name)
    ApiKey.const_set(name, value)
  end

  def fake_op(body)
    path = File.join(@dir, "op")
    File.write(path, "#!/bin/sh\n#{body}\n")
    File.chmod(0o755, path)
    ENV["PATH"] = "#{@dir}:/usr/bin:/bin"
  end

  # Replaces ApiKey.run for one block. Written out rather than using
  # minitest/mock, which newer minitest no longer ships.
  def with_run(fake)
    original = ApiKey.method(:run)
    ApiKey.define_singleton_method(:run) { |argv| fake.call(argv) }
    yield
  ensure
    ApiKey.define_singleton_method(:run, original)
  end
  
  def error_for(setting)
    ApiKey.resolve(setting)
    flunk "expected an error for #{setting.inspect}"
  rescue ApiKey::Error => e
    e.message
  end

  def test_a_plain_key_is_used_as_is
    assert_equal SYNTHETIC, ApiKey.resolve("  #{SYNTHETIC}  ")
  end

  def test_an_empty_setting_says_so
    assert_match(/not set/, error_for(""))
  end

  def test_a_1password_reference_is_read_with_op
    fake_op(%(if [ "$1" = read ] && [ "$2" = "op://Test/Item/credential" ]; then echo "#{SYNTHETIC}"; else exit 1; fi))
    assert_equal SYNTHETIC, ApiKey.resolve("op://Test/Item/credential")
  end

  def test_a_reference_with_spaces_reaches_op_as_one_argument
    fake_op(%(if [ "$2" = "op://Private/OpenAI API/credential" ]; then echo "#{SYNTHETIC}"; else exit 1; fi))
    assert_equal SYNTHETIC, ApiKey.resolve("op://Private/OpenAI API/credential")
  end

  def test_op_missing
    ENV["PATH"] = "#{@dir}:/usr/bin:/bin"
    assert_match(/1Password CLI \(op\) was not found/, error_for("op://Test/Item/credential"))
  end

  def test_op_not_signed_in
    fake_op(%(echo "[ERROR] 2026/10/03 You are not currently signed in." >&2; exit 1))
    assert_match(/not signed in/, error_for("op://Test/Item/credential"))
  end

  def test_unknown_item
    fake_op(%(echo "[ERROR] could not read secret: isn't an item in any vault" >&2; exit 1))
    message = error_for("op://Test/Missing/credential")
    assert_match(%r{Could not read op://Test/Missing/credential}, message)
  end

  def test_an_empty_answer_is_an_error
    fake_op("exit 0")
    assert_match(/is empty/, error_for("op://Test/Item/credential"))
  end

  def test_op_is_given_up_on_after_the_timeout
    fake_op("sleep 5")
    replace_const(:TIMEOUT_SEC, 1)
    assert_match(/did not answer/, error_for("op://Test/Item/credential"))
  ensure
    replace_const(:TIMEOUT_SEC, 60)
  end

  def test_a_keychain_reference
    calls = []
    with_run(->(argv) { calls << argv; ["#{SYNTHETIC}\n", "", Struct.new(:success?).new(true)] }) do
      assert_equal SYNTHETIC, ApiKey.resolve("keychain:openai-test")
    end
    assert_equal [["/usr/bin/security", "find-generic-password", "-s", "openai-test", "-w"]], calls
  end

  def test_a_missing_keychain_item
    with_run(->(_argv) { ["", "item not found", Struct.new(:success?).new(false)] }) do
      assert_match(/No keychain item named "openai-test"/, error_for("keychain:openai-test"))
    end
  end

  def test_keychain_without_a_name
    assert_match(/without a name/, error_for("keychain:"))
  end

  # Whatever happens, the value never appears in a message.
  def test_messages_never_carry_the_value
    fake_op(%(echo "#{SYNTHETIC}"; echo "#{SYNTHETIC}"))
    refute_includes error_for("op://Test/Item/credential"), SYNTHETIC
  end
end
