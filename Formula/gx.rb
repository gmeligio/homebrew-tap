class Gx < Formula
  desc "CLI to manage Github Actions dependencies"
  homepage "https://github.com/gmeligio/gx"
  version "0.8.4"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/gmeligio/gx/releases/download/v0.8.4/gx-aarch64-apple-darwin.tar.xz"
    sha256 "0d63c37593540bd273b7da1d8fc589decaf4c6a1fbd218bcd9cc4a308fde6e5a"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/gmeligio/gx/releases/download/v0.8.4/gx-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f61e908b178dc873d3a108ffd7c5f3934c777d2f5cceddbcd03a9c78883021d8"
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
    bin.install "gx" if OS.mac? && Hardware::CPU.arm?
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
