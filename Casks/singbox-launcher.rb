cask "singbox-launcher" do
  version "2.4.0"
  sha256 "057af85b988521181a9e13ab2a13856782010ea9ad165a2589943f4bc80860f3"

  url "https://github.com/Leadaxe/singbox-launcher/releases/download/v#{version}/singbox-launcher-v#{version}-macos.zip"
  name "singbox-launcher"
  desc "Graphical desktop client for sing-box"
  homepage "https://github.com/Leadaxe/singbox-launcher"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  # The upstream release ZIP keeps the app under the CI artifact directory.
  app "artifacts-darwin/singbox-launcher.app"

  postflight_steps do
    # GitHub Actions artifacts may lose the executable bit before release ZIP packaging.
    set_permissions "singbox-launcher.app/Contents/MacOS/singbox-launcher", "0755", base: :appdir
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/singbox-launcher.app"]
  end

  zap trash: [
    "~/Library/Application Support/singbox-launcher",
    "~/Library/Logs/singbox-launcher",
  ]

  caveats <<~EOS
    The macOS quarantine attribute is cleared automatically for this app,
    as in the upstream install script. This bypasses the usual first-run
    Gatekeeper quarantine check; install only if you trust the source.

    This Cask installs only the .app, not the sing-box core or privileged
    TUN helper. First launch/TUN setup may require downloads or authorization.
  EOS
end
