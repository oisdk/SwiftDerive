//
//  Utils.swift
//  Deriver
//
//  Created by Donnacha Oisín Kidney on 25/01/2016.
//  Copyright © 2016 Donnacha Oisín Kidney. All rights reserved.
//

public extension SequenceType {
  func reduce(@noescape combine: (Generator.Element, Generator.Element) -> Generator.Element) -> Generator.Element? {
    var result: Generator.Element?
    for element in self {
      if let accu = result {
        result = combine(accu,element)
      } else {
        result = element
      }
    }
    return result
  }
}

let letters = [
  "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n",
  "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
]

prefix operator + {}
prefix func +(s: String) -> String -> String { return { t in t + s } }

