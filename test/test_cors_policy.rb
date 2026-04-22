# frozen_string_literal: true

require 'minitest/autorun'

# Test the CORS origin whitelist regex used by the WEBrick server embedded in
# info.plist. The regex must allow requests only from loopback origins to
# prevent cross-origin access to the local Web UI endpoints from unrelated
# websites the user may have open in another browser tab.

class TestCorsPolicy < Minitest::Test
  # Same regex as the apply_cors lambda in info.plist
  ORIGIN_RE = %r{\Ahttps?://(localhost|127\.0\.0\.1)(:\d+)?\z}

  def allowed?(origin)
    origin.to_s.match?(ORIGIN_RE)
  end

  # --- Allowed origins ---

  def test_allows_http_localhost
    assert allowed?("http://localhost")
  end

  def test_allows_https_localhost
    assert allowed?("https://localhost")
  end

  def test_allows_localhost_with_port
    assert allowed?("http://localhost:8787")
    assert allowed?("http://localhost:8080")
    assert allowed?("http://localhost:1")
    assert allowed?("http://localhost:65535")
  end

  def test_allows_127_0_0_1
    assert allowed?("http://127.0.0.1")
    assert allowed?("http://127.0.0.1:8787")
    assert allowed?("https://127.0.0.1:8080")
  end

  # --- Denied origins ---

  def test_rejects_empty_string
    refute allowed?("")
  end

  def test_rejects_nil
    refute allowed?(nil)
  end

  def test_rejects_external_domain
    refute allowed?("http://evil.com")
    refute allowed?("https://attacker.example.com")
  end

  def test_rejects_subdomain_trick
    # Must not be fooled by domains that end with "localhost"
    refute allowed?("http://localhost.evil.com")
    refute allowed?("http://evil.localhost")
  end

  def test_rejects_loopback_lookalikes
    # Only exact 127.0.0.1 is allowed; 127.0.0.2 and other private IPs are not
    refute allowed?("http://127.0.0.2")
    refute allowed?("http://10.0.0.1")
    refute allowed?("http://192.168.1.1")
    refute allowed?("http://0.0.0.0")
  end

  def test_rejects_ipv6_loopback
    # IPv6 loopback [::1] is not currently whitelisted — WEBrick binds to IPv4
    refute allowed?("http://[::1]")
    refute allowed?("http://[::1]:8787")
  end

  def test_rejects_embedded_loopback
    # Prevent userinfo / path injection tricks
    refute allowed?("http://localhost@evil.com")
    refute allowed?("http://localhost/path")
    refute allowed?("http://localhost:8787/../")
  end

  def test_rejects_javascript_scheme
    refute allowed?("javascript://localhost")
    refute allowed?("data:text/html,<script>")
    refute allowed?("file:///")
  end

  def test_rejects_unusual_schemes
    refute allowed?("ws://localhost")
    refute allowed?("ftp://localhost")
  end

  def test_rejects_uppercase_scheme
    # The regex is case-sensitive by design; browsers send lowercase schemes
    refute allowed?("HTTP://localhost")
  end

  def test_rejects_trailing_characters
    refute allowed?("http://localhost\n")
    refute allowed?("http://localhost ")
    refute allowed?("http://localhost\t")
  end

  def test_rejects_port_with_non_digit
    refute allowed?("http://localhost:abc")
    refute allowed?("http://localhost:80a")
  end

  def test_rejects_null_origin
    # Browsers send "null" Origin for sandboxed/file contexts
    refute allowed?("null")
  end
end
