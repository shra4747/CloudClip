//
//  ScreenshotWorkflow.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 6/9/21.
//

import Foundation
import Cocoa
import SwiftUI
import KeyboardShortcuts
import PythonKit

class ScreenshotWorkflow {
    
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
        
        let filePath = "\(Constants.userHomeDirectory)Library/Application Support/CloudClip/\(imageCode).jpg"
        
        
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
            print("Returning an not uploading!")
            return
        }
        else {
            var resourceValues = URLResourceValues()
            resourceValues.name = "\(fileName).jpg"
            try? fileDestination.setResourceValues(resourceValues)
            
            let fl = "\(Constants.userHomeDirectory)Library/Application Support/CloudClip/\(fileName).jpg"
            
            let sessionState = UserDefaults.standard.value(forKey: "inSession")
            
            if let inSession = sessionState as? Bool  {
                if inSession == true {
                    // In session
                    print("You are in a session.")
                    let id = UserDefaults.standard.value(forKey: "sessionID") as! String
                    let sys = Python.import("sys")
                    sys.path.append("\(Constants.userHomeDirectory)Library/Application Support/CloudClip/CloudClipPython")
                    let example = Python.import("example")
                    example.uploadToSession("\(id)", fl, "\(fileName).jpg")
                }
                else {
                    // Not in session
                    print("You are not in a session.")
                    let sys = Python.import("sys")
                    sys.path.append("\(Constants.userHomeDirectory)Library/Application Support/CloudClip/CloudClipPython")
                    let example = Python.import("example")
                    example.upload(fl, "\(fileName).jpg")
                }
            }
            else {
                print("Error loading session state. ")
                let sys = Python.import("sys")
                sys.path.append("\(Constants.userHomeDirectory)Library/Application Support/CloudClip/CloudClipPython")
                let example = Python.import("example")
                example.upload(fl, "\(fileName).jpg")
            }
        }
    }
}
