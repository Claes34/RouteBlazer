import SwiftUI

struct FeatBViewB {
  @EnvironmentObject var featBRouter: FeatBRouter

  let param: String
}

extension FeatBViewB: View {
  var body: some View {
    VStack(spacing: 24) {
      Text("Feat B View B")
        .font(.title)

      Text(param)

      Button {
        featBRouter.pop()
      } label: {
        Text("Pop")
      }

      Button {
        featBRouter.popToRoot()
      } label: {
        Text("Pop to root")
      }
    }
  }
}

#Preview {
  FeatBViewB(param: "param 1")
}
