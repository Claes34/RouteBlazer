import SwiftUI

protocol FeatAViewBNavDelegate {
  func didPressPushToFeatB()
  func didPressPresentFeatB()
  func didPressPresentSheetFeatB()
}

struct FeatAViewB {
  var navDelegate: FeatAViewBNavDelegate?
}

extension FeatAViewB: View {
  var body: some View {
    VStack(spacing: 24) {
      Text("Feat A View B")
        .font(.title)

      Button {
        navDelegate?.didPressPushToFeatB()
      } label: {
        Text("Push feat B router")
      }

      Button {
        navDelegate?.didPressPresentFeatB()
      } label: {
        Text("Present fullscreen feat B router")
      }

      Button {
        navDelegate?.didPressPresentSheetFeatB()
      } label: {
        Text("Present sheet feat B router")
      }
    }
  }
}


#Preview {
  FeatAViewB()
}
