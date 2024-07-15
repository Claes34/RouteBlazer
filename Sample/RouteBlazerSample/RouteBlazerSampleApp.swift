import SwiftUI

@main
struct RouteBlazerSampleApp: App {
  @StateObject var featARouter = FeatARouter()

  var body: some Scene {
    WindowGroup {
      featARouter.buildRoutingView()
    }
  }
}
