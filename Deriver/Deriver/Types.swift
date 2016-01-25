//
//  Types.swift
//  Deriver
//
//  Created by Donnacha Oisín Kidney on 25/01/2016.
//  Copyright © 2016 Donnacha Oisín Kidney. All rights reserved.
//

public struct TypeRep {
  let name: String
  let members: [String: Set<FullRequirement>]
}

public struct FullRequirement: Equatable, Hashable, CustomStringConvertible {
  let type: RequirementType
  let name: String
  public var hashValue: Int {
    return name.hashValue ^ type.hashValue
  }
  public var description: String {
    return name
  }
  public init(_ type: RequirementType, _ name: String) {
    (self.type, self.name) = (type, name)
  }
}

public func ==(lhs: FullRequirement, rhs: FullRequirement) -> Bool {
  return lhs.hashValue == rhs.hashValue
}