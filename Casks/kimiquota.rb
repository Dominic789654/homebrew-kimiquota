cask "kimiquota" do
  version "1.0.0"
  sha256 :no_check

  url "https://github.com/Dominic789654/KimiQuota/archive/refs/tags/v#{version}.tar.gz"
  name "KimiQuota"
  desc "macOS menu bar app to check Kimi Coding Plan quota"
  homepage "https://github.com/Dominic789654/KimiQuota"

  depends_on macos: ">= :sonoma"
  depends_on formula: "python@3.12"

  # Create the app bundle
  preflight do
    # Create bin directory
    FileUtils.mkdir_p "#{staged_path}/bin"
    
    # Find Python path
    python_path = if File.exist?("#{HOMEBREW_PREFIX}/opt/python@3.12/bin/python3.12")
      "#{HOMEBREW_PREFIX}/opt/python@3.12/bin/python3.12"
    elsif File.exist?("/opt/homebrew/opt/python@3.12/bin/python3.12")
      "/opt/homebrew/opt/python@3.12/bin/python3.12"
    elsif File.exist?("/usr/local/opt/python@3.12/bin/python3.12")
      "/usr/local/opt/python@3.12/bin/python3.12"
    else
      "/usr/bin/python3"
    end
    
    # Create kimiquota wrapper
    File.write("#{staged_path}/bin/kimiquota", <<~EOS)
      #!/bin/bash
      cd "#{staged_path}"
      PYTHON="#{python_path}"
      if [ ! -f "$PYTHON" ]; then
        PYTHON="python3"
      fi
      "$PYTHON" -c "import rumps" 2>/dev/null || "$PYTHON" -m pip install --user rumps requests 2>/dev/null || pip3 install --user rumps requests 2>/dev/null
      exec "$PYTHON" "KimiQuotaMenuBar.app/Contents/MacOS/kimi_menu.py" "$@"
    EOS
    FileUtils.chmod 0755, "#{staged_path}/bin/kimiquota"
    
    # Create kimiquota-cli wrapper
    File.write("#{staged_path}/bin/kimiquota-cli", <<~EOS)
      #!/bin/bash
      cd "#{staged_path}"
      PYTHON="#{python_path}"
      if [ ! -f "$PYTHON" ]; then
        PYTHON="python3"
      fi
      exec "$PYTHON" "kimi_quota.py" "$@"
    EOS
    FileUtils.chmod 0755, "#{staged_path}/bin/kimiquota-cli"
  end

  binary "#{staged_path}/bin/kimiquota"
  binary "#{staged_path}/bin/kimiquota-cli"

  caveats <<~EOS
    🌙 KimiQuota has been installed!
    
    To start the menu bar app:
      kimiquota
    
    Or use the CLI:
      kimiquota-cli
    
    Note: You may need to install dependencies manually:
      pip3 install rumps requests
    
    Make sure you have logged in to Kimi CLI first:
      kimi login
  EOS

  zap trash: [
    "~/Library/LaunchAgents/com.user.kimiquota.plist",
    "/tmp/kimiquota.*",
  ]
end
