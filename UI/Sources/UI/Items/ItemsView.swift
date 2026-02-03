//
//  ItemsView.swift
//  UI
//
//  SwiftUI view for Items screen - combines search, filter, and items list
//

import SwiftUI
import FunViewModel
import FunModel

public struct ItemsView: View {
    @ObservedObject var viewModel: ItemsViewModel

    public init(viewModel: ItemsViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Category filter horizontal scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.categories, id: \.self) { category in
                        Button(action: { viewModel.didSelectCategory(category) }) {
                            Text(category)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    viewModel.selectedCategory == category
                                        ? Color.blue
                                        : Color.gray.opacity(0.2)
                                )
                                .foregroundColor(
                                    viewModel.selectedCategory == category
                                        ? .white
                                        : .primary
                                )
                                .cornerRadius(20)
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("category_\(category)")
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
            .accessibilityIdentifier(AccessibilityID.Items.categoryPicker)

            // Content area
            if viewModel.isSearching {
                Spacer()
                ProgressView(L10n.Search.searching)
                    .progressViewStyle(.circular)
                Spacer()
            } else if viewModel.needsMoreCharacters {
                Spacer()
                KeepTypingView(minimumCharacters: viewModel.minimumSearchCharacters)
                Spacer()
            } else if viewModel.items.isEmpty {
                Spacer()
                EmptyItemsView(message: emptyStateMessage)
                Spacer()
            } else {
                List {
                    ForEach(viewModel.items) { item in
                        Button(action: { viewModel.didSelectItem(item) }) {
                            HStack(spacing: 12) {
                                // Icon with color background
                                Image(systemName: item.iconName)
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                                    .background(iconColor(for: item.iconColor))
                                    .cornerRadius(8)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.title)
                                        .font(.headline)
                                    Text(item.subtitle)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Text(item.category)
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }

                                Spacer()

                                Button(action: { viewModel.toggleFavorite(for: item.id) }) {
                                    Image(systemName: viewModel.isFavorited(item.id) ? "star.fill" : "star")
                                        .font(.system(size: 20))
                                        .foregroundColor(viewModel.isFavorited(item.id) ? .yellow : .gray)
                                }
                                .buttonStyle(.plain)
                                .accessibilityIdentifier("favorite_button_\(item.id)")
                                .accessibilityLabel(
                                    viewModel.isFavorited(item.id)
                                        ? L10n.Detail.removeFromFavorites
                                        : L10n.Detail.addToFavorites
                                )
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("item_\(item.id)")
                        .accessibilityLabel("\(item.title), \(item.subtitle)")
                        .swipeActions(edge: .trailing) {
                            Button(action: { viewModel.toggleFavorite(for: item.id) }) {
                                Label(
                                    viewModel.isFavorited(item.id) ? L10n.Items.unfavorite : L10n.Items.favorite,
                                    systemImage: viewModel.isFavorited(item.id) ? "star.slash" : "star"
                                )
                            }
                            .tint(.yellow)
                        }
                    }
                }
                .listStyle(.plain)
                .accessibilityIdentifier(AccessibilityID.Items.itemsList)
            }

            // Search bar at bottom
            SearchBarView(
                text: $viewModel.searchText,
                isSearching: viewModel.isSearching,
                minimumCharacters: viewModel.minimumSearchCharacters,
                onClear: { viewModel.clearSearch() }
            )
            .accessibilityIdentifier(AccessibilityID.Items.searchField)
        }
    }

    private var emptyStateMessage: String {
        let trimmed = viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty && trimmed.count < viewModel.minimumSearchCharacters {
            return L10n.Search.typeMinCharacters(viewModel.minimumSearchCharacters)
        }
        return L10n.Search.tryDifferentTerm
    }

    private func iconColor(for colorName: String) -> Color {
        switch colorName {
        case "green": return .green
        case "orange": return .orange
        case "blue": return .blue
        case "purple": return .purple
        case "indigo": return .indigo
        case "brown": return .brown
        case "teal": return .teal
        case "mint": return .mint
        case "cyan": return .cyan
        case "gray": return .gray
        case "red": return .red
        case "pink": return .pink
        default: return .gray
        }
    }
}

// MARK: - Search Bar View

struct SearchBarView: View {
    @Binding var text: String
    let isSearching: Bool
    let minimumCharacters: Int
    let onClear: () -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 8) {
                // Search icon or loading indicator
                if isSearching {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(0.8)
                        .frame(width: 20, height: 20)
                } else {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                }

                TextField(L10n.Search.minCharacters(minimumCharacters), text: $text)
                    .textFieldStyle(.plain)
                    .focused($isFocused)
                    .submitLabel(.search)

                if !text.isEmpty {
                    Button(action: onClear) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .cornerRadius(10)

            // Always reserve space for Cancel button to prevent layout shift
            Button(L10n.Common.cancel) {
                text = ""
                isFocused = false
                onClear()
            }
            .foregroundColor(.blue)
            .opacity(isFocused ? 1 : 0)
            .disabled(!isFocused)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
}

// MARK: - Keep Typing View

struct KeepTypingView: View {
    let minimumCharacters: Int

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "keyboard")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            Text(L10n.Search.keepTyping)
                .font(.title2)
                .fontWeight(.semibold)
            Text(L10n.Search.typeMinCharacters(minimumCharacters))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// MARK: - Empty Items View

struct EmptyItemsView: View {
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            Text(L10n.Search.noResults)
                .font(.title2)
                .fontWeight(.semibold)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
