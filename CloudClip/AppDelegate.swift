//
//  AppDelegate.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 4/5/21.
//

import Cocoa
import SwiftUI
import KeyboardShortcuts

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        if let button = statusItem.button {
          button.image = NSImage(named:NSImage.Name("status"))
        }
        
        let menu = NSMenu()

        let screenshotMenuItem = NSMenuItem()
        screenshotMenuItem.title = "Screenshot 📺"
        screenshotMenuItem.action = #selector(captureSpecificRegion(_:))
        screenshotMenuItem.setShortcut(for: .screenShotRegion)
        
        menu.addItem(screenshotMenuItem)
        
        statusItem.menu = menu
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Quit ☠️", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q"))
        
        KeyboardShortcuts.onKeyUp(for: .screenShotRegion) {
            self.captureSpecificRegion(Any?.self)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func captureSpecificRegion(_ sender: Any?) {
        let imageCode = Int.random(in: 100000..<999999)
        
        let home = FileManager.default.homeDirectoryForCurrentUser
        let locationPath = "Library/Application Support/CloudClip/\(imageCode).jpg"
        let filePath = home.appendingPathComponent(locationPath)
        
        
        var fileDestination = filePath

        let path = fileDestination.path as String

        let process = Process()
        process.launchPath = "/usr/sbin/screencapture"
        process.arguments = ["-i", path]
        process.launch()
        process.waitUntilExit()
        

        let image = LoadImage().loadImageFromFile(fileDestination: filePath)
        
        var fileName = ""
        ImageToText().textRecognition(image: image, completion: { text in
            fileName = text
        })

        var resourceValues = URLResourceValues()
        resourceValues.name = "\(fileName).jpg"
        try? fileDestination.setResourceValues(resourceValues)
    }
}

