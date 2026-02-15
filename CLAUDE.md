# Fun-iOS

## Project Overview

SwiftUI + UIKit hybrid iOS app using MVVM-Coordinator pattern. 6 SPM packages with clear dependency layers, session-scoped dependency injection, and Combine for reactive state.

## Build & Test

- **Workspace:** `Fun.xcworkspace` (integrates all packages + FunApp)
- **Xcode project:** `FunApp/FunApp.xcodeproj`
- **Swift tools version:** 6.0
- **Platform:** iOS 15+ (packages), macCatalyst 15+
- `swift test` does **NOT** work — packages are iOS-only, no macOS target

### Commands

```bash
# Build the app
xcodebuild build -workspace Fun.xcworkspace -scheme FunApp \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -configuration Debug CODE_SIGNING_ALLOWED=NO

# Run ALL tests (via workspace)
xcodebuild test -workspace Fun.xcworkspace -scheme FunApp \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'

# Run individual package tests
xcodebuild test -workspace Fun.xcworkspace -scheme CoreTests \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' CODE_SIGNING_ALLOWED=NO
xcodebuild test -workspace Fun.xcworkspace -scheme ModelTests \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' CODE_SIGNING_ALLOWED=NO
xcodebuild test -workspace Fun.xcworkspace -scheme ServicesTests \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' CODE_SIGNING_ALLOWED=NO
xcodebuild test -workspace Fun.xcworkspace -scheme ViewModelTests \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' CODE_SIGNING_ALLOWED=NO
xcodebuild test -workspace Fun.xcworkspace -scheme UITests \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' CODE_SIGNING_ALLOWED=NO

# Lint
swiftlint lint
```

## Package Architecture

```
Coordinator → UI → ViewModel → Model → Core
                                  ↑
Services ─────────────────────────┘ (also → Core)
```

| Package | Product | Depends On | Purpose |
|---------|---------|-----------|---------|
| **Core** | `FunCore` | — | ServiceLocator, @Service wrapper, Session protocol, localization |
| **Model** | `FunModel`, `FunModelTestSupport` | Core | Domain models, coordinator protocols, service protocols, test mocks |
| **Services** | `FunServices` | Model, Core | Concrete service implementations (network, favorites, logger, etc.) |
| **ViewModel** | `FunViewModel` | Model, Core | @MainActor ObservableObject VMs with Combine |
| **UI** | `FunUI` | ViewModel, Model, Core | SwiftUI views + UIViewController wrappers |
| **Coordinator** | `FunCoordinator` | Model, ViewModel, UI, Core | Navigation logic, flow management |
| **FunApp** (Xcode) | FunApp.app | All packages | App entry point, SceneDelegate, AppSessionFactory |

## Code Style & Conventions

- **Swift 6 strict concurrency** — `@MainActor` on all ViewModels, coordinators, services, ServiceLocator
- **SwiftUI + UIKit hybrid** — SwiftUI for views, UIKit `UINavigationController` for navigation
- **MVVM-Coordinator (MVVM-C)** — Views observe ViewModels, ViewModels delegate navigation to coordinators
- **Combine over NotificationCenter** — All reactive state uses `@Published` / publishers
- **Weak coordinator refs in ViewModels** — enforced by SwiftLint custom rule; prevents retain cycles
- **Navigation logic ONLY in Coordinators** — never in Views or ViewModels
- **Protocol placement:** Core = reusable abstractions, Model = domain-specific protocols
- **ServiceLocator with @Service property wrapper** — lazy resolution via `ServiceLocator.shared.resolve()`; uses `fatalError` on missing service to surface DI issues immediately
- **No direct `UserDefaults.standard`** outside Services/ — use service wrappers for testability
- **No `print()` statements** — use `LoggerService` (OSLog-based)

## Architecture Details

### Dependency Injection (Session-Scoped)

Two session types control which services are available:

- **LoginSession** — registers: logger, network, featureToggles
- **AuthenticatedSession** — registers: all of the above + favorites, toast, ai

Flow transitions managed by `AppCoordinator`:
1. Current session calls `teardown()` → `ServiceLocator.shared.reset()`
2. New session calls `activate()` → registers its services

```swift
// ViewModel usage
@Service(.logger) private var logger: LoggerService
@Service(.favorites) private var favoritesService: FavoritesServiceProtocol
```

**ServiceKey enum:** `.network`, `.logger`, `.favorites`, `.toast`, `.featureToggles`, `.ai`

### Coordinator Pattern

- **Protocols** defined in Model layer (e.g., `LoginCoordinator`, `HomeCoordinator`)
- **Implementations** in Coordinator package (e.g., `LoginCoordinatorImpl`)
- **BaseCoordinator** provides safe navigation helpers (`safePush`, `safePop`, `safePresent`, `safeDismiss`) with transition retry queue
- **AppCoordinator** is root — manages login ↔ main flow transitions and deep link queuing

Coordinator hierarchy (main flow):
```
AppCoordinator
├── HomeCoordinatorImpl    (Home tab)
│   ├── DetailCoordinatorImpl
│   └── ProfileCoordinatorImpl (modal)
├── ItemsCoordinatorImpl   (Items tab)
│   └── DetailCoordinatorImpl
└── SettingsCoordinatorImpl (Settings tab)
```

All tabs wrapped in `HomeTabBarController` (UITabBarController subclass).

### View Layer Pattern

Each screen has a SwiftUI view + UIViewController wrapper:
```swift
// UIKit wrapper (for coordinator navigation)
public final class LoginViewController: UIViewController {
    private let viewModel: LoginViewModel
    override public func viewDidLoad() {
        embedSwiftUIView(LoginView(viewModel: viewModel))
    }
}

// SwiftUI view (pure UI)
public struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
}
```

### Deep Linking

