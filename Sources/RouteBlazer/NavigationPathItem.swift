//  NavigationPathItem.swift
//  Created by Nicolas FONTAINE

import Foundation

private final class ViewBuilderHolder {
  weak var viewBuilder: (any RoutableViewBuilder)?

  init(viewBuilder: (any RoutableViewBuilder)? = nil) {
    self.viewBuilder = viewBuilder
  }
}

public struct NavigationPathItem: Equatable {
  public private(set) var route: any Routable
  private var viewBuilderHolder: ViewBuilderHolder

  public var viewBuilder: (any RoutableViewBuilder)? {
    return viewBuilderHolder.viewBuilder
  }

  public init(route: any Routable, viewBuilder: any RoutableViewBuilder) {
    self.viewBuilderHolder = .init(viewBuilder: viewBuilder)
    self.route = route
  }

  public static func == (lhs: NavigationPathItem, rhs: NavigationPathItem) -> Bool {
    return AnyEquatable.areEqual(first: lhs.route, second: rhs.route)
  }
}

extension NavigationPathItem: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(route)
  }
}
