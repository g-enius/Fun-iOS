//
//  Tab3View.swift
//  UI
//
//  SwiftUI view for Tab3 (Items) screen
//

import SwiftUI
import FunViewModel
import FunModel

public struct Tab3View: View {
    @ObservedObject var viewModel: Tab3ViewModel

    public init(viewModel: Tab3ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        List {
            Section(header: Text(L10n.Items.loadedItems)) {
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
                            .accessibilityLabel(viewModel.isFavorited(item.id) ? "Remove from favorites" : "Add to favorites")
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
        }
        .listStyle(.insetGrouped)
        .accessibilityIdentifier(AccessibilityID.Tab3.itemsList)
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
