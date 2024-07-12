//  Router.swift
//  Created by Nicolas FONTAINE

import Combine
import Foundation
import SwiftUI

enum RouterError: Error {
  case alreadyPresenting
}

open class Router: ObservableObject, Identifiable {
  public let id: UUID = .init()
  private var listenForPopCancellable: AnyCancellable?

  @Published private var state: State = .init()

  public init() {}

  public private(set) var children: [Router] = []
  public private(set) weak var parent: Router?
  public private(set) weak var presentingParent: Router?

  /// Boolean giving the information of wether this router is the root of its navigation stack / owner of the navigation path
  public var isRoot: Bool {
    return parent == nil
  }

  /// Recursive dynamic variable that will return the root Router of the relative navigation stack of this Router.
  /// If a router has no parent, then the returned value will be self
  public var stateHolderRouter: Router {
    guard let parent else {
      return self
    }

    return parent.stateHolderRouter
  }

  /// Dynamic variable that HAS TO be overritten with the right NavigationPathItem for your router.
  /// This initialNavigationPathItem will serve as the first view shown by this router in various situations :
  /// - When using a new `RoutingView`
  /// - When pushing a new `Router` on a navigation stack using the `push(_ router:)` method.
  /// - When presenting a new `RoutingView` using the `push(_ router:)` method
  open var initialNavigationPathItem: NavigationPathItem {
    fatalError("Do not use Router as is, override it and override this dynamic variable")
  }

  /// Dynamic variable that will build a view using the `initialNavigationPath` variable.
  @ViewBuilder
  public var initialView: some View {
    let initialPathItem = initialNavigationPathItem
    if (initialPathItem.viewBuilder != nil) {
      AnyView(initialPathItem.viewBuilder!.buildView(route: initialPathItem.route))
    } else {
      EmptyView()
    }
  }

  /// A method that can be overritten if you need to use a different component then `RoutingView` (a component on top it for example).
  /// This method will be used when presenting a new Router from another one.
  /// - Returns: A RoutingView using this `Router`.
  /// - Usage example:
  /// ```swift
  ///  @main
  ///  struct MyApp: App {
  ///    var body: some Scene {
  ///      WindowGroup {
  ///        myRouter.buildRoutingView()
  ///      }
  ///    }
  ///  }
  /// ```
  @ViewBuilder
  open func buildRoutingView() -> AnyView {
    AnyView(
      RoutingView(router: self)
    )
  }
}

// MARK: - State & Binding accessors

public extension Router {
  struct State {
    public internal(set) var navigationPath: [NavigationPathItem] = []
    public internal(set) var presentingSheet: Router? = nil
    public internal(set) var presentingFullscreen: Router? = nil

    var isPresenting: Bool {
      presentingSheet != nil  || presentingFullscreen != nil
    }
  }

  var navigationPath: Binding<[NavigationPathItem]> {
    binding(keyPath: \.navigationPath)
  }

  var presentingSheet: Binding<Router?> {
    binding(keyPath: \.presentingSheet)
  }

  var presentingFullScreen: Binding<Router?> {
    binding(keyPath: \.presentingFullscreen)
  }
}

private extension Router {
  func binding<T>(keyPath: WritableKeyPath<State, T>) -> Binding<T> {
    Binding(
      get: { self.state[keyPath: keyPath] },
      set: { self.state[keyPath: keyPath] = $0 }
    )
  }
}

// MARK: - Routing methods

public extension Router {
  /// Push a new path Item to the navigation stack
  /// - parameter pathItem: The `NavigationPathItem` to push to the stack
  func push(to pathItem: NavigationPathItem) {
    stateHolderRouter.state.navigationPath.append(pathItem)
  }

  /// Push a new router to the navigation stack of this very router.
  /// The `initialView` of this new router will be the first pushed view.
  /// You can use this new router to push other views / routers.
  /// - parameter pathItem: The `NavigationPathItem` to push to the stack
  func push(new router: Router) {
    router.pushAsChild(of: self)
  }

  /// Pop one or more views from the navigation stack
  /// - parameter count: The number of views to pop from the stack
  func pop(_ count: Int = 1) {
    stateHolderRouter.state.navigationPath.removeLast(count)
  }

  /// Pop to the root view of the navigation stack
  func popToRoot() {
    stateHolderRouter.state.navigationPath.removeAll()
  }

  /// Present as sheet the provided `Router`
  /// A new RoutingView will be presented using the overridable `buildRootingView` method of this `Router`
  /// - parameter sheetRouter: The router to be presented in a sheet
  func presentSheet(_ sheetRouter: Router) throws {
    guard !stateHolderRouter.state.isPresenting else {
      throw RouterError.alreadyPresenting
    }
    let rootRouter = stateHolderRouter
    rootRouter.state.presentingSheet = sheetRouter
    sheetRouter.presentingParent = rootRouter
  }

  /// Present fullscreen the provided `Router`
  /// A new RoutingView will be presented using the overridable `buildRootingView` method of this `Router`
  /// - parameter fullscreenCoverRouter: The router to be presented fullscreen
  func presentFullScreen(_ fullscreenCoverRouter: Router) throws {
    guard !stateHolderRouter.state.isPresenting else {
      throw RouterError.alreadyPresenting
    }
    let rootRouter = stateHolderRouter
    rootRouter.state.presentingFullscreen = fullscreenCoverRouter
    fullscreenCoverRouter.presentingParent = rootRouter
  }

  /// If the current Router is presenting, this method will dismiss the presented router
  /// else it dismisses this router if it is presented or its parent is (in case of multiple router added for the same navigation stack).
  func dismiss() {
    let rootRouter = stateHolderRouter
    if rootRouter.state.presentingSheet != nil {
      rootRouter.state.presentingSheet = nil
    } else if rootRouter.state.presentingFullscreen != nil {
      rootRouter.state.presentingFullscreen = nil
    } else if rootRouter.presentingParent != nil {
      presentingParent?.dismiss()
    }
  }
}

// MARK: - Router parenting methods

private extension Router {
  ///  this router as child, setting up references of this router and it's parent
  /// - parameter parent: The parent router
  func pushAsChild(of parent: Router) {
    parent.addChild(self)
    self.parent = parent
    let initialNavigationPathItem = self.initialNavigationPathItem
    push(to: initialNavigationPathItem)
    listenForPop(of: initialNavigationPathItem)
  }

  /// Start listening for the removal of the parameter provided NavigationPathItem.
  /// Upon finding that this NavigationPathItem has disappeared, this router will remove references of it from its parent in order to be destroyed
  /// - parameter initialNavigationPathItem: the NavigationPathItem to search in navigationPath to ensure this router should still live
  func listenForPop(of initialNavigationPathItem: NavigationPathItem) {
    listenForPopCancellable = stateHolderRouter.$state
      .dropFirst()
      .map { $0.navigationPath }
      .sink(receiveValue: { [weak self] navigationPath in
        guard let self else { return }
        if !navigationPath.contains(where: { $0 == initialNavigationPathItem }) {
          parent?.removeChild(self)
          self.parent = nil
          self.listenForPopCancellable?.cancel()
        }
      })
  }

  /// Add a new router in the array of children of this router
  /// - parameter router: the child router to add
  func addChild(_ router: Router) {
    children.append(router)
  }

  /// Attempt to remove a child from the children array if this array contains it
  /// - parameter router: the child router to remove from the children array
  func removeChild(_ router: Router) {
    children.removeAll(where: {
      $0 === router
    })
  }
}

