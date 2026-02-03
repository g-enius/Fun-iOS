//
//  Tab2ViewModel.swift
//  ViewModel
//
//  ViewModel for Tab2 (Search) screen
//

import Foundation
import Combine
import FunModel
import FunCore

@MainActor
public class Tab2ViewModel: ObservableObject {

    // MARK: - Coordinator

    private weak var coordinator: Tab2Coordinator?
    private weak var tabBarViewModel: HomeTabBarViewModel?

    // MARK: - Services

    @Service(.logger) private var logger: LoggerService

    // MARK: - Published State

    @Published public var searchText: String = ""
    @Published public var selectedCategory: String = "All"
    @Published public var searchResults: [FeaturedItem] = []
    @Published public var isSearching: Bool = false

    // MARK: - Configuration

    public var categories: [String] {
        let cats = Set(allItems.map { $0.category })
        return ["All"] + cats.sorted()
    }
    public let minimumSearchCharacters: Int = 2

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()
    private var allItems: [FeaturedItem] = []
    private var searchTask: Task<Void, Never>?

    // MARK: - Initialization

    public init(coordinator: Tab2Coordinator?, tabBarViewModel: HomeTabBarViewModel?) {
        self.coordinator = coordinator
        self.tabBarViewModel = tabBarViewModel
        loadItems()
        setupSearchBinding()
    }

    // MARK: - Setup

    private func setupSearchBinding() {
        // Debounce search text with minimum character requirement
        $searchText
            .dropFirst() // Skip initial value
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self else { return }
                let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

                // Only search if empty (show all) or meets minimum character requirement
                if trimmed.isEmpty || trimmed.count >= self.minimumSearchCharacters {
                    self.performSearch()
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Data Loading

    public func loadItems() {
        // Use the same items as the carousel and list for consistency
        allItems = FeaturedItem.allCarouselSets.flatMap { $0 }
        filterResults()
    }

    /// Perform async search with simulated network delay
    private func performSearch() {
        // Cancel any existing search task
        searchTask?.cancel()

        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        // If search is empty, just filter immediately without loading state
        if trimmedSearch.isEmpty {
            isSearching = false
            filterResults()
            return
        }

        searchTask = Task { [weak self] in
            guard let self else { return }

            // Show loading state
            self.isSearching = true

            // Simulate network delay (300-800ms)
            let delay = UInt64.random(in: 300_000_000...800_000_000)
            try? await Task.sleep(nanoseconds: delay)

            // Check if task was cancelled
            guard !Task.isCancelled else { return }

            // Perform filtering
            self.filterResults()
            self.isSearching = false
        }
    }

    private func filterResults() {
        var results = allItems

        // Filter by category (if not "All")
        if selectedCategory != "All" {
            results = results.filter { $0.category == selectedCategory }
        }

        // Filter by search text (case-insensitive)
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !trimmedSearch.isEmpty {
            results = results.filter { item in
                item.title.lowercased().contains(trimmedSearch) ||
                item.subtitle.lowercased().contains(trimmedSearch)
            }
        }

        searchResults = results
        logger.log("Filtered to \(results.count) results for: '\(searchText)' in category: '\(selectedCategory)'")
    }

    // MARK: - Actions

    public func clearSearch() {
        searchText = ""
        searchTask?.cancel()
        isSearching = false
        filterResults()
    }

    public func didSelectCategory(_ category: String) {
        selectedCategory = category
        logger.log("Category selected: \(category)")
        performSearch()
    }

    public func didSelectItem(_ item: FeaturedItem) {
        logger.log("Search result selected: \(item.title)")
        coordinator?.showDetail(for: item)
    }

    public func didTapSwitchToTab1() {
        tabBarViewModel?.switchToTab(0)
    }
}
