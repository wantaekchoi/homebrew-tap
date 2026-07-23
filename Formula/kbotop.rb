class Kbotop < Formula
  desc "Watch KBO baseball from your terminal — live scoreboard & strike-zone pitch tracking, in the spirit of htop."
  homepage "https://github.com/wantaekchoi/kbotop"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.2.0/kbotop-aarch64-apple-darwin.tar.xz"
      sha256 "3ae223cfb55d0fcfb6d77ab483a5be49b227b5efffd3cd7cbefcc87922cf45ed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.2.0/kbotop-x86_64-apple-darwin.tar.xz"
      sha256 "38558f7c9d4b2c31b1aa62ee12bdef80dc2d268df32ecd0b90db0d7aade8dce3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.2.0/kbotop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "eae72b8ba043e40831e2a822b39c6f16022df490ded47a0b4eb56f86deb71056"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.2.0/kbotop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "40328f3682daeaed2bc1e189ce552723ca5629cdfc67834551ef7ae7f8296836"
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
