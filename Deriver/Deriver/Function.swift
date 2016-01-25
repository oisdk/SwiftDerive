//
//  Function.swift
//  Deriver
//
//  Created by Donnacha Oisín Kidney on 25/01/2016.
//  Copyright © 2016 Donnacha Oisín Kidney. All rights reserved.
//

struct FunctionSignature<A,B> {
  let parameters: [(name: String?, type: String)]
  let name: String
  let type: RequirementType
  var call: String {
    switch type {
    case .Property, .StaticProperty, .Operator: return name
    case .Method, .StaticMethod:
      let paramList = zip(parameters, letters).map { (p,letter) in
        (p.name.map(+": ") ?? "") + letter
        }.joinWithSeparator(", ")
      return name + bracket(paramList)
    }
  }
  init(_ ps: ParamList, _ n: String, _ ty: RequirementType) {
    parameters = ps.contents
    name = n
    type = ty
  }
}


struct FunctionDeclaration<A,B>: CustomStringConvertible {
  let signature: FunctionSignature<A,B>
  let returnType: String
  let body: String
  var description: String {
    switch signature.type {
    case .Property, .StaticProperty:
      let pref = signature.type == RequirementType.Property ? "  " : "  static "
      return pref + [
        "var", signature.name + ":", returnType,
        "{\n    return", body, "  \n  }"
        ].joinWithSeparator(" ")
    case .Method, .StaticMethod, .Operator:
      let pref = signature.type == RequirementType.Method ? "  " : "  static "
      var onFirst = true
      let params = zip(signature.parameters, letters).map { (p, letter) in
        let pubName = p.name.map(+" ") ?? (onFirst ? "" : "_ ")
        onFirst = false
        return pubName + letter + ": " + p.type
        }.joinWithSeparator(", ")
      return pref + [
        "func", signature.name, bracket(params), "->", returnType,
        "{\n    return", body, "\n  }"
        ].joinWithSeparator(" ")
    
    }
  }
  var call: String { return signature.call }
  init(_ sg: FunctionSignature<A,B>, _ rt: String, _ bd: String) {
    signature = sg
    returnType = rt
    body = bd
  }
}

func bracket(s: String) -> String {
  return "(" + s + ")"
}