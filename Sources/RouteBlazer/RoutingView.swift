//  RoutingView.swift
//  Created by Nicolas FONTAINE

import SwiftUI
import UIKit

/// RoutingView is the main view holding the native `NavigationStack` component
/// enabling the usage of Routers.
public struct RoutingView: View {
  @ObservedObject var router: Router

  public init(router: Router) {
    self.router = router
  }

  public var body: some View {
    NavigationStack(path: router.navigationPath) {
      router.initialView
        .navigationDestination(for: NavigationPathItem.self, destination: { navPathItem in
          if navPathItem.viewBuilder != nil {
            AnyView(navPathItem.viewBuilder!.buildView(route: navPathItem.route))
          } else {
            EmptyView()
          }
        })
    }
    .sheet(item: router.presentingSheet) { sheetRouter in
      sheetRouter.buildRoutingView()
    }
    .fullScreenCover(item: router.presentingFullScreen) { fullscreenCoverRouter in
      fullscreenCoverRouter.buildRoutingView()
    }
  }
}
