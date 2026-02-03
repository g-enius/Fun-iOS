//
//  HomeView.swift
//  UI
//
//  SwiftUI view for Home screen
//

import SwiftUI
import FunViewModel
import FunModel

public struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    public init(viewModel: HomeViewModel) {
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
            } else if viewModel.isCarouselEnabled && !viewModel.featuredItems.isEmpty {
                ScrollView {
                    VStack(spacing: 20) {
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
                                    .tag(index)
                                }
                            }
                            .tabViewStyle(.page(indexDisplayMode: .never))
                            .frame(height: 220)
                            .accessibilityIdentifier(AccessibilityID.Home.carousel)

                            // Custom page indicator below the carousel
                            PageIndicatorView(
                                currentIndex: viewModel.currentCarouselIndex,
                                pageCount: viewModel.featuredItems.count
                            )
                            .frame(maxWidth: .infinity)
                            .padding(.top, 12)
                        }
                    }
                    .padding(.vertical)
                }
                .refreshable {
                    await viewModel.refresh()
                }
            } else {
                // Empty state when carousel is disabled
                CarouselDisabledView()
            }
        }
    }
}

// MARK: - Empty State View

struct CarouselDisabledView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "rectangle.stack.badge.minus")
                .font(.system(size: 64))
                .foregroundColor(.gray)

            Text(L10n.Home.carouselDisabled)
                .font(.title2)
                .fontWeight(.semibold)

            Text(L10n.Home.enableFromSettings)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Page Indicator View

struct PageIndicatorView: View {
    let currentIndex: Int
    let pageCount: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<pageCount, id: \.self) { index in
                Circle()
                    .fill(index == currentIndex ? Color.blue : Color.gray.opacity(0.4))
                    .frame(width: 8, height: 8)
                    .animation(.easeInOut(duration: 0.2), value: currentIndex)
            }
        }
    }
}

// MARK: - Featured Card View

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
                .contentShape(Rectangle())
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
            .accessibilityLabel(isFavorited ? L10n.Detail.removeFromFavorites : L10n.Detail.addToFavorites)
        }
        .accessibilityIdentifier("featured_card_\(item.id)")
        .accessibilityLabel("\(item.title), \(item.subtitle)")
        .accessibilityHint(L10n.Accessibility.doubleTapToViewDetails)
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
