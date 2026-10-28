class Rustdrop < Formula
  desc "Privacy-first, blazing-fast P2P file transfer for your local network"
  homepage "https://github.com/hakuxyz/rustdrop"
  version "0.1.0"
  license "MIT"

  livecheck do
    skip "No versioned GitHub releases to check"
  end

  on_macos do
    on_arm do
      url "https://github.com/hakuxyz/rustdrop/releases/download/v0.1.0/rustdrop-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "24b0b4501f2b38e5b9a7898320bd33d253eaf8b2efe570f1f279e5bec2f45b45"
    end
    on_intel do
      url "https://github.com/hakuxyz/rustdrop/releases/download/v0.1.0/rustdrop-v0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "541c0eef640865b90746eb74d808cc7246e75ed0c94485c1da5b2d692679c495"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hakuxyz/rustdrop/releases/download/v0.1.0/rustdrop-v0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "aa60d50bf42bc795b5c2098c07ddfb96dd69b3b6508355b6bc1d03c53723da7f"
    end
    on_intel do
      url "https://github.com/hakuxyz/rustdrop/releases/download/v0.1.0/rustdrop-v0.1.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "9b2d6030cac1d296beeebf49c9f81fc4448f5e4a7291ab8adb45888405213510"
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
