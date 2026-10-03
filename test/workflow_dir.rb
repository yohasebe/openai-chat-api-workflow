# frozen_string_literal: true

# Where the tests load the workflow's code from.
#
# ALFRED_WORKFLOW_DIR, when set, points at a working copy of the workflow (the
# folder Alfred runs it from). Otherwise the tests unpack the bundle this
# repository ships into a temporary directory, so they check exactly what users
# download and need nothing outside the repository.

require "tmpdir"
require "fileutils"

ALFRED_WORKFLOW_DIR = ENV["ALFRED_WORKFLOW_DIR"] || begin
  bundle = File.expand_path("../openai-chat-api.alfredworkflow", __dir__)
  abort "#{bundle} not found; set ALFRED_WORKFLOW_DIR to a copy of the workflow." unless File.file?(bundle)
  dir = Dir.mktmpdir("workflow-")
  system("unzip", "-q", bundle, "-d", dir) or abort "Could not unpack #{File.basename(bundle)}."
  # Remove it after the tests, not at exit: minitest runs the tests from its own
  # at_exit handler, which would come after one registered here.
  if defined?(Minitest)
    Minitest.after_run { FileUtils.rm_rf(dir) }
  else
    at_exit { FileUtils.rm_rf(dir) }
  end
  dir
end
