//
//  MenuItemWorkflow.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 6/9/21.
//

import Foundation
import Cocoa
import SwiftUI
import KeyboardShortcuts
import PythonKit

class MenuItemWorkflow {
    func launchMenuItem() {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem.button {
          button.image = NSImage(named:NSImage.Name("status"))
        }
        
        let menu = NSMenu()

        let screenshotMenuItem = NSMenuItem()
        screenshotMenuItem.title = "Screenshot 📺"
        screenshotMenuItem.action = #selector(ScreenshotWorkflow.captureSpecificRegion(_:))
        screenshotMenuItem.setShortcut(for: .screenShotRegion)
        
        menu.addItem(screenshotMenuItem)
        
        let startSessionItem = NSMenuItem()
        startSessionItem.title = "Start Session 🏁"
        startSessionItem.action = #selector(ScreenshotWorkflow.startSession(_:))
        menu.addItem(startSessionItem)
        
        let endSessionItem = NSMenuItem()
        endSessionItem.title = "End Session 🛑"
        endSessionItem.action = #selector(ScreenshotWorkflow.endSession(_:))
        menu.addItem(endSessionItem)
                
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Quit ☠️", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
}
