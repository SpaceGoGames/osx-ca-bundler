import Foundation
import ArgumentParser
import ANSITerminal

@main
struct cli: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: appName,
        abstract: "A utility that makes it easier to use bundled keychain certs",
        subcommands: [BundleCli.self, EnvCli.self, LaunchCli.self]
    )
}
