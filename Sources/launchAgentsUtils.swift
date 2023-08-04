import Foundation

func isInstalled(agent: URL) -> Bool {
    FileManager.default.fileExists(atPath: agent.path)
}

func loadLauncher(agent: URL, plist: String) throws {
    try plist.write(to: agent, atomically: true, encoding: String.Encoding.utf8)
    _ = try bash.run(commandName: "launchctl", arguments: ["load", agent.path])
}

func unloadLauncher(agent: URL) throws {
    _ = try bash.run(commandName: "launchctl", arguments: ["unload", agent.path])
    try FileManager.default.removeItem(at: agent)
}