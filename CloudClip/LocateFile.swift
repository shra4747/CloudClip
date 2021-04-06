//
//  LocateFile.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 4/5/21.
//

import SwiftUI
import Foundation
import Cocoa

struct LoadImage {
    public func loadImageFromFile(fileDestination: URL) -> NSImage {
        do {
            let imageData = try Data(contentsOf: fileDestination)
            return NSImage(data: imageData) ?? NSImage()
        } catch {
            print("Error loading image : \(error)")
        }
        return NSImage()
    }
}

