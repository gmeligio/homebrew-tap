class Gx < Formula
  desc "CLI to manage Github Actions dependencies"
  homepage "https://github.com/gmeligio/gx"
  version "0.8.5"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/gmeligio/gx/releases/download/v0.8.5/gx-aarch64-apple-darwin.tar.xz"
    sha256 "0a8cbc623c5dc4bbaea60f38914daac68b1c971f676d9c86a522dd5e96277b55"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/gmeligio/gx/releases/download/v0.8.5/gx-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "6079ede27c9a97ee2a17861c9ab808d09de8ca6db2f0c564b68ca448e5088175"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "gx"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "gx"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
