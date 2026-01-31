//
//  ProfileViewModel.swift
//  ViewModel
//
//  ViewModel for Profile screen
//

import Foundation
import Combine
import FunModel
import FunToolbox

@MainActor
public class ProfileViewModel: ObservableObject {

    // MARK: - Coordinator

    private weak var coordinator: ProfileCoordinator?

    // MARK: - Services

    @Service(.logger) private var logger: LoggerService

    // MARK: - Published State

    @Published public var userName: String = "Demo User"
    @Published public var userEmail: String = "demo@example.com"
    @Published public var userBio: String = "iOS Developer passionate about clean architecture"
    @Published public var viewCount: Int = 1234
    @Published public var favoritesCount: Int = 56
    @Published public var daysCount: Int = 42

    // MARK: - Initialization

    public init(coordinator: ProfileCoordinator?) {
        self.coordinator = coordinator
    }

    // MARK: - Actions

    public func didTapEditProfile() {
        logger.log("Edit profile tapped")
        // Would navigate to edit profile screen
    }

    public func didTapDismiss() {
        coordinator?.dismiss()
    }
}
