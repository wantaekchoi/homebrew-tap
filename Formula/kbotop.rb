class Kbotop < Formula
  desc "Watch KBO baseball from your terminal — live scoreboard & strike-zone pitch tracking, in the spirit of htop."
  homepage "https://github.com/wantaekchoi/kbotop"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.1.1/kbotop-aarch64-apple-darwin.tar.xz"
      sha256 "b7795a682fb98ce262a2e36bde88ecbf282923786bc4b7dceef7214bd9e9f635"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.1.1/kbotop-x86_64-apple-darwin.tar.xz"
      sha256 "135570ed4d5fd2331be6c79e9a27c4c402092b606464ac47deec70f7383748bb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.1.1/kbotop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5aea0049a03834ae83794852738280c6ef7a22fd230d4a9aeac1a4d0d311ff93"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.1.1/kbotop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "922f5453f7b301fe92775ec64ddc61c538e83bcd11891814d15df7f0be92e17e"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "kbotop" if OS.mac? && Hardware::CPU.arm?
    bin.install "kbotop" if OS.mac? && Hardware::CPU.intel?
    bin.install "kbotop" if OS.linux? && Hardware::CPU.arm?
    bin.install "kbotop" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
