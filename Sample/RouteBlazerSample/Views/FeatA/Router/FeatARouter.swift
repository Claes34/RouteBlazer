import RouteBlazer
import SwiftUI

// This router passes itself as navDelegate specific to each view

final class FeatARouter: Router {
  override var initialNavigationPathItem: NavigationPathItem {
    return .init(route: FeatARoutable.viewA, viewBuilder: self)
  }
}

extension FeatARouter: RoutableViewBuilder {
  @ViewBuilder
  func buildView(route: any Routable) -> some View {
    switch route as? FeatARoutable {
    case .viewA:
      FeatAViewA(navDelegate: self)
    case .viewB:
      FeatAViewB(navDelegate: self)
    case .none:
      Text("Unsupported routable")
    }
  }
}

// MARK: - Nav Delegate implementations

extension FeatARouter: FeatAViewANavDelegate {
  func didPressPushToB() {
    push(to: .init(route: FeatARoutable.viewB, viewBuilder: self))
  }
}

extension FeatARouter: FeatAViewBNavDelegate {
  func didPressPushToFeatB() {
    let featBRouter = FeatBRouter()
    push(new: featBRouter)
  }
  
  func didPressPresentFeatB() {
    let featBRouter = FeatBRouter()
    try? presentFullScreen(featBRouter)
  }
  
  func didPressPresentSheetFeatB() {
    let featBRouter = FeatBRouter()
    try? presentSheet(featBRouter)
  }
}

