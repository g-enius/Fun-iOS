import Foundation

public struct Language: Identifiable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let code: String

    public init(id: String = UUID().uuidString, name: String, code: String) {
        self.id = id
        self.name = name
        self.code = code
    }
}

public extension Language {
    static let english = Language(id: "en", name: "English", code: "en")
    static let japanese = Language(id: "ja", name: "Japanese", code: "ja")
    static let chinese = Language(id: "zh", name: "Chinese", code: "zh")
    static let korean = Language(id: "ko", name: "Korean", code: "ko")

    static let all: [Language] = [.english, .japanese, .chinese, .korean]
}
