import SwiftUI

protocol FeatAViewANavDelegate {
  func didPressPushToB()
}

struct FeatAViewA {
  var navDelegate: FeatAViewANavDelegate?
}

extension FeatAViewA: View {
  var body: some View {
    VStack(spacing: 24) {
      Text("Feat A View A")
        .font(.title)

      Button {
        navDelegate?.didPressPushToB()
      } label: {
        Text("Push to feat A view B")
      }
    }
  }
}

#Preview {
  FeatAViewA()
}
