class Kbotop < Formula
  desc "Watch KBO baseball in your terminal, with strike-zone pitch tracking."
  homepage "https://github.com/wantaekchoi/kbotop"
  version "0.28.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.28.0/kbotop-aarch64-apple-darwin.tar.xz"
      sha256 "1b959b6057d52e6543b9785e8acab5375a7a3d03cd0d6ab231eec705444f90fe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.28.0/kbotop-x86_64-apple-darwin.tar.xz"
      sha256 "cc8cd4f44b31bc538a79e7957d8815ed23e528d759908112dccc028e00bf52bf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.28.0/kbotop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ab035cfc225eba847e8b93c60b9e4d239ccae0e9f598bf872fde516f16c54fe7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.28.0/kbotop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5075848e983e1cd2c580a4df39e28e06e5b207d1faf858cb9138c8437154555f"
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
