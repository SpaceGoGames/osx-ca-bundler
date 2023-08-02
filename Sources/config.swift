import Foundation

let configPath = ".bundler"
let configJson = "config.json"



/**
 The main config file of our app
 */
struct Config: Codable {

    /**
     The path where we will store our bundle cert to
     */
    var cert: String = "~/.bundler/cert.pem"

    /**
     If true we will also export the cert bundle to all brew installed Open SLL installations
     */
    var exportToOpenSLL: Bool = false

    /**
     The re-check interval used when the bundler is installed as a launcher
     */
    var interval: UInt32 = 3600
}

func getConfigPath() -> URL {
    URL.userHome.appendingPathComponent(configPath)
}

func getConfigJsonPath() -> URL {
    getConfigPath().appendingPathComponent(configJson)
}

func _loadConfig() -> Config? {
    let url = getConfigJsonPath()
    if !FileManager.default.fileExists(atPath: url.path) {
        return nil
    }

    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let config = try decoder.decode(Config.self, from: data)
        try! saveConfig(config: config)
        return config
    } catch {
        fatal("Failed to load config with error: \(error)")
    }
    return nil
}

func saveConfig(config: Config) throws {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let data = try encoder.encode(config)

    try createDir(dirPath: getConfigPath().path)
    try data.write(to: getConfigJsonPath(), options: [Data.WritingOptions.atomic])
}

func _generateConfig() -> Config {
    let config = Config()
    do {
        try saveConfig(config: config)
    } catch {
        fatal("Failed to save new config with error: \(error)")
    }
    return config
}

func loadOrGenerateConfig() -> Config {
    let config = _loadConfig() ?? _generateConfig();
    return config
}