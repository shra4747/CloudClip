//
//  AppDelegate.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 4/5/21.
//

import Cocoa
import SwiftUI
import SwiftyDropbox
import KeyboardShortcuts
import PythonKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let sys = Python.import("sys")
        sys.path.append("/Users/shravanp/CloudClipPython")
        let example = Python.import("example")
        example.authenticate()
        // Create the SwiftUI view that provides the window contents.
        
//        var window: NSWindow!
//
//        // Create the window and set the content view.
//        window = NSWindow(
//            contentRect: NSRect(x: 0, y: 0, width: 1000, height: 1000),
//            styleMask: [.titled, .closable, .fullSizeContentView],
//            backing: .buffered, defer: false)
//
//
//        window.isReleasedWhenClosed = false
//        window.center()
//        window.contentView = NSHostingView(rootView: SessionView())
//        NSApp.activate(ignoringOtherApps: true)
//        window.makeKeyAndOrderFront(nil)
//        window.orderFront(self)
        
        
        
        
        if let button = statusItem.button {
          button.image = NSImage(named:NSImage.Name("status"))
        }
        
        let menu = NSMenu()

        let screenshotMenuItem = NSMenuItem()
        screenshotMenuItem.title = "Screenshot 📺"
        screenshotMenuItem.action = #selector(AppDelegate.captureSpecificRegion(_:))
        screenshotMenuItem.setShortcut(for: .screenShotRegion)
        
        menu.addItem(screenshotMenuItem)
        
        statusItem.menu = menu
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Quit ☠️", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q"))
        
        KeyboardShortcuts.onKeyUp(for: .screenShotRegion) {
            self.captureSpecificRegion(Any?.self)
        }
        
//        DropboxClientsManager.setupWithAppKeyDesktop("jbzmsjufj2ntft3")
//        BoxSignIn().authorize()
//        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(BoxSignIn().handleGetURLEvent), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))

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
        
        
        let sys = Python.import("sys")
        sys.path.append("/Users/shravanp/CloudClipPython")
        let example = Python.import("example")
        example.upload(String("/Users/shravanp/Library/Application Support/CloudClip/\(fileName).jpg").replacingOccurrences(of: "file://", with: "").replacingOccurrences(of: "%20", with: " "), "\(fileName).jpg")
        
        
    }
}

