class Gx < Formula
  desc "CLI to manage Github Actions dependencies"
  homepage "https://github.com/gmeligio/gx"
  version "0.8.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/gmeligio/gx/releases/download/v0.8.3/gx-aarch64-apple-darwin.tar.xz"
    sha256 "28d34c13110b3a4df68cbc5d4a7c097028df62b74dded6a85901d18dde238a9d"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/gmeligio/gx/releases/download/v0.8.3/gx-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "0dfa3b8a2781a2a3c985cceb83e5de3abac8192817b6aee653407cc87d553a8f"
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
