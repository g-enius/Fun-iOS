//
//  Tab2ViewModel.swift
//  ViewModel
//
//  ViewModel for Tab2 (Search) screen
//

import Foundation
import Combine
import FunModel
import FunToolbox

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
    @Published public var searchResults: [SearchResult] = []
    @Published public var isSearching: Bool = false

    // MARK: - Configuration

    public let categories = ["All", "Tech", "Design", "Business"]
    public let minimumSearchCharacters: Int = 2

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()
    private var allItems: [SearchResult] = []
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
        allItems = [
            SearchResult(id: "1", title: "Swift Concurrency", subtitle: "Async/await patterns", category: "Tech"),
            SearchResult(id: "2", title: "UI Design", subtitle: "Modern interfaces", category: "Design"),
            SearchResult(id: "3", title: "Architecture", subtitle: "App structure", category: "Tech"),
            SearchResult(id: "4", title: "Business Logic", subtitle: "Domain modeling", category: "Business"),
            SearchResult(id: "5", title: "Color Theory", subtitle: "Visual harmony", category: "Design"),
            SearchResult(id: "6", title: "Market Analysis", subtitle: "Competitive research", category: "Business")
        ]
        filterResults()
    }

    /// Perform async search with simulated network delay
    private func performSearch() {
        // Cancel any existing search task
        searchTask?.cancel()

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

    public func didSelectResult(_ result: SearchResult) {
        logger.log("Search result selected: \(result.title)")
        coordinator?.showDetail(for: result.title)
    }

    public func didTapSwitchToTab1() {
        tabBarViewModel?.switchToTab(0)
    }
}
