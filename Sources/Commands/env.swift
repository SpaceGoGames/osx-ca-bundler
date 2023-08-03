import Foundation
import ArgumentParser

struct EnvInstallCli: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "install",
        abstract: "Install env vars into login item"
    )

    @Option(name: .shortAndLong, help: "Cert path where to write the bundle to")
    var cert: String? = nil

    mutating func run() throws {
        let config = loadOrGenerateConfig()
        let _cert = unrollTilde(string: cert ?? config.cert)
        try EnvHelper().Install(cert: _cert)
    }
}

struct EnvUninstallCli: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "uninstall",
        abstract: "Uninstall env vars from login item"
    )

    mutating func run() throws {
        try EnvHelper().Uninstall()
    }
}

struct EnvCli: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "env",
        abstract: "Handle env var export to ensure the basic vars are always set",
        subcommands: [EnvInstallCli.self, EnvUninstallCli.self]
    )
}

struct EnvHelper {
    func Install(cert: String) throws {
        let plist = generateEnvPList(envVars: [
            "REQUESTS_CA_BUNDLE": cert,
            "NODE_EXTRA_CA_CERTS": cert,
            "SSL_CERT_FILE": cert
        ])

        if isInstalled(agent: envLaunchAgent) {
            let currentSha = try envLaunchAgent.sha256()
            if plist.sha256() == currentSha {
                return
            }
            try unloadLauncher(agent: envLaunchAgent)
        }

        try loadLauncher(agent: envLaunchAgent, plist: plist)
        info("Environment variables updated")
    }

    func Uninstall() throws {
        if isInstalled(agent: envLaunchAgent) {
            try unloadLauncher(agent: envLaunchAgent)
        }
    }
}