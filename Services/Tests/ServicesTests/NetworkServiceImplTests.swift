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

    @Test("fetchFeaturedItems preserves all items from each carousel set")
    func testFetchFeaturedItemsPreservesItems() async throws {
        let service = NetworkServiceImpl()
        let result = try await service.fetchFeaturedItems()

        let expected = FeaturedItem.allCarouselSets
        #expect(result.count == expected.count)

        // Each set should contain the same items, just reordered
        let sortedResult = result.map { $0.sorted { $0.id < $1.id } }
        let sortedExpected = expected.map { $0.sorted { $0.id < $1.id } }

        for (resultSet, expectedSet) in zip(sortedResult.sorted { $0[0].id < $1[0].id },
                                            sortedExpected.sorted { $0[0].id < $1[0].id }) {
            #expect(resultSet == expectedSet)
        }
    }

    @Test("fetchAllItems returns all items in order")
    func testFetchAllItems() async throws {
        let service = NetworkServiceImpl()
        let result = try await service.fetchAllItems()

        #expect(result == FeaturedItem.all)
    }

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
