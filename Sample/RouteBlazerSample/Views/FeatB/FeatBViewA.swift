import SwiftUI

struct FeatBViewA {
  @EnvironmentObject var featBRouter: FeatBRouter
}

extension FeatBViewA: View {
  var body: some View {
    VStack(spacing: 24) {
      Text("Feat B View A")
        .font(.title)

      Button {
        featBRouter.pushViewB(param: "Param 1")
      } label: {
        Text("Push view B with param 1")
      }

      Button {
        featBRouter.pushViewB(param: "Param 2")
      } label: {
        Text("Push view B with param 2")
      }

      Button {
        if featBRouter.isRoot {
          featBRouter.dismiss()
        } else {
          featBRouter.pop()
        }
      } label: {
        Text("Dismiss")
      }
    }
  }
}

#Preview {
  FeatBViewA()
}
