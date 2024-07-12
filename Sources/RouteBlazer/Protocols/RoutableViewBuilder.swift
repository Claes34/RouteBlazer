//  RoutableViewBuilder.swift
//  Created by Nicolas FONTAINE

import SwiftUI

public protocol RoutableViewBuilder: AnyObject {
  associatedtype ProvidedView: View

  func buildView(route: any Routable) -> ProvidedView
}
