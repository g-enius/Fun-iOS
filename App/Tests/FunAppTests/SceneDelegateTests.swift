import Testing
@testable import AppCore

@Test func appVersionExists() async throws {
    #expect(App.version == "1.0.0")
}
