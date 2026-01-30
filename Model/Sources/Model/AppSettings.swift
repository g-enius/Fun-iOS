import Foundation

public struct AppSettings: Equatable, Sendable {
    public var isDarkMode: Bool
    public var isProfileScreenEnabled: Bool
    public var isToastNotificationsEnabled: Bool
    public var isFeaturedCarouselEnabled: Bool

    public init(
        isDarkMode: Bool = false,
        isProfileScreenEnabled: Bool = true,
        isToastNotificationsEnabled: Bool = true,
        isFeaturedCarouselEnabled: Bool = true
    ) {
        self.isDarkMode = isDarkMode
        self.isProfileScreenEnabled = isProfileScreenEnabled
        self.isToastNotificationsEnabled = isToastNotificationsEnabled
        self.isFeaturedCarouselEnabled = isFeaturedCarouselEnabled
    }

    public static let `default` = AppSettings()
}
