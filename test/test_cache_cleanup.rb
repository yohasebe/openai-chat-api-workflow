# frozen_string_literal: true

require 'minitest/autorun'
require 'tmpdir'
require 'fileutils'
require 'json'

ALFRED_WORKFLOW_DIR = ENV["ALFRED_WORKFLOW_DIR"] || File.join(
  File.expand_path("~/Library/CloudStorage/Dropbox/alfred/Alfred.alfredpreferences/workflows"),
  "user.workflow.9B4A6B7F-DA97-4FBA-9034-E793AB9E39C2"
)

# cache_cleanup.rb reads its directory from the environment at load time, so the
# variable has to be set before the require.
CACHE_TEST_DIR = Dir.mktmpdir
ENV["alfred_workflow_cache"] = CACHE_TEST_DIR
require File.join(ALFRED_WORKFLOW_DIR, "cache_cleanup")

# What the cleanup must never throw away: the conversation, the page that shows
# it, and the images that conversation still references.
class TestCacheCleanup < Minitest::Test
  def setup
    FileUtils.rm_rf(Dir.glob(File.join(CACHE_TEST_DIR, "*")))
    FileUtils.mkdir_p(uploads_dir)
  end

  def uploads_dir
    File.join(CACHE_TEST_DIR, "uploads")
  end

  def write(name, age_days: 0)
    path = File.join(CACHE_TEST_DIR, name)
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, "x" * 128)
    unless age_days.zero?
      old = Time.now - (age_days * 86_400)
      File.utime(old, old, path)
    end
    path
  end

  def write_conversation(image_ids)
    messages = image_ids.map { |id| { "role" => "assistant", "image_id" => id } }
    File.write(File.join(CACHE_TEST_DIR, "data.json"), JSON.generate({ "messages" => messages }))
  end

  def names
    (Dir.children(CACHE_TEST_DIR) - ["uploads"]).sort
  end

  def test_force_cleanup_keeps_the_conversation_and_its_page
    write_conversation([])
    %w[webui.html image_history.html pid workflow.log workflow.log.1].each { |f| write(f) }

    force_cleanup

    assert_equal %w[data.json image_history.html pid webui.html workflow.log workflow.log.1], names
  end

  def test_force_cleanup_keeps_images_the_conversation_still_shows
    write_conversation(["shown.png"])
    write("shown.png")
    write("orphan.png")

    result = force_cleanup

    assert_includes names, "shown.png"
    refute_includes names, "orphan.png"
    assert_equal 1, result[:removed]
  end

  def test_force_cleanup_removes_disposable_files
    write_conversation([])
    %w[tts_1.mp3 template_abc.html leftover.png].each { |f| write(f) }
    File.write(File.join(uploads_dir, "upload_1.webm"), "x")

    result = force_cleanup

    assert_equal ["data.json"], names
    assert_empty Dir.children(uploads_dir)
    assert_equal 4, result[:removed]
  end

  def test_auto_cleanup_leaves_recent_files_alone
    write_conversation([])
    write("tts_recent.mp3")
    write("tts_old.mp3", age_days: 30)

    auto_cleanup

    assert_includes names, "tts_recent.mp3"
    refute_includes names, "tts_old.mp3"
  end

  def test_auto_cleanup_keeps_the_newest_template
    write_conversation([])
    write("template_old.html", age_days: 30)
    write("template_newer.html", age_days: 20)

    auto_cleanup

    assert_includes names, "template_newer.html"
    refute_includes names, "template_old.html"
  end

  def test_auto_cleanup_keeps_protected_files_however_old
    write_conversation([])
    %w[webui.html image_history.html pid workflow.log].each { |f| write(f, age_days: 90) }

    auto_cleanup

    assert_equal %w[data.json image_history.html pid webui.html workflow.log], names
  end

# Generated images are named only by the image history page, not by data.json.
def write_image_history(names)
  html = names.map do |n|
    "<a href='http://127.0.0.1:8787/images/#{n}'><img src='http://127.0.0.1:8787/images/#{n}' " \
      "data-filepath='#{File.join(CACHE_TEST_DIR, n)}' /></a>"
  end.join("\n")
  File.write(File.join(CACHE_TEST_DIR, "image_history.html"), html)
end

def test_force_cleanup_keeps_images_on_the_image_history_page
  write_conversation([])
  write_image_history(["generated.png"])
  write("generated.png")
  write("orphan.png")

  force_cleanup

  assert_includes names, "generated.png"
  refute_includes names, "orphan.png"
end

def test_auto_cleanup_keeps_old_images_on_the_image_history_page
  write_conversation([])
  write_image_history(["generated.png"])
  write("generated.png", age_days: 30)

  auto_cleanup

  assert_includes names, "generated.png"
end

def test_images_lose_protection_once_the_history_page_is_gone
  write_conversation([])
  write("generated.png")

  force_cleanup

  refute_includes names, "generated.png"
end

  Minitest.after_run { FileUtils.rm_rf(CACHE_TEST_DIR) }
end
