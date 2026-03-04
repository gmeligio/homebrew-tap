class Gx < Formula
  desc "CLI to manage Github Actions dependencies"
  homepage "https://github.com/gmeligio/gx"
  version "0.5.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gmeligio/gx/releases/download/v0.5.9/gx-aarch64-apple-darwin.tar.xz"
      sha256 "27f79c09ff8ef2a7a8d0005ca43c8bf9afa850b2b8e8e066f7743fe1b11ee8b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gmeligio/gx/releases/download/v0.5.9/gx-x86_64-apple-darwin.tar.xz"
      sha256 "be98d7fca7526a3ad6b37d738d6cdf004f77bbb1fa186fabc4b53f002479594c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/gmeligio/gx/releases/download/v0.5.9/gx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4eb0da4bd6f380b0c68ff4a021d6f110f182efc23f8ae55bdaf4d9d51875086c"
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
