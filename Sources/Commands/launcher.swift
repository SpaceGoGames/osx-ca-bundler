import Foundation
import ArgumentParser

struct InstallCli: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "install",
        abstract: "Install the bundler as an OSX login item"
    )

    @Option(name: .shortAndLong, help: "Interval to recheck the system certs in seconds")
    var interval: UInt32? = nil

    mutating func run() throws {
        try Launcher().install(interval: interval)
    }
}

struct UninstallCli: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "uninstall",
        abstract: "Uninstall the bundler as an OSX login item"
    )

    mutating func run() throws {
        try Launcher().uninstall()
    }
}

struct RefreshCli: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "refresh",
        abstract: "Refresh the launcher agent"
    )

    mutating func run() throws {
        try Launcher().refresh()
    }
}

struct Launcher {

    let bash: Bash = Bash()
    let launchAgentsDir = URL.userHome.appendingPathComponent("Library/LaunchAgents/\(appName).plist")

    func _isInstalled() -> Bool {
        FileManager.default.fileExists(atPath: launchAgentsDir.path)
    }

    func _copyLauncher(interval: UInt32) throws {
        let plist = generateLaunchctlPList(binDir: localBinPath().path, interval: interval)
        try plist.write(to: launchAgentsDir, atomically: true, encoding: String.Encoding.utf8)
    }

    func _loadLauncher() throws {
        _ = try bash.run(commandName: "launchctl", arguments: ["load", launchAgentsDir.path])
    }

    func _removeLauncher() throws {
        try FileManager.default.removeItem(at: launchAgentsDir)
    }

    func _unloadLauncher() throws {
        _ = try bash.run(commandName: "launchctl", arguments: ["unload", launchAgentsDir.path])
    }

    func install(interval: UInt32?) throws {
        if _isInstalled() {
            warn("Already installed")
            return
        }
        var config = loadOrGenerateConfig()
        let _interval = interval ?? config.interval

        try _copyLauncher(interval: _interval)
        try _loadLauncher()

        // Only re-save if we passed something from the CLI
        if (interval != nil) {
            config.interval = _interval
            try! saveConfig(config:config)
        }
        info("Installed to login items")
    }

    func uninstall() throws {
        if !_isInstalled() {
            warn("Nothing installed")
            return
        }
        try _unloadLauncher()
        try _removeLauncher()
        info("Uninstalled from login items")
    }

    func refresh() throws {
        try uninstall()
        try install(interval: loadOrGenerateConfig().interval)
    }
}