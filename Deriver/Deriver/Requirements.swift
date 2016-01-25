//
//  Requirements.swift
//  Deriver
//
//  Created by Donnacha Oisín Kidney on 25/01/2016.
//  Copyright © 2016 Donnacha Oisín Kidney. All rights reserved.
//

public enum Combiner<A> { case BinOp(String), Func(String) }
internal extension Combiner {
  func combine(a: String, b: String) -> String {
    switch self {
    case let .BinOp(s): return "(" + a + ") " + s + " (" + b + ")"
    case let .Func(s): return s + "(" + a + ", " + b + ")"
    }
  }
}

public let and     = Combiner<Bool>.BinOp("&&")
public let or      = Combiner<Bool>.BinOp("||")
public let sum     = Combiner<Int>.BinOp("+")
public let product = Combiner<Int>.BinOp("*")
public let xor     = Combiner<Int>.BinOp("^")

public enum Form<A> { case Total(Combiner<A>), Minimal }

// Property, static property, method, static method, operator

public enum RequirementType : Equatable {
  case Property
  case Method
  case Operator
  case StaticMethod
  case StaticProperty
}

public struct Requirement<A,B> {
  let name: String
  let type: RequirementType
  let form: Form<B>
  let pram: (String, A.Type) -> ParamList
}

extension Requirement {
  var frequire: FullRequirement {
    return FullRequirement(type,name)
  }
}

public struct Hider { private init() {} }

public protocol _Requirement {
  typealias From
  typealias To
  init(h: Hider, name: String, type: RequirementType, form: Form<To>, pram: (String, From.Type) -> ParamList)
}

extension Requirement: _Requirement {
  public typealias From = A
  public typealias To = B
  public init(h: Hider, name: String, type: RequirementType, form: Form<To>, pram: (String, From.Type) -> ParamList) {
    self.name = name
    self.type = type
    self.form = form
    self.pram = pram
  }
}

extension Requirement {
  init(method: String, pram: (String, From.Type) -> ParamList, form: Form<To> = .Minimal) {
    name = method
    self.pram = pram
    self.form = form
    type = .Method
  }
}

extension _Requirement where From == Owner {
  init(property: String, form: Form<To> = .Minimal) {
    self.init(
      h: Hider(),
      name: property,
      type: RequirementType.Property,
      form: form,
      pram: { _ in ParamList([]) }
    )
  }
}

extension _Requirement where From == Void {
  init(staticProperty: String, form: Form<To> = .Minimal) {
    self.init(
      h: Hider(),
      name: staticProperty,
      type: RequirementType.StaticProperty,
      form: form,
      pram: { _ in ParamList([]) }
    )
  }
  init(staticMethod: String, params: (String, From.Type) -> ParamList, form: Form<To> = .Minimal) {
    self.init(
      h: Hider(),
      name: staticMethod,
      type: RequirementType.StaticMethod,
      form: form,
      pram: params
    )
  }
}

extension _Requirement where From == (Owner, Owner) {
  init(binaryOp: String, params: (String, From.Type) -> ParamList, form: Form<To> = .Minimal) {
    self.init(
      h: Hider(),
      name: binaryOp,
      type: RequirementType.Operator,
      form: form,
      pram: params
    )
  }
}

