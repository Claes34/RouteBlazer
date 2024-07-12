//  Routable.swift
//  Created by Nicolas FONTAINE

import Foundation

public protocol Routable: Hashable, Identifiable, Equatable where ID == AnyHashable {}

extension Routable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
