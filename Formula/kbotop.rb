class Kbotop < Formula
  desc "Watch KBO baseball from your terminal — live scoreboard & strike-zone pitch tracking, in the spirit of htop."
  homepage "https://github.com/wantaekchoi/kbotop"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.4.0/kbotop-aarch64-apple-darwin.tar.xz"
      sha256 "20e0bd29df18bc405460a2300366c686e134e9b41539033b5d1b0b4b3faf0684"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.4.0/kbotop-x86_64-apple-darwin.tar.xz"
      sha256 "9e087ed5de3b1cee4447e9edd39366523b16f21d8c2b84ab450744ebebad31ff"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.4.0/kbotop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "19607349747c5a5df698ba2be4df1e6e50189fd2b4ded8922f29318956181889"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.4.0/kbotop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bfdecd6e65f5dca93a32c4add04e8a9dfee415619f6f7db67dda36d7e8999602"
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
