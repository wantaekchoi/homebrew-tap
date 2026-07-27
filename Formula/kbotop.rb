class Kbotop < Formula
  desc "Watch KBO baseball in your terminal, with strike-zone pitch tracking."
  homepage "https://github.com/wantaekchoi/kbotop"
  version "0.25.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.25.0/kbotop-aarch64-apple-darwin.tar.xz"
      sha256 "e44e0b54b791cbe9f728361597b1d5ad811f366ae85bd38e524c828eb170596c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.25.0/kbotop-x86_64-apple-darwin.tar.xz"
      sha256 "418383bb29658a9b8f59fdcbfeca9005e00b7dd14a019f1239983d6e2d170ad9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.25.0/kbotop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b97b1b1b2e54820ebfc119308b66ac4aac9617712989bd0045d8395e9f9c5488"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.25.0/kbotop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8c5c4d77fc3603e5280568cead2d76e01c93451fb5cd15c4c1b0c8603ae69569"
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
