cask "kimiquota" do
  version "1.0.0"
  sha256 :no_check

  url "https://github.com/Dominic789654/KimiQuota/archive/refs/tags/v#{version}.tar.gz"
  name "KimiQuota"
  desc "macOS menu bar app to check Kimi Coding Plan quota"
  homepage "https://github.com/Dominic789654/KimiQuota"

  depends_on macos: ">= :sonoma"
  depends_on formula: "python@3.11"

  # Create the app bundle in postflight
  postflight do
    system_command "#{HOMEBREW_PREFIX}/opt/python@3.11/bin/python3.11",
                   args: ["-m", "pip", "install", "--user", "rumps", "requests"],
                   print_stderr: false
  end

  # Create wrapper scripts
  binary "#{staged_path}/bin/kimiquota"
  binary "#{staged_path}/bin/kimiquota-cli"

  preflight do
    # Create bin directory
    FileUtils.mkdir_p "#{staged_path}/bin"
    
    # Create kimiquota wrapper
    File.write("#{staged_path}/bin/kimiquota", <<~EOS)
      #!/bin/bash
      cd "#{staged_path}" && exec #{HOMEBREW_PREFIX}/opt/python@3.11/bin/python3.11 "KimiquotaMenuBar.app/Contents/MacOS/kimi_menu.py" "$@"
    EOS
    FileUtils.chmod 0755, "#{staged_path}/bin/kimiquota"
    
    # Create kimiquota-cli wrapper
    File.write("#{staged_path}/bin/kimiquota-cli", <<~EOS)
      #!/bin/bash
      cd "#{staged_path}" && exec #{HOMEBREW_PREFIX}/opt/python@3.11/bin/python3.11 "kimi_quota.py" "$@"
    EOS
    FileUtils.chmod 0755, "#{staged_path}/bin/kimiquota-cli"
  end

  zap trash: [
    "~/Library/LaunchAgents/com.user.kimiquota.plist",
    "/tmp/kimiquota.*",
  ]
end
