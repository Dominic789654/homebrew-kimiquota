class Kimiquota < Formula
  desc "CLI tool to check Kimi Coding Plan quota"
  homepage "https://github.com/Dominic789654/KimiQuota"
  url "https://github.com/Dominic789654/KimiQuota/archive/refs/tags/v1.0.0.tar.gz"
  version "1.0.0"
  sha256 :no_check
  license "MIT"

  depends_on "python@3.11"
  depends_on macos: :sonoma

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a9810cb23f675c5662c2cb4f135b5c3b83c457a63e6b1/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b763ff4d88042d6605a9062c7f3c5825b02c8b8ab8b8c7b/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/0f/bd/1d41ee6ce89b705511f7e9c531d826a28c3b938c1d8a43d877ff7f5b974a/certifi-2024.8.30.tar.gz"
    sha256 "bec941d2aa8195e248a60b31ff9f0558284cf01a52591ceda73ea9afffd69fd9"
  end

  def install
    virtualenv_install_with_resources
    
    # Install the CLI script
    bin.install "kimi_quota.py" => "kimiquota-cli"
  end

  test do
    system "#{bin}/kimiquota-cli", "--help" rescue true
  end
end
