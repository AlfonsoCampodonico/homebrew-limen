class Limen < Formula
  desc "Small compiled language where I/O needs a capability"
  homepage "https://book.limen-lang.org"
  url "https://github.com/AlfonsoCampodonico/homebrew-limen/releases/download/v0.4.0/limen-0.4.0-macos-arm64.tar.gz"
  version "0.4.0"
  sha256 "ee3012dbf7d7d880813ab14168d3b825d82d70977a734e652da453fe26a47d7a"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on arch: :arm64
  depends_on :macos
  depends_on "openssl@3"

  def install
    bin.install "bin/limen"
  end

  test do
    (testpath/"hello.lmn").write <<~TESSERA
      fn main(root: Root) {
          root.stdout.print("hello, limen")
      }
    TESSERA
    # Homebrew runs tests inside a macOS sandbox, where a program can't set
    # up its own, so the test turns Limen's off.
    assert_equal "hello, limen\n", shell_output("#{bin}/limen run --no-sandbox hello.lmn")
    system bin/"limen", "build", "hello.lmn", "-o", "hello"
    assert_equal "hello, limen\n", shell_output("./hello --no-sandbox")
  end
end
