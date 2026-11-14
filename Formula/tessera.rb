class Tessera < Formula
  desc "Small compiled language where I/O needs a capability"
  homepage "https://tessera-book.laravel.cloud"
  url "https://github.com/AlfonsoCampodonico/homebrew-tessera/releases/download/v0.1.0/tessera-0.1.0-macos-arm64.tar.gz"
  version "0.1.0"
  sha256 "d52cbde28bb5dd10c78ef753e3cd3810cbb4359b0c2d27e6c8173e4b5b4ecbb6"

  depends_on arch: :arm64
  depends_on :macos
  depends_on "openssl@3"

  def install
    bin.install "bin/tessera"
  end

  test do
    (testpath/"hello.tsr").write <<~TESSERA
      fn main(root: Root) {
          root.stdout.print("hello, tessera")
      }
    TESSERA
    # Homebrew runs tests inside a macOS sandbox, where a program can't set
    # up its own, so the test turns Tessera's off.
    assert_equal "hello, tessera\n", shell_output("#{bin}/tessera run --no-sandbox hello.tsr")
    system bin/"tessera", "build", "hello.tsr", "-o", "hello"
    assert_equal "hello, tessera\n", shell_output("./hello --no-sandbox")
  end
end
