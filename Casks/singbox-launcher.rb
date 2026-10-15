cask "singbox-launcher" do
  version "2.3.10"
  sha256 "f84ffb0ba1ebfcd096adb18f53195cc91244cbb8962a964bdd1cc59abb37061d"

  url "https://github.com/Leadaxe/singbox-launcher/releases/download/v#{version}/singbox-launcher-v#{version}-macos.zip"
  name "singbox-launcher"
  desc "Graphical desktop client for sing-box"
  homepage "https://github.com/Leadaxe/singbox-launcher"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  # The upstream release ZIP keeps the app under the CI artifact directory.
  app "artifacts-darwin/singbox-launcher.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/singbox-launcher.app"]
  end

  caveats <<~EOS
    The macOS quarantine attribute is cleared automatically for this app,
    as in the upstream install script. This bypasses the usual first-run
    Gatekeeper quarantine check; install only if you trust the source.

    This Cask installs only the .app, not the sing-box core or privileged
    TUN helper. First launch/TUN setup may require downloads or authorization.
  EOS
end
