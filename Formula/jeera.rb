class Jeera < Formula
  desc "A TUI App for Jira built using Rust"
  homepage "https://github.com/droidraja/jeera"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/droidraja/jeera/releases/download/v0.1.3/jeera-aarch64-apple-darwin.tar.xz"
      sha256 "0867da7ee1cf880273351b60481489b897f09e1f8fdedc33a0ea2e3a04840a73"
    end
    if Hardware::CPU.intel?
      url "https://github.com/droidraja/jeera/releases/download/v0.1.3/jeera-x86_64-apple-darwin.tar.xz"
      sha256 "0af85ca32f04e9dd1c75ea0314bf4c5f63704d4ee00054f84b7c5c0a78c2fa27"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/droidraja/jeera/releases/download/v0.1.3/jeera-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "08082d221de0ec33f93fe0ba32f38b7c08e43d22bc89ab618f0415a84cb49d8a"
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
