//
//  Deriver.swift
//  Deriver
//
//  Created by Donnacha Oisín Kidney on 25/01/2016.
//  Copyright © 2016 Donnacha Oisín Kidney. All rights reserved.
//

public protocol DeriverType {
  func deriveWith(s: String, t: TypeRep) -> String
  var requirements: Set<FullRequirement> { get }
}

public struct EmptyDeriver: DeriverType {
  let deriving: String
  public var requirements: Set<FullRequirement> { return [] }
  public func deriveWith(s: String, t: TypeRep) -> String {
    return "extension " + t.name + ": " + deriving + " {\n" + s + "}"
  }
}

public struct Deriver<A,B,D: DeriverType>: DeriverType {
  let constraint: Requirement<A,B>
  let nextConstraint: D
  var frequire: FullRequirement {
    return FullRequirement(constraint.type,constraint.name)
  }
  public var requirements: Set<FullRequirement> {
    return nextConstraint.requirements.union([frequire])
  }
  public func deriveWith(s: String, t: TypeRep) -> String {
    let supports = { k in t.members[k]?.contains(self.frequire) ?? false }
    let derived = String(constraint.code(t.name, available: t.members.keys.filter(supports))) + "\n" + s
    return nextConstraint.deriveWith(derived, t: t)
  }
}

extension EmptyDeriver: StringLiteralConvertible {
  public init(extendedGraphemeClusterLiteral value: String) {
    deriving = value
  }
  public init(stringLiteral value: String) {
    deriving = value
  }
  public init(unicodeScalarLiteral value: String) {
    deriving = value
  }
}

func +<A,B,C,D,E>(lhs: Requirement<A,B>, rhs: Deriver<C,D,E>) -> Deriver<A, B, Deriver<C, D, E>> {
  return Deriver(constraint: lhs, nextConstraint: rhs)
}

func +<A,B,C,D,E>(lhs: Deriver<C,D,E>, rhs: Requirement<A,B>) -> Deriver<A, B, Deriver<C, D, E>> {
  return Deriver(constraint: rhs, nextConstraint: lhs)
}

infix operator | { associativity right precedence 90 }

func |<A,B>(lhs: Requirement<A,B>, rhs: EmptyDeriver) -> Deriver<A, B, EmptyDeriver> {
  return Deriver(constraint: lhs, nextConstraint: rhs)
}

func |<A,B>(lhs: EmptyDeriver, rhs: Requirement<A,B>) -> Deriver<A, B, EmptyDeriver> {
  return Deriver(constraint: rhs, nextConstraint: lhs)
}

extension DeriverType {
  func derive(t: TypeRep) -> String {
    return deriveWith("", t: t)
  }
}