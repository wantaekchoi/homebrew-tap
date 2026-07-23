class Kbotop < Formula
  desc "Watch KBO baseball from your terminal — live scoreboard & strike-zone pitch tracking, in the spirit of htop."
  homepage "https://github.com/wantaekchoi/kbotop"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.6.0/kbotop-aarch64-apple-darwin.tar.xz"
      sha256 "0485acb635b196dcc33ebed7c4741f1e5a8254b8f9537b497d061fe6d68386df"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.6.0/kbotop-x86_64-apple-darwin.tar.xz"
      sha256 "421919dba1b5bdd68a18827d0bf27c65b74a7660e63c4955f3fd928f397187cc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.6.0/kbotop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "df288bc7eada2bb6b173ee20f472fc422aa9964f3948f89aeec83278963c9d1d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wantaekchoi/kbotop/releases/download/v0.6.0/kbotop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d1f6839abf1f2a245cf78b0061feedd2989a9d7dd08ac62c38bf93a438c4c3a5"
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
