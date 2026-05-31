class Gx < Formula
  desc "CLI to manage Github Actions dependencies"
  homepage "https://github.com/gmeligio/gx"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gmeligio/gx/releases/download/v0.8.0/gx-aarch64-apple-darwin.tar.xz"
      sha256 "350a9fdbe9856d65b852fbebdc025e4abffa9988f19222c77dac7874edf791cf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gmeligio/gx/releases/download/v0.8.0/gx-x86_64-apple-darwin.tar.xz"
      sha256 "b08d2fb76867c8b0aebe878e9e8250025dbc72aaa0b0c64036c27bdd5478ac18"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/gmeligio/gx/releases/download/v0.8.0/gx-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "4c2d57af289657e7847dc1b4bef5c4864dd0e964868029f7026f948bda0e78b5"
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
