class Rustdrop < Formula
  desc "Privacy-first, blazing-fast P2P file transfer for your local network"
  homepage "https://github.com/hakuxyz/rustdrop"
  version "0.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hakuxyz/rustdrop/releases/download/v0.2.0/rustdrop-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "555aa388435bf3fd7f078ef0a29135021ba24512aa41b981695bb1585e0c80e1"
    end
    on_intel do
      url "https://github.com/hakuxyz/rustdrop/releases/download/v0.2.0/rustdrop-v0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "ec4598e7b2f17c17b8bb78f8a5727bde9fb27eb054d63571b37783c56ef12f79"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hakuxyz/rustdrop/releases/download/v0.2.0/rustdrop-v0.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e80c47e3694b690cd1f4a7795fbdd1256fd8b4f6e2b55a6fce373ddea5076bc7"
    end
    on_intel do
      url "https://github.com/hakuxyz/rustdrop/releases/download/v0.2.0/rustdrop-v0.2.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "9355c9101b69d36fa3ba95a20329dafd41433a8e4a05890afda25a1f4743384f"
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
