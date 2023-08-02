import Foundation
import ArgumentParser


enum BundlerError: Error {
    case invalidCertPath
}

struct BundleCli: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: bundleCliName,
        abstract: "Bundle your keychain certs into a single CB bundle"
    )

    @Option(name: .shortAndLong, help: "Cert path where to write the bundle to")
    var cert: String? = nil

    @Option(name: .shortAndLong, help: "Export bundle cert OpenSLL installations too.")
    var exportToOpenSLL: Bool? = nil

    mutating func run() throws {
        info("Bundling system certs")
        try Bundler().bundleCerts(cert:cert, exportToOpenSLL:exportToOpenSLL)
    }
}

struct Bundler {
    let bash: Bash = Bash()
    func findCerts() throws -> [String] {
        var certs: [String] = []

        let chains: String = try bash.run(commandName: "security", arguments: ["list-keychains"])
        chains.enumerateLines { (line, stop) -> () in
            certs.append(findCertsFromChain(keyChain: line
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: "\"", with: "")))
        }
        certs += [findCertsFromChain(keyChain: "/System/Library/Keychains/SystemRootCertificates.keychain")]
        return certs
    }

    func findCertsFromChain(keyChain: String) -> String {
        do {
            return try bash.run(commandName: "security", arguments: ["find-certificate", "-a", "-p", keyChain])
        } catch {
            return ""
        }
    }

    func bundleCerts(cert: String?, exportToOpenSLL: Bool?) throws {
        let config = loadOrGenerateConfig()
        let _cert = unrollTilde(string: cert ?? config.cert)
        //let _exportToOpenSLL = exportToOpenSLL ?? config.exportToOpenSLL

        do {
            let certs = try findCerts()
            let mergedCerts = certs.joined(separator: "\n")
            try mergedCerts.write(to: URL(fileURLWithPath: _cert), atomically: true, encoding: String.Encoding.utf8)
            info("Certificate bundle has been saved to: \(_cert)")
        } catch {
            fatal("Failed to bundle certs with error: \(error)")
        }
    }
}