import RouteBlazer

enum FeatBRoutable: Routable {
  case viewA
  case viewB(param: String)

  var id: AnyHashable {
    switch self {
    case .viewA:
      return "feat_b_view_a"
    case .viewB(let param):
      return "feat_b_view_b_" + param
    }
  }
}
