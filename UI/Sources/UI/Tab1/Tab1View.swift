//
//  Tab1View.swift
//  UI
//
//  SwiftUI view for Tab1 (Home) screen
//

import SwiftUI
import FunViewModel
import FunModel

public struct Tab1View: View {
    @ObservedObject var viewModel: Tab1ViewModel

    public init(viewModel: Tab1ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Group {
            if viewModel.isLoading {
                VStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(1.5)
                    Text(L10n.Common.loading)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        if viewModel.isCarouselEnabled && !viewModel.featuredItems.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(L10n.Home.featured)
                                    .font(.headline)
                                    .padding(.horizontal)

                                TabView(selection: $viewModel.currentCarouselIndex) {
                                    ForEach(Array(viewModel.featuredItems.enumerated()), id: \.offset) { index, items in
                                        HStack(spacing: 16) {
                                            ForEach(items) { item in
                                                FeaturedCardView(
                                                    item: item,
                                                    isFavorited: viewModel.isFavorited(item.id),
                                                    onTap: {
                                                        viewModel.didTapFeaturedItem(item)
                                                    },
                                                    onFavoriteTap: {
                                                        viewModel.toggleFavorite(for: item.id)
                                                    }
                                                )
                                            }
                                        }
                                        .padding(.horizontal)
                                        .padding(.bottom, 40) // Make room for page indicator
                                        .tag(index)
                                    }
                                }
                                .tabViewStyle(.page(indexDisplayMode: .always))
                                .indexViewStyle(.page(backgroundDisplayMode: .always))
                                .frame(height: 240) // Increased height to accommodate indicator
                                .accessibilityIdentifier(AccessibilityID.Tab1.carousel)
                            }
                        }

                        VStack(spacing: 12) {
                            Button(action: { viewModel.didTapSettings() }) {
                                HStack {
                                    Image(systemName: "gearshape")
                                    Text(L10n.Tabs.settings)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                            }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier(AccessibilityID.Tab1.settingsButton)
                            .accessibilityLabel(L10n.Tabs.settings)

                            Button(action: { viewModel.didTapSwitchToTab2() }) {
                                HStack {
                                    Image(systemName: "arrow.right")
                                    Text(L10n.Home.switchToTab2)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple.opacity(0.2))
                                .cornerRadius(10)
                            }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier(AccessibilityID.Tab1.switchTabButton)
                            .accessibilityLabel(L10n.Tabs.search)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                .refreshable {
                    await viewModel.refresh()
                }
            }
        }
    }
}

struct FeaturedCardView: View {
    let item: FeaturedItem
    let isFavorited: Bool
    let onTap: () -> Void
    let onFavoriteTap: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: onTap) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(item.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding()
                .background(cardColor(for: item.color))
                .cornerRadius(12)
            }
            .buttonStyle(.plain)

            Button(action: onFavoriteTap) {
                Image(systemName: isFavorited ? "star.fill" : "star")
                    .font(.system(size: 20))
                    .foregroundColor(isFavorited ? .yellow : .white.opacity(0.8))
                    .padding(12)
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("favorite_button_\(item.id)")
            .accessibilityLabel(isFavorited ? "Remove from favorites" : "Add to favorites")
        }
        .accessibilityIdentifier("featured_card_\(item.id)")
        .accessibilityLabel("\(item.title), \(item.subtitle)")
        .accessibilityHint("Double tap to view details")
    }

    private func cardColor(for colorName: String) -> Color {
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
