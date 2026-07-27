class Kbotop < Formula
  desc "Watch KBO baseball in your terminal, with strike-zone pitch tracking."
  homepage "https://github.com/wantaekchoi/kbotop"
  version "0.20.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.20.0/kbotop-aarch64-apple-darwin.tar.xz"
      sha256 "791aed7a3e4a7e35e77fd68d5d8cda83af7c22adab30f26b45af17b866b45c1c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.20.0/kbotop-x86_64-apple-darwin.tar.xz"
      sha256 "09ca9121efcd66284aac8acf35ca28a91419de4fbee6182633a6e46efb6ede07"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.20.0/kbotop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0c061342d9af027a760df1e71a4facdaa26ef93bc5d8d6869064c45b02308dc5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.20.0/kbotop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4df374cc04a5fc48038eeef82ab2b5ca94a5771398e7e3575e49d1058559dfa1"
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
