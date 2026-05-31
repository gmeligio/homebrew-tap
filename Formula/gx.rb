class Gx < Formula
  desc "CLI to manage Github Actions dependencies"
  homepage "https://github.com/gmeligio/gx"
  version "0.7.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gmeligio/gx/releases/download/v0.7.2/gx-aarch64-apple-darwin.tar.xz"
      sha256 "54ed42eeb0d1eb4cc81bb81b62fecfa3b20191bdc41032f498bf88e71bb0da3f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gmeligio/gx/releases/download/v0.7.2/gx-x86_64-apple-darwin.tar.xz"
      sha256 "aa7941102f79e7116b54b42829c9f6cb39e1321fe52cf3844e68902eb3659bfb"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/gmeligio/gx/releases/download/v0.7.2/gx-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "025de04156988d3cb1784d8916d392489719d938db2cac39f49c184fcf995e0a"
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
