//  AnyEquatable.swift
//  Created by Nicolas FONTAINE

import Foundation

internal extension Equatable {
  func isEqual(_ other: any Equatable) -> Bool {
    guard let other = other as? Self else {
      return other.isExactlyEqual(self)
    }
    return self == other
  }
  
  private func isExactlyEqual(_ other: any Equatable) -> Bool {
    guard let other = other as? Self else {
      return false
    }
    return self == other
  }
}

internal enum AnyEquatable {
  internal static func areEqual(first: Any, second: Any) -> Bool {
    guard
      let firstEquatable = first as? any Equatable,
      let secondEquatable = second as? any Equatable
    else { return false }
    
    return firstEquatable.isEqual(secondEquatable)
  }
}


