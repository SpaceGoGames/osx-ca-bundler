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

let envPList = """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>Label</key>
        <string>\(appScope).\(appName).setenv</string>
        
        <key>ProgramArguments</key>
        <array>
            <string>sh</string>
            <string>-c</string>
            <string>
                %@
            </string>
        </array>
        
        <key>RunAtLoad</key>
        <true/>
        <key>ServiceIPC</key>
        <false/>
    </dict>
</plist>
"""

func generateLaunchctlPList(binDir: String, interval: UInt32) -> String {
    String(format: launchctlPList, binDir, interval)
}

func generateEnvPList(envVars: [String: String]) -> String {
    var envVarsString = ""
    for envVar in envVars {
        envVarsString.append("\n                launchctl setenv \(envVar.key) \(envVar.value)")
    }
    return String(format: envPList, envVarsString)
}