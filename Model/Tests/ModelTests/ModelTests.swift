import Testing
@testable import Model

@Test func modelVersion() async throws {
    #expect(Model.version == "1.0.0")
}
