//
//  main.swift
//  Deriver
//
//  Created by Donnacha Oisín Kidney on 25/01/2016.
//  Copyright © 2016 Donnacha Oisín Kidney. All rights reserved.
//

let has_eq = Requirement<(Owner,Owner),Bool>(binaryOp: "==", params: params(nil,nil), form: .Total(and))
let has_cmp = Requirement<(Owner,Owner),Bool>(binaryOp: "<", params: params(nil,nil))
let has_hash = Requirement<Owner,Int>(property: "hashValue", form: .Total(xor))

let eq = "Equatable"   | has_eq
let cmp = "Equatabe, Comparable" | has_eq + has_cmp
let hash = "Equatabe, Comparable, Hashable"  | has_eq + has_cmp + has_hash

struct SomeNumber {
  let integer: Int
  let double: Double
  let bool: Bool
  let string: String
}

let has_desc = Requirement<Owner,String>(property: "description")

let desc = "CustomDebugStringConvertible" | has_desc

let t = TypeRep(name: "MyType", members: [
  "integer": hash.requirements,
  "double": hash.requirements,
  "bool": hash.requirements,
  "string": hash.requirements.union(desc.requirements)
  ])

print(hash.derive(t))
print(desc.derive(t))