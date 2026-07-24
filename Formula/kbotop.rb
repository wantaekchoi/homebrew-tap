class Kbotop < Formula
  desc "Watch KBO baseball from your terminal — live scoreboard & strike-zone pitch tracking, in the spirit of htop."
  homepage "https://github.com/wantaekchoi/kbotop"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.7.0/kbotop-aarch64-apple-darwin.tar.xz"
      sha256 "d36fe6b740b8b7e668c31390133150bb436e1a26fb7ba52e13872645cba873e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.7.0/kbotop-x86_64-apple-darwin.tar.xz"
      sha256 "b22e1e866b1c13c2a939114c3f56103722f8bded6e3a86b07520383921c62be1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.7.0/kbotop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1100ec74d996270f02b0245386fa603186c4bf30e430f488e40b59ed0c9f6e29"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.7.0/kbotop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "921b0713d2accfd119e0a909ccc5f9d90bf3e2a321b5861fa607e65eeca4492d"
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
