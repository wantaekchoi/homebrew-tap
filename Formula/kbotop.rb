class Kbotop < Formula
  desc "Watch KBO baseball in your terminal, with strike-zone pitch tracking."
  homepage "https://github.com/wantaekchoi/kbotop"
  version "0.30.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.30.0/kbotop-aarch64-apple-darwin.tar.xz"
      sha256 "9e2a65a07c8e0aa7b01da915526b1bd816ffd719bb5ccb3b309780ae9f91144b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.30.0/kbotop-x86_64-apple-darwin.tar.xz"
      sha256 "f35bb153874287906ea7454adec936d32f83f97def13e7e849ff2cc0092bf865"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.30.0/kbotop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "25ba7e000c81d569a6deb51a41585df74903c6c42432bffd564b02978a9fc36a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.30.0/kbotop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d2de7ffc88f521c2a4c4a1a71ce0bba4fa3646e6eeb89f6810872a142764baed"
    end
  end
  license "Unlicense"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
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
