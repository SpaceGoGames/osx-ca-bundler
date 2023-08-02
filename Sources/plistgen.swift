import Foundation

let launchctlPList = """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
      <key>Label</key>
      <string>\(appScope).\(appName)</string>

      <key>ProgramArguments</key>
      <array>
          <string>%@/\(appName)</string>
          <string>\(bundleCliName)</string>
      </array>

      <key>Nice</key>
      <integer>1</integer>

      <key>StartInterval</key>
      <integer>%d</integer>

      <key>RunAtLoad</key>
      <true/>
  </dict>
</plist>
"""

func generateLaunchctlPList(binDir: String, interval: UInt32) -> String {
    String(format: launchctlPList, binDir, interval)
}