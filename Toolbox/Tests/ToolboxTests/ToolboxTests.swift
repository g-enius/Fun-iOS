import Testing
@testable import Toolbox

@Test func toolboxVersion() async throws {
    #expect(Toolbox.version == "1.0.0")
}
