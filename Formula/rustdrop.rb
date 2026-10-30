class Rustdrop < Formula
  desc "Privacy-first, blazing-fast P2P file transfer for your local network"
  homepage "https://github.com/hakuxyz/rustdrop"
  version "0.3.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hakuxyz/rustdrop/releases/download/v0.3.0/rustdrop-v0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "39c6fa008641502b74f0a1a9301c9bdc6d2e9b154b94de5810a1e6c517f22711"
    end
    on_intel do
      url "https://github.com/hakuxyz/rustdrop/releases/download/v0.3.0/rustdrop-v0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "9003ae71b343330f911cda5ebd5abf32f972b67bc0ccead49172fc4b33b63685"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hakuxyz/rustdrop/releases/download/v0.3.0/rustdrop-v0.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dfaff84ac626500799e6f91091a3fe47606d3935e0c8d9bb7b405d50af1ab2d9"
    end
    on_intel do
      url "https://github.com/hakuxyz/rustdrop/releases/download/v0.3.0/rustdrop-v0.3.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ead5ac128c3300a078161995547838eceaac179735ff9820888584e2f91320ab"
    end
  end

  def install
    bin.install "rustdrop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustdrop --version")

    (testpath/"sample.txt").write("hello rustdrop\n")
    port = free_port
    pid = fork do
      exec bin/"rustdrop", "receive", "-o", testpath/"in", "--yes",
           "--no-mdns", "--port", port.to_s, "--timeout", "10"
    end
    sleep 2
    system bin/"rustdrop", "send", "--to", "127.0.0.1:#{port}",
           "--quiet", "--retries", "3", testpath/"sample.txt"
    Process.wait(pid)
    assert_equal "hello rustdrop\n", (testpath/"in/sample.txt").read
  end
end
