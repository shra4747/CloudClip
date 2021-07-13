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
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.variableLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        guard let userHasLaunchedApp = UserDefaults.standard.value(forKey: "userHasLaunchedApp") as? Bool else {
            // Never Launched App
            var window: NSWindow!

            window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 1000, height: 700),
                styleMask: [.closable, .titled, .fullSizeContentView, .miniaturizable, .resizable],
                backing: .buffered, defer: false)
            window.isReleasedWhenClosed = false
            window.center()
            window.title = "Welcome to CloudClip!"
            window.contentView = NSHostingView(rootView: FirstLaunchedView())
            window.makeKeyAndOrderFront(true)
            window.orderFront(true)
            NSApp.activate(ignoringOtherApps: true)
            
            self.statusItem.button?.image = NSImage(named:NSImage.Name("status"))
            self.initiateMenuItem()

            // Enable Shortcut to Launch Screenshot
            KeyboardShortcuts.onKeyUp(for: .screenShotRegion) {
                self.captureSpecificRegion(Any?.self)
            }
            return
        }
        
        if userHasLaunchedApp {
            // User Launched App, so Passing
        }
        else {
            // User Has Never Launched App (might have also reset app)
            var window: NSWindow!

            window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 1000, height: 700),
                styleMask: [.closable, .titled, .fullSizeContentView, .miniaturizable, .resizable],
                backing: .buffered, defer: false)
            window.isReleasedWhenClosed = false
            window.center()
            window.title = "Welcome to CloudClip!"
            window.contentView = NSHostingView(rootView: FirstLaunchedView())
            window.makeKeyAndOrderFront(true)
            window.orderFront(true)
            NSApp.activate(ignoringOtherApps: true)
            
            self.statusItem.button?.image = NSImage(named:NSImage.Name("status"))
            self.initiateMenuItem()

            // Enable Shortcut to Launch Screenshot
            KeyboardShortcuts.onKeyUp(for: .screenShotRegion) {
                self.captureSpecificRegion(Any?.self)
            }
            return
        }

        guard let signedInState = UserDefaults.standard.value(forKey: "userLoggedIn") as? Bool else {
            // User Has Launched App, but Error Getting Logged in State
            var window: NSWindow!

            window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 1000, height: 700),
                styleMask: [.closable, .titled, .fullSizeContentView, .miniaturizable, .resizable],
                backing: .buffered, defer: false)
            window.isReleasedWhenClosed = false
            window.center()
            window.title = "Error Logging In!"
            window.contentView = NSHostingView(rootView: ErrorLogInView())
            window.makeKeyAndOrderFront(true)
            window.orderFront(true)
            NSApp.activate(ignoringOtherApps: true)
            
            self.statusItem.button?.image = NSImage(named:NSImage.Name("status"))
            self.initiateMenuItem()

            // Enable Shortcut to Launch Screenshot
            KeyboardShortcuts.onKeyUp(for: .screenShotRegion) {
                self.captureSpecificRegion(Any?.self)
            }
            
            return
        }
        if signedInState == true {
            // User has Launched and Signed in
            SwiftRunCommands().startup(function: "authenticate") { authenticationStatus in
                if authenticationStatus == "0" || authenticationStatus.contains("successful") {

                    SwiftRunCommands().startup(function: "initializeRootClipDirectory") { initializationStatus in
                        if initializationStatus == "0" {
                            // Proceed
                            UserDefaults.standard.setValue(true, forKey: "userLoggedIn")
                            //Enable Menu Item
                            self.statusItem.button?.image = NSImage(named:NSImage.Name("status"))
                            self.initiateMenuItem()

                            // Enable Shortcut to Launch Screenshot
                            KeyboardShortcuts.onKeyUp(for: .screenShotRegion) {
                                self.captureSpecificRegion(Any?.self)
                            }
                        }
                        else {
                            // Error
                            UserDefaults.standard.setValue(false, forKey: "userLoggedIn")
                            let alert = NSAlert()
                            alert.messageText = "Error!"
                            alert.informativeText = "There was an error logging into your account. The app will quit, please relaunch it."
                            alert.icon = NSImage(named: "Error")
                            alert.beginSheetModal(for: NSApp.keyWindow!) { _ in  NSApp.terminate(Any.self)}
                        }
                    }
                }
                else {
                    fatalError("Error Logging In")
                }
            }
        }
        else {
            // User has Launched but Never signed in
            var window: NSWindow!

            window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 1000, height: 700),
                styleMask: [.closable, .titled, .fullSizeContentView, .miniaturizable, .resizable],
                backing: .buffered, defer: false)
            window.isReleasedWhenClosed = false
            window.center()
            window.title = "Welcome!"
            window.contentView = NSHostingView(rootView: WelcomeView())
            window.makeKeyAndOrderFront(true)
            window.orderFront(true)
            NSApp.activate(ignoringOtherApps: true)

            statusItem.button?.image = NSImage(named:NSImage.Name("status"))
            self.initiateMenuItem()

            // Enable Shortcut to Launch Screenshot
            KeyboardShortcuts.onKeyUp(for: .screenShotRegion) {
                self.captureSpecificRegion(Any?.self)
            }
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        UserDefaults.standard.setValue(false, forKey: "inSession")
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
        
        let restoreItem = NSMenuItem()
        restoreItem.title = "Restore Session 🔁"
        restoreItem.action = #selector(self.restoreSession(_:))
        menu.addItem(restoreItem)
        
        let clipsItem = NSMenuItem()
        clipsItem.title = "All Clips 🚀"
        clipsItem.action = #selector(self.openAllClips(_:))
        menu.addItem(clipsItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let preferencesItem = NSMenuItem()
        preferencesItem.title = "Preferences ⌛️"
        preferencesItem.action = #selector(self.openPreferences(_:))
        menu.addItem(preferencesItem)
        
        menu.addItem(NSMenuItem(title: "Quit ☠️", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
    @objc func openAllClips(_ sender: Any?) {
        var window: NSWindow!

        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 750, height: 600),
            styleMask: [.closable, .titled, .fullSizeContentView, .miniaturizable, .resizable],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.title = "All Clips 🚀"
        window.contentView = NSHostingView(rootView: SessionView())
        window.makeKeyAndOrderFront(true)
        window.orderFront(true)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func openPreferences(_ sender: Any?) {
        var window: NSWindow!

        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 750, height: 600),
            styleMask: [.closable, .titled, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.title = "Preferences ⌛️"
        window.contentView = NSHostingView(rootView: PreferencesView())
        window.makeKeyAndOrderFront(true)
        window.orderFront(true)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func startSession(_ sender: Any?) {
        UserDefaults.standard.setValue(true, forKey: "inSession")
        var window: NSWindow!

        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 500),
            styleMask: [.titled, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.title = "Start Session"
        window.center()
        window.contentView = NSHostingView(rootView: SessionStartView())
        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(nil)
        window.orderFront(self)
        
        if let button = statusItem.button {
          button.image = NSImage(named:NSImage.Name("sessionStatus"))
        }
    }
    
    @objc func endSession(_ sender: Any?) {
        UserDefaults.standard.setValue(false, forKey: "inSession")
                
        if let button = statusItem.button {
          button.image = NSImage(named:NSImage.Name("status"))
        }
        
//        guard let sessionName = UserDefaults.standard.value(forKey: "sessionNameTitle") else {
//            return
//        }
        

//        let alert = NSAlert()
//        alert.messageText = "Session Ended!"
//        alert.informativeText = "The '\(sessionName)' session has ended!"
//        alert.icon = NSImage(named: "EndSession")
//        alert.beginSheetModal(for: NSApp.keyWindow!) { _ in }
    }
    
    @objc func restoreSession(_ sender: Any?) {
        var window: NSWindow!

        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 800),
            styleMask: [.titled, .fullSizeContentView, .closable],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.title = "Choose which session to Restore! 🔁"
        window.center()
        window.contentView = NSHostingView(rootView: SessionRestoreView())
        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(nil)
        window.orderFront(self)
        
        if let button = statusItem.button {
          button.image = NSImage(named:NSImage.Name("sessionStatus"))
        }
    }
    
    @objc func captureSpecificRegion(_ sender: Any?) {
            let imageCode = "\(RandomAlphanumeric().randomString(length: 20))"
                    
            let filePath = "/Library/Application Support/CloudClipPython/\(imageCode).jpg"
            
            
            var fileDestination = URL(fileURLWithPath: filePath)
            let path = filePath
            let process = Process()
            process.launchPath = "/usr/sbin/screencapture"
            process.arguments = ["-i", path]
            process.launch()
            process.waitUntilExit()
            
            
            let image = LoadImage().loadImageFromFile(fileDestination: URL(fileURLWithPath: filePath))

            SoundEffects().playSound(effectType: .clipped)
            
            var fileName = ""
            
            ImageToText().textRecognition(image: image, completion: { text in
                fileName = text.replacingOccurrences(of: "/", with: "-")
            })
        
        
            
            
            if fileName.count == 0 {
                fatalError()
            }
            else {
                var resourceValues = URLResourceValues()
                resourceValues.name = "\(fileName).jpg"
                try? fileDestination.setResourceValues(resourceValues)
                
                
                let fl = "/Library/Application Support/CloudClipPython/\(fileName).jpg"

                let sessionState = UserDefaults.standard.value(forKey: "inSession")
                
                if let inSession = sessionState as? Bool  {
                    if inSession == true {
                        // In session
                        print("You are in a session.")
                        let id = UserDefaults.standard.value(forKey: "sessionID") as! String
                        
                        SwiftRunCommands().uploadToSession(sessionID: id, fileLocation: fl, fileName: "\(fileName).jpg") { uploadState in
                            if uploadState == "1" {
                                // Show Error Logging in View
                                var window: NSWindow!

                                window = NSWindow(
                                    contentRect: NSRect(x: 0, y: 0, width: 1000, height: 700),
                                    styleMask: [.closable, .titled, .fullSizeContentView, .miniaturizable, .resizable],
                                    backing: .buffered, defer: false)
                                window.isReleasedWhenClosed = false
                                window.center()
                                window.title = "Error Logging In"
                                window.contentView = NSHostingView(rootView: ErrorLogInView())
                                window.makeKeyAndOrderFront(true)
                                window.orderFront(true)
                                NSApp.activate(ignoringOtherApps: true)
                            }
                        }
                    }
                    else {
                        // Not in session
                        print("You are not in a session.")
                        
                        SwiftRunCommands().upload(fileLocation: fl, fileName: "\(fileName).jpg") { uploadState in
                            if uploadState == "1" {
                                //Show Error Logging In View
                                var window: NSWindow!

                                window = NSWindow(
                                    contentRect: NSRect(x: 0, y: 0, width: 1000, height: 700),
                                    styleMask: [.closable, .titled, .fullSizeContentView, .miniaturizable, .resizable],
                                    backing: .buffered, defer: false)
                                window.isReleasedWhenClosed = false
                                window.center()
                                window.title = "Error Logging In"
                                window.contentView = NSHostingView(rootView: ErrorLogInView())
                                window.makeKeyAndOrderFront(true)
                                window.orderFront(true)
                                NSApp.activate(ignoringOtherApps: true)
                            }
                        }
                    }
                }
                else {
                    print("Error loading session state. ")
                    
                    SwiftRunCommands().upload(fileLocation: fl, fileName: "\(fileName).jpg") { uploadState in
                        if uploadState == "1" {
                            //Show Error Logging In View
                            var window: NSWindow!

                            window = NSWindow(
                                contentRect: NSRect(x: 0, y: 0, width: 1000, height: 700),
                                styleMask: [.closable, .titled, .fullSizeContentView, .miniaturizable, .resizable],
                                backing: .buffered, defer: false)
                            window.isReleasedWhenClosed = false
                            window.center()
                            window.title = "Error Logging In"
                            window.contentView = NSHostingView(rootView: ErrorLogInView())
                            window.makeKeyAndOrderFront(true)
                            window.orderFront(true)
                            NSApp.activate(ignoringOtherApps: true)
                        }
                    }
                }
                
                try? FileManager().removeItem(atPath: fl)
            
        }
    }
}
