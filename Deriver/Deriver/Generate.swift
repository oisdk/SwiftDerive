//
//  Generate.swift
//  Deriver
//
//  Created by Donnacha Oisín Kidney on 25/01/2016.
//  Copyright © 2016 Donnacha Oisín Kidney. All rights reserved.
//

// static property, method, static method

extension Requirement {
  // FuncName
  func code(selfTypeName: String, available: [String]) -> FunctionDeclaration<A,B> {
    switch type {
    case .Operator:
      let body: String
      switch form {
      case .Minimal:
        let firstProp = available.first!
        body = "a." + firstProp + " " + name + " " + "b." + firstProp
      case let .Total(c):
        body = available
          .map { n in "a." + n + " " + name + " " + "b." + n }
          .reduce(c.combine)!
      }
      let plist = pram(selfTypeName, A.self)
      let sig = FunctionSignature<A,B>(plist, name, self.type)
      return FunctionDeclaration(sig, String(B.self), body)
    case .Property:
      let sig = FunctionSignature<A,B>(ParamList([]), name, .Property)
      let body: String
      switch form {
      case .Minimal: body = "self." + available.first! + "." + sig.call
      case .Total(let c): body = available
        .map { n in "self." + n + "." + sig.call }
        .reduce(c.combine)!
      }
      return FunctionDeclaration(sig, String(B.self), body)
    case .Method:
      let plist = pram(selfTypeName, A.self)
      let sig = FunctionSignature<A,B>(plist, name, .Method)
      let body: String
      switch form {
      case .Minimal:
        body = "self." + available.first! + "." + sig.call
      case let .Total(c):
        body = available
          .map { n in "self." + n + "." + sig.call }
          .reduce(c.combine)!
      }
      return FunctionDeclaration(sig, String(B.self), body)
    default: fatalError()
    }
  }
}