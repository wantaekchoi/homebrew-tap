class Kbotop < Formula
  desc "Watch KBO baseball in your terminal, with strike-zone pitch tracking."
  homepage "https://github.com/wantaekchoi/kbotop"
  version "0.23.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.23.0/kbotop-aarch64-apple-darwin.tar.xz"
      sha256 "a2e850d65deb91fe57409a7286f050902a527d7b9ba43550990fe054b16b7302"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.23.0/kbotop-x86_64-apple-darwin.tar.xz"
      sha256 "f12c96c09dcb2069e0d4ceecb7bf0c97eb1be804e182428ffd433dfc5cf67df3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.23.0/kbotop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c621794d3795cbbe63373258393c4450ed651ad29d540731a311dcad93cdf590"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.23.0/kbotop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8aba460d17bcbcc95cb9ea6f884f9b069ee0a5847a6cf42aae203a1b3a43d02f"
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
