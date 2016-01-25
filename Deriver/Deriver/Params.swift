//
//  Params.swift
//  Deriver
//
//  Created by Donnacha Oisín Kidney on 25/01/2016.
//  Copyright © 2016 Donnacha Oisín Kidney. All rights reserved.
//

protocol _Owner {}
struct Owner: _Owner {}

protocol _Unit {}
struct Unit: _Unit {}

struct Namer<A> {
  let selfName: String
  typealias MightBeOwner = A
  init(_ s: String) { selfName = s }
  var name: String { return Owner() is A ? selfName : String(A.self) }
}

func params<A>(a: String?) -> (selfTypeName: String, types: A.Type) -> ParamList {
  func f(stn: String, types: A.Type) -> ParamList {
    return ParamList([(a, Namer<A>(stn).name)])
  }
  return f
}

func params<A,B>(a: String?, _ b: String?) -> (selfTypeName: String, types: (A,B).Type) -> ParamList {
  func f(stn: String, types: (A,B).Type) -> ParamList {
    return ParamList([
      (name: a, type: Namer<A>(stn).name),
      (name: b, type: Namer<B>(stn).name),
    ])
  }
  return f
}

func params<A,B,C>(a: String?, _ b: String?, _ c: String?) -> (selfTypeName: String, (A,B,C).Type) -> ParamList {
  func f(stn: String, types: (A,B,C).Type) -> ParamList {
    let prs = ParamList([
      (name: a, type: Namer<A>(stn).name),
      (name: b, type: Namer<B>(stn).name),
      (name: c, type: Namer<C>(stn).name),
    ])
    return prs
  }
  return f
}

func params<A,B,C,D>(a: String?, _ b: String?, _ c: String?, _ d: String?) -> (selfTypeName: String, (A,B,C,D).Type) -> ParamList {
  func f(stn: String, types: (A,B,C,D).Type) -> ParamList {
    return ParamList([
      (name: a, type: Namer<A>(stn).name),
      (name: b, type: Namer<B>(stn).name),
      (name: c, type: Namer<C>(stn).name),
      (name: d, type: Namer<D>(stn).name),
    ])
  }
  return f
}

public struct ParamList {
  let contents: [(name: String?, type: String)]
  internal init(_ c: [(name: String?, type: String)]) { contents = c }
}
