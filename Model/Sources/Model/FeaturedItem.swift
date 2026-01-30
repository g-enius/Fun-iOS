import Foundation

public struct FeaturedItem: Identifiable, Equatable, Sendable {
    public let id: String
    public let title: String
    public let subtitle: String
    public let iconName: String
    public let iconColor: String
    public let category: String
    public let timeLabel: String

    public init(
        id: String = UUID().uuidString,
        title: String,
        subtitle: String,
        iconName: String,
        iconColor: String,
        category: String = "General",
        timeLabel: String = "2 sec."
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
        self.iconColor = iconColor
        self.category = category
        self.timeLabel = timeLabel
    }

    /// Convenience initializer with just color (uses color as iconColor and default icon)
    public init(
        id: String = UUID().uuidString,
        title: String,
        subtitle: String,
        color: String
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.iconName = "star.fill"
        self.iconColor = color
        self.category = "General"
        self.timeLabel = "2 sec."
    }

    /// Color accessor for SwiftUI views
    public var color: String {
        iconColor
    }
}

public extension FeaturedItem {
    // Carousel Set 1 items
    static let asyncAwait = FeaturedItem(
        id: "asyncawait",
        title: "Async/Await",
        subtitle: "Modern concurrency in S...",
        iconName: "bolt.fill",
        iconColor: "green",
        category: "Concurrency",
        timeLabel: "5 sec."
    )

    static let combine = FeaturedItem(
        id: "combine",
        title: "Combine",
        subtitle: "Reactive programming",
        iconName: "arrow.triangle.merge",
        iconColor: "orange",
        category: "Reactive",
        timeLabel: "4 sec."
    )

    // Carousel Set 2 items
    static let swiftUI = FeaturedItem(
        id: "swiftui",
        title: "SwiftUI",
        subtitle: "Declarative UI framework",
        iconName: "swift",
        iconColor: "blue",
        category: "UI Framework",
        timeLabel: "4 sec."
    )

    static let coordinator = FeaturedItem(
        id: "coordinator",
        title: "Coordinator",
        subtitle: "Navigation pattern",
        iconName: "arrow.triangle.branch",
        iconColor: "purple",
        category: "Navigation",
        timeLabel: "3 sec."
    )

    // Carousel sets that rotate every 5 seconds
    static let carouselSet1: [FeaturedItem] = [.asyncAwait, .combine]
    static let carouselSet2: [FeaturedItem] = [.swiftUI, .coordinator]
    static let allCarouselSets: [[FeaturedItem]] = [carouselSet1, carouselSet2]
}
