import Foundation

func warn(_ msg: String) {
    print(msg.yellow)
}

func fatal(_ msg: String) {
    print(msg.red)
}

func info(_ msg: String) {
    print(msg)
}