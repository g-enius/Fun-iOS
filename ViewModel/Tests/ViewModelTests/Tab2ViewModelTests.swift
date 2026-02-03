//
//  Tab2ViewModelTests.swift
//  ViewModel
//
//  Unit tests for Tab2ViewModel (Search & Filter)
//

import Testing
import Foundation
@testable import FunViewModel
@testable import FunModel

@Suite("Tab2ViewModel Tests")
@MainActor
struct Tab2ViewModelTests {

    // MARK: - Initial State Tests

    @Test("Initial state loads all featured items")
    func testInitialStateLoadsAllItems() async {
        let viewModel = Tab2ViewModel(coordinator: nil, tabBarViewModel: nil)

        // Uses FeaturedItem.allCarouselSets (14 items)
        #expect(viewModel.searchResults.count == 14)
        #expect(viewModel.selectedCategory == "All")
        #expect(viewModel.searchText.isEmpty)
    }

    @Test("Categories are dynamically derived from items")
    func testCategoriesAreDerived() async {
        let viewModel = Tab2ViewModel(coordinator: nil, tabBarViewModel: nil)

        #expect(viewModel.categories.first == "All")
        #expect(viewModel.categories.count > 1)
        // Should contain Testing category (has 2 items: swiftTesting, snapshotTesting)
        #expect(viewModel.categories.contains("Testing"))
    }

    // MARK: - Category Filter Tests

    @Test("Selecting Testing category filters to Testing items only")
    func testTestingCategoryFilter() async {
        let viewModel = Tab2ViewModel(coordinator: nil, tabBarViewModel: nil)

        viewModel.didSelectCategory("Testing")

        #expect(viewModel.selectedCategory == "Testing")
        #expect(viewModel.searchResults.allSatisfy { $0.category == "Testing" })
        #expect(viewModel.searchResults.count == 2) // swiftTesting, snapshotTesting
    }

    @Test("Selecting Concurrency category filters correctly")
    func testConcurrencyCategoryFilter() async {
        let viewModel = Tab2ViewModel(coordinator: nil, tabBarViewModel: nil)

        viewModel.didSelectCategory("Concurrency")

        #expect(viewModel.selectedCategory == "Concurrency")
        #expect(viewModel.searchResults.allSatisfy { $0.category == "Concurrency" })
        #expect(viewModel.searchResults.count == 1) // asyncAwait
    }

    @Test("Selecting All category shows all items")
    func testAllCategoryFilter() async {
        let viewModel = Tab2ViewModel(coordinator: nil, tabBarViewModel: nil)

        // First filter to Testing
        viewModel.didSelectCategory("Testing")
        #expect(viewModel.searchResults.count == 2)

        // Then select All
        viewModel.didSelectCategory("All")
        #expect(viewModel.selectedCategory == "All")
        #expect(viewModel.searchResults.count == 14)
    }

    // MARK: - Search Text Filter Tests

    @Test("Search text filters by title")
    func testSearchByTitle() async {
        let viewModel = Tab2ViewModel(coordinator: nil, tabBarViewModel: nil)

        viewModel.searchText = "SwiftUI"
        // Manually trigger filter since debounce won't fire immediately in tests
        viewModel.didSelectCategory(viewModel.selectedCategory)

        #expect(viewModel.searchResults.count == 1)
        #expect(viewModel.searchResults.first?.title == "SwiftUI")
    }

    @Test("Search text filters by subtitle")
    func testSearchBySubtitle() async {
        let viewModel = Tab2ViewModel(coordinator: nil, tabBarViewModel: nil)

        viewModel.searchText = "concurrency"
        viewModel.didSelectCategory(viewModel.selectedCategory)

        // Should match "Async/Await" (subtitle: "Modern concurrency") and "Swift 6" (subtitle: "Strict concurrency")
        #expect(viewModel.searchResults.count == 2)
    }

    @Test("Search is case insensitive")
    func testCaseInsensitiveSearch() async {
        let viewModel = Tab2ViewModel(coordinator: nil, tabBarViewModel: nil)

        viewModel.searchText = "SWIFTUI"
        viewModel.didSelectCategory(viewModel.selectedCategory)

        #expect(viewModel.searchResults.count == 1)
        #expect(viewModel.searchResults.first?.title == "SwiftUI")
    }

    @Test("Empty search shows all items in selected category")
    func testEmptySearchShowsAll() async {
        let viewModel = Tab2ViewModel(coordinator: nil, tabBarViewModel: nil)

        viewModel.searchText = "SwiftUI"
        viewModel.didSelectCategory(viewModel.selectedCategory)
        #expect(viewModel.searchResults.count == 1)

        viewModel.searchText = ""
        viewModel.didSelectCategory(viewModel.selectedCategory)
        #expect(viewModel.searchResults.count == 14)
    }

    // MARK: - Combined Filter Tests

    @Test("Search and category filter work together")
    func testCombinedSearchAndCategoryFilter() async {
        let viewModel = Tab2ViewModel(coordinator: nil, tabBarViewModel: nil)

        viewModel.searchText = "snapshot"
        viewModel.didSelectCategory("Testing")

        // Should find "Snapshot Testing" in Testing category
        #expect(viewModel.searchResults.count == 1)
        #expect(viewModel.searchResults.first?.title == "Snapshot Testing")
    }

    @Test("No results when search doesn't match category")
    func testNoResultsWhenSearchDoesntMatchCategory() async {
        let viewModel = Tab2ViewModel(coordinator: nil, tabBarViewModel: nil)

        viewModel.searchText = "SwiftUI"  // This is in UI Framework category
        viewModel.didSelectCategory("Testing")  // Filter to Testing

        #expect(viewModel.searchResults.isEmpty)
    }
}
