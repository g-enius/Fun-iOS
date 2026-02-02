//
//  HomeTabBarController.swift
//  UI
//
//  Tab bar controller that displays the main tabs of the app
//  Coordinators are injected from outside to avoid circular dependencies
//

import UIKit
import Combine
import FunViewModel
import FunModel

public class HomeTabBarController: UITabBarController {

    // MARK: - ViewModel

    private let viewModel: HomeTabBarViewModel

    // MARK: - Combine

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(viewModel: HomeTabBarViewModel, tabNavigationControllers: [UINavigationController]) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        delegate = self
        viewControllers = tabNavigationControllers
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Sync initial tab selection
        viewModel.selectedTabIndex = selectedIndex

        // Observe view model for programmatic tab changes
        Task { @MainActor [weak self] in
            guard let self else { return }
            for await index in viewModel.$selectedTabIndex.values where self.selectedIndex != index {
                self.selectedIndex = index
            }
        }

        updateAppearance()
        observeAppSettingChanges()
    }

    // MARK: - Appearance (Combine)

    private func observeAppSettingChanges() {
        AppSettingsPublisher.shared.settingsDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.updateAppearance()
            }
            .store(in: &cancellables)
    }

    private func updateAppearance() {
        let isDarkModeEnabled = UserDefaults.standard.bool(forKey: .darkModeEnabled)
        let style: UIUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
        overrideUserInterfaceStyle = style

        if let windowScene = view.window?.windowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = style
            }
        }

        if let presented = presentedViewController {
            presented.overrideUserInterfaceStyle = style
        }
    }
}

// MARK: - UITabBarControllerDelegate

extension HomeTabBarController: UITabBarControllerDelegate {
    public func tabBarController(
        _ tabBarController: UITabBarController,
        didSelect viewController: UIViewController
    ) {
        viewModel.tabDidChange(to: selectedIndex)
    }
}
