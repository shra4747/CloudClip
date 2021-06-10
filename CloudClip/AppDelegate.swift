//
//  AppDelegate.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 4/5/21.
//

import Cocoa
import SwiftUI
import KeyboardShortcuts
import PythonKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Import Python File to use
        let sys = Python.import("sys")
        sys.path.append("\(Constants.userHomeDirectory)Library/Application Support/CloudClip/CloudClipPython")
        let googleFile = Python.import("example")
        
        //Authenticate Google User
        googleFile.authenticate()
        googleFile.initializeRootClipDirectory()
        
        //Enable Menu Item
        MenuItemWorkflow().launchMenuItem()
        
        // Enable Shortcut to Launch Screenshot
        KeyboardShortcuts.onKeyUp(for: .screenShotRegion) {
            ScreenshotWorkflow().captureSpecificRegion(Any?.self)
        }

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
}

