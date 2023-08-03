import Foundation

typealias Codable = Decodable & Encodable

let bash = Bash()

let appName = "osx-ca-bundler"
let appScope = "games.spacego"

let bundleCliName = "bundle"

public extension URL {
    static var userHome : URL   {
        URL(fileURLWithPath: userHomePath, isDirectory: true)
    }

    static var userHomePath : String   {
        let pw = getpwuid(getuid())

        if let home = pw?.pointee.pw_dir {
            return FileManager.default.string(withFileSystemRepresentation: home, length: Int(strlen(home)))
        }

        fatalError()
    }
}

func unrollTilde(string: String) -> String {
    if let range = string.range(of: "~"){
        return string.replacingCharacters(in: range, with: URL.userHomePath)
    }
    return string
}

func createDir(dirPath: String) throws {
    if !FileManager.default.fileExists(atPath: dirPath) {
        try FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
    }
}

func copyItem(at: URL, to: URL, overwrite: Bool = false) throws {
    if overwrite && FileManager.default.fileExists(atPath: to.path) {
        try FileManager.default.removeItem(at: to)
    }
    try FileManager.default.copyItem(at: at, to: to)
}

func mainExecutable() -> URL {
    URL(fileURLWithPath: Bundle.main.executablePath!, isDirectory: false, relativeTo: nil)
}

func localBinPath() -> URL {
    URL(fileURLWithPath: "/usr/local/bin", isDirectory: true, relativeTo: nil)
}
