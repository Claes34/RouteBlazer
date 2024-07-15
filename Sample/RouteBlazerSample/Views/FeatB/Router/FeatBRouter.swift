import RouteBlazer
import SwiftUI

// This router passes itself as environment object

final class FeatBRouter: Router {
  override var initialNavigationPathItem: NavigationPathItem {
    return .init(route: FeatBRoutable.viewA, viewBuilder: self)
  }
}

extension FeatBRouter: RoutableViewBuilder {
  @ViewBuilder
  func buildView(route: any Routable) -> some View {
    switch route as? FeatBRoutable {
    case .viewA:
      FeatBViewA()
        .environmentObject(self)
    case .viewB(let param):
      FeatBViewB(param: param)
        .environmentObject(self)
    case .none:
      Text("Unsupported routable")
    }
  }
}

// MARK: Actions
extension FeatBRouter {
  func pushViewB(param: String) {
    push(to: .init(route: FeatBRoutable.viewB(param: param), viewBuilder: self))
  }
}
