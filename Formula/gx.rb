class Gx < Formula
  desc "CLI to manage Github Actions dependencies"
  homepage "https://github.com/gmeligio/gx"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gmeligio/gx/releases/download/v0.7.0/gx-aarch64-apple-darwin.tar.xz"
      sha256 "25b227c9835d32aa0b1b1191861efff1a3eefc3c6c09fcf40bb6e4c37c14fced"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gmeligio/gx/releases/download/v0.7.0/gx-x86_64-apple-darwin.tar.xz"
      sha256 "23b702fceb39e50d8d70d69e0d9708a2ae72ffe7da264bdc840f85291c57562d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/gmeligio/gx/releases/download/v0.7.0/gx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "085b924ad592e184ee331a85e935d45710366758743dbe9995f1abeafc87d031"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "gx" if OS.mac? && Hardware::CPU.arm?
    bin.install "gx" if OS.mac? && Hardware::CPU.intel?
    bin.install "gx" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
