//
//  RandomExtension.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 6/27/21.
//

import Foundation

class RandomAlphanumeric {
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
