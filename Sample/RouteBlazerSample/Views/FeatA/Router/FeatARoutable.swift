import RouteBlazer

enum FeatARoutable: Routable {
  case viewA
  case viewB

  var id: AnyHashable {
    switch self {
    case .viewA:
      return "feat_a_view_a"
    case .viewB:
      return "feat_a_view_b"
    }
  }
}