`DeepLink` enum in Model: `.tab(TabIndex)`, `.item(id: String)`, `.profile`

URL scheme: `funapp://tab/items`, `funapp://item/swiftui`, `funapp://profile`

Deep links received during login are queued in `AppCoordinator.pendingDeepLink` and executed after authentication.

## Testing

### Framework & Conventions

- **Swift Testing** framework (`import Testing`, `@Test`, `#expect`, `@Suite`) — NOT XCTest
- Exception: snapshot tests use XCTest (required by swift-snapshot-testing)
- Use `init()` on test structs for common setup, not `setupServices()` in every test
- Consolidate thin init tests into a single test when they test the same concern
- All test suites use `@MainActor` and `.serialized` trait
- `ServiceLocator.shared.reset()` in setup before registering mocks

### Mock Location

Centralized mocks in `Model/Sources/ModelTestSupport/`:
- `MockLoggerService`, `MockFavoritesService`, `MockToastService`, `MockAIService`, `MockFeatureToggleService`
- `MockLoginCoordinator`, `MockHomeCoordinator`, `MockDetailCoordinator`, `MockProfileCoordinator`, `MockTabCoordinator`

All mocks track method calls via boolean flags and captured state for assertion.

### Test Pattern Example

```swift
@MainActor
@Suite("HomeViewModel Tests", .serialized)
struct HomeViewModelTests {
    init() {
        ServiceLocator.shared.reset()
        ServiceLocator.shared.register(MockLoggerService(), for: .logger)
        ServiceLocator.shared.register(MockFavoritesService(), for: .favorites)
        ServiceLocator.shared.register(MockToastService(), for: .toast)
        ServiceLocator.shared.register(MockFeatureToggleService(), for: .featureToggles)
    }

    @Test("Initial hasError is false on creation")
    func testInitialState() {
        let viewModel = HomeViewModel(coordinator: nil)
        #expect(viewModel.hasError == false)
    }
}
```

### Async Testing Helper

`ViewModel/Tests/ViewModelTests/TestHelpers.swift` provides:
```swift
@MainActor
func waitForCondition(timeout: TimeInterval = 3.0, _ condition: @MainActor () -> Bool) async
```
Polls at 10ms intervals. Use for waiting on async state changes / publisher propagation.

### Snapshot Tests

- Location: `UI/Tests/UITests/SnapshotTests/`
- Framework: swift-snapshot-testing (PointFree, v1.15+)
- Baselines in `__Snapshots__/` subdirectories
- Tests multiple devices and light/dark appearance
- `recording` property controls baseline regeneration (normally `false`)
- CI runs these with `continue-on-error: true` (can be flaky)

## SwiftLint

Config: `.swiftlint.yml`

### Key Limits

| Rule | Warning | Error |
|------|---------|-------|
| Line length | 120 | 200 |
| File length | 500 | 1000 |
| Type body | 300 | 500 |
| Function body | 60 | 100 |
| Function params | 6 | 8 |
| Cyclomatic complexity | 15 | 25 |

### Custom Rules

- **`weak_coordinator_in_viewmodel`** — coordinator properties in `*ViewModel.swift` must be `weak var`
- **`weak_delegate`** — all delegate properties must be `weak var`
- **`no_print`** — use Logger, not `print()`
- **`no_direct_userdefaults`** — no `UserDefaults.standard` outside `Services/`

### Excluded from Linting

- `*/Generated/*`, `*/Tests/*`, `*/.build/*`, `*/DerivedData/*`

## CI (GitHub Actions)

Workflow: `.github/workflows/ci.yml` — runs on push/PR to `main`

1. **SwiftLint** job — lint with github-actions-logging reporter
2. **Build & Test** job — builds FunApp, then runs CoreTests, ModelTests, ServicesTests, ViewModelTests, UITests (snapshot tests are continue-on-error)

## File Organization Quick Reference

```
FunApp/FunApp/
  AppDelegate.swift          # Empty (logic in SceneDelegate)
  SceneDelegate.swift        # Window setup, AppCoordinator init, deep links
  AppSessionFactory.swift    # Composition root: AppFlow → Session

Core/Sources/Core/
  ServiceLocator.swift       # DI registry + @Service property wrapper
  Session.swift              # Session protocol (activate/teardown)
  Bundle+AppInfo.swift       # Bundle utilities
  Generated/Strings.swift    # SwiftGen localization (L10n)

Model/Sources/Model/
  Coordinators/              # Coordinator protocols (LoginCoordinator, etc.)
  Services/                  # Service protocols (LoggerService, NetworkService, etc.)
  AppFlow.swift              # .login | .main enum
  DeepLink.swift             # Deep link URL parsing
  FeaturedItem.swift         # Featured item data model
  TabIndex.swift             # Tab enumeration
Model/Sources/ModelTestSupport/  # All shared mocks

Services/Sources/Services/CoreServices/
  Default*Service.swift      # Concrete service implementations
  LoginSession.swift         # Login-scoped DI session
  AuthenticatedSession.swift # Authenticated-scoped DI session

ViewModel/Sources/ViewModel/
  <Feature>/                 # One subfolder per feature (Login/, Home/, Detail/, etc.)
    <Feature>ViewModel.swift # @MainActor ObservableObject

UI/Sources/UI/
  <Feature>/                 # One subfolder per feature
    <Feature>View.swift      # SwiftUI view
    <Feature>ViewController.swift  # UIKit wrapper
  Components/                # Shared UI components (ToastView)
  Extensions/                # UIViewController+SwiftUI, Color+Named, etc.

Coordinator/Sources/Coordinator/
  BaseCoordinator.swift      # Safe navigation base class
  AppCoordinator.swift       # Root coordinator (flow management)
  <Feature>CoordinatorImpl.swift  # Navigation implementations
```
