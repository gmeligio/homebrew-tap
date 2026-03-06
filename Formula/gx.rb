class Gx < Formula
  desc "CLI to manage Github Actions dependencies"
  homepage "https://github.com/gmeligio/gx"
  version "0.5.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gmeligio/gx/releases/download/v0.5.10/gx-aarch64-apple-darwin.tar.xz"
      sha256 "f2faafed1c0a188bf24209c6c3448448dc46c1c074513aa6e1d14ca8a114778c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gmeligio/gx/releases/download/v0.5.10/gx-x86_64-apple-darwin.tar.xz"
      sha256 "b23e7e551bff7fbbe7a7110db1b77d2ea84b0ba894a44988a045568e5fea85a3"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/gmeligio/gx/releases/download/v0.5.10/gx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "45fc32a6ed244e4463c0f329ed0aa8f53f94158a9a6151569cebe67125178858"
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
