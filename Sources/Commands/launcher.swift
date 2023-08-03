import Foundation
import ArgumentParser

let serviceLaunchAgent = URL.userHome.appendingPathComponent("Library/LaunchAgents/\(appName).plist")

struct LaunchInstallCli: ParsableCommand {
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

struct LaunchUninstallCli: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "uninstall",
        abstract: "Uninstall the bundler as an OSX login item"
    )

    mutating func run() throws {
        try Launcher().uninstall()
    }
}

struct LaunchRefreshCli: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "refresh",
        abstract: "Refresh the launcher agent"
    )

    mutating func run() throws {
        try Launcher().refresh()
    }
}

struct LaunchCli: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "launch",
        abstract: "Handle launch agents to refresh the certs",
        subcommands: [LaunchInstallCli.self, LaunchUninstallCli.self, LaunchRefreshCli.self]
    )
}

struct Launcher {

    func _isInstalled() -> Bool {
        isInstalled(agent: serviceLaunchAgent)
    }

    func _loadLauncher(interval: UInt32) throws {
        let plist = generateLaunchctlPList(binDir: localBinPath().path, interval: interval)
        try loadLauncher(agent: serviceLaunchAgent, plist: plist)
    }

    func _unloadLauncher() throws {
        try unloadLauncher(agent: serviceLaunchAgent)
    }

    func install(interval: UInt32?) throws {
        if _isInstalled() {
            warn("Already installed")
            return
        }
        var config = loadOrGenerateConfig()
        let _interval = interval ?? config.interval

        try _loadLauncher(interval: _interval)

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
        info("Uninstalled from login items")
    }

    func refresh() throws {
        try uninstall()
        try install(interval: loadOrGenerateConfig().interval)
    }
}