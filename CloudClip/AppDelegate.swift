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
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.variableLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        // Import Python File to use
        let sys = Python.import("sys")
        sys.path.append("\(Constants.cloudClipUserHomeDirectory)/CloudClipPython")
        let googleFile = Python.import("googleDriveFile")

        //Authenticate Google User
        googleFile.authenticate()
        googleFile.initializeRootClipDirectory()

        //Enable Menu Item
        statusItem.button?.image = NSImage(named:NSImage.Name("status"))
        self.initiateMenuItem()

        // Enable Shortcut to Launch Screenshot
        KeyboardShortcuts.onKeyUp(for: .screenShotRegion) {
            self.captureSpecificRegion(Any?.self)
        }
        
        var window: NSWindow!

        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 500),
            styleMask: [.closable, .titled, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.contentView = NSHostingView(rootView: PreferencesView())
        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(nil)
        window.orderFront(self)

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
    func initiateMenuItem() {
        let menu = NSMenu()

        let screenshotMenuItem = NSMenuItem()
        screenshotMenuItem.title = "Screenshot 📺"
        screenshotMenuItem.action = #selector(self.captureSpecificRegion(_:))
        screenshotMenuItem.setShortcut(for: .screenShotRegion)
        
        menu.addItem(screenshotMenuItem)
        
        let startSessionItem = NSMenuItem()
        startSessionItem.title = "Start Session 🏁"
        startSessionItem.action = #selector(self.startSession(_:))
        menu.addItem(startSessionItem)
        
        let endSessionItem = NSMenuItem()
        endSessionItem.title = "End Session 🛑"
        endSessionItem.action = #selector(self.endSession(_:))
        menu.addItem(endSessionItem)
                
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Quit ☠️", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
    @objc func startSession(_ sender: Any?) {
        UserDefaults.standard.setValue(true, forKey: "inSession")
        var window: NSWindow!

        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 500),
            styleMask: [.titled, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.contentView = NSHostingView(rootView: SessionStart())
        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(nil)
        window.orderFront(self)
        
        let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

        if let button = statusItem.button {
          button.image = NSImage(named:NSImage.Name("sessionStatus"))
        }
    }
    
    @objc func endSession(_ sender: Any?) {
        UserDefaults.standard.setValue(false, forKey: "inSession")
        
        let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
        
        if let button = statusItem.button {
          button.image = NSImage(named:NSImage.Name("status"))
        }
    }
    
    @objc func captureSpecificRegion(_ sender: Any?) {
        let imageCode = Int.random(in: 100000..<999999)
                
        let filePath = "\(Constants.cloudClipUserHomeDirectory)/\(imageCode).jpg"
        
        
        var fileDestination = URL(fileURLWithPath: filePath)
        let path = filePath
        let process = Process()
        process.launchPath = "/usr/sbin/screencapture"
        process.arguments = ["-i", path]
        process.launch()
        process.waitUntilExit()
        
        let image = LoadImage().loadImageFromFile(fileDestination: URL(fileURLWithPath: filePath))
        
        
        var fileName = ""
        
        ImageToText().textRecognition(image: image, completion: { text in
            fileName = text
        })
        
        if fileName.count == 0 {
            print("Returning and not uploading!")
            return
        }
        else {
            var resourceValues = URLResourceValues()
            resourceValues.name = "\(fileName).jpg"
            try? fileDestination.setResourceValues(resourceValues)
            
            
            let fl = "\(Constants.cloudClipUserHomeDirectory)/\(fileName).jpg"
            
            let sessionState = UserDefaults.standard.value(forKey: "inSession")
            
            if let inSession = sessionState as? Bool  {
                if inSession == true {
                    // In session
                    print("You are in a session.")
                    let id = UserDefaults.standard.value(forKey: "sessionID") as! String
                    let sys = Python.import("sys")
                    sys.path.append("\(Constants.cloudClipUserHomeDirectory)/CloudClipPython")
                    let googleDriveFile = Python.import("googleDriveFile")
                    googleDriveFile.uploadToSession("\(id)", fl, "\(fileName).jpg")
                }
                else {
                    // Not in session
                    print("You are not in a session.")
                    let sys = Python.import("sys")
                    sys.path.append("\(Constants.cloudClipUserHomeDirectory)/CloudClipPython")
                    let googleDriveFile = Python.import("googleDriveFile")
                    googleDriveFile.upload(fl, "\(fileName).jpg")
                }
            }
            else {
                print("Error loading session state. ")
                let sys = Python.import("sys")
                sys.path.append("\(Constants.cloudClipUserHomeDirectory)/CloudClipPython")
                let googleDriveFile = Python.import("googleDriveFile")
                googleDriveFile.upload(fl, "\(fileName).jpg")
            }
            
            try? FileManager().removeItem(atPath: fl)
        }
    }
}


