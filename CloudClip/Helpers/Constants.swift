//
//  Constants.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 4/5/21.
//

import KeyboardShortcuts
import Cocoa

extension KeyboardShortcuts.Name {
    static let screenShotRegion = Self("ssRegion", default: .init(.three, modifiers: [.command, .shift]))
}

class Constants {
    static let userHomeDirectory = "\(FileManager.default.homeDirectoryForCurrentUser)".replacingOccurrences(of: "file://", with: "")
}
