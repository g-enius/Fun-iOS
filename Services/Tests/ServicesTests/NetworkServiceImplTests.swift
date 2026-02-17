//
//  NetworkServiceImplTests.swift
//  Services
//
//  Unit tests for NetworkServiceImpl
//

import Testing
import Foundation
@testable import FunServices
@testable import FunModel

@Suite("NetworkServiceImpl Tests")
struct NetworkServiceImplTests {

    @Test("login respects cancellation")
    func testLoginCancellation() async {
        let service = NetworkServiceImpl()

        let task = Task {
            try await service.login()
        }

        task.cancel()

        do {
            try await task.value
        } catch is CancellationError {
            // Expected
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test("fetchAllItems respects cancellation")
    func testFetchAllItemsCancellation() async {
        let service = NetworkServiceImpl()

        let task = Task {
            try await service.fetchAllItems()
        }

        task.cancel()

        do {
            _ = try await task.value
        } catch is CancellationError {
            // Expected
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test("fetchFeaturedItems respects cancellation")
    func testFetchFeaturedItemsCancellation() async {
        let service = NetworkServiceImpl()

        let task = Task {
            try await service.fetchFeaturedItems()
        }

        task.cancel()

        do {
            _ = try await task.value
        } catch is CancellationError {
            // Expected
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }
}
