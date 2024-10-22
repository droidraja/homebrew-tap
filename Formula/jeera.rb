class Jeera < Formula
  desc "A TUI App for Jira built using Rust"
  homepage "https://github.com/droidraja/jeera"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/droidraja/jeera/releases/download/v0.1.1/jeera-aarch64-apple-darwin.tar.xz"
      sha256 "a4daef7fa03ee1c949081a63cece6abd757cb0230a34a9a75287bb2ed9a87fa6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/droidraja/jeera/releases/download/v0.1.1/jeera-x86_64-apple-darwin.tar.xz"
      sha256 "350111bff627ad4b1b445625eea56a40468245c7e18e680ddea5cf95b4c69361"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/droidraja/jeera/releases/download/v0.1.1/jeera-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "1daba1eaf474333a46ca62c935c47f5881071a69297ed2fa79f61e39be8e581e"
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "jeera" if OS.mac? && Hardware::CPU.arm?
    bin.install "jeera" if OS.mac? && Hardware::CPU.intel?
    bin.install "jeera" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
