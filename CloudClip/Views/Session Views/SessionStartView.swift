//
//  SessionStart.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 4/10/21.
//

import SwiftUI

struct SessionStartView: View {
    @State var sessionName = ""
    var body: some View {
        VStack(spacing: 20) {
            TextField("Session Name:", text: $sessionName).textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                SwiftRunCommands().session(function: "startSession", sessionName: sessionName) { sessionState in
                    if sessionState == "1" {
                        // Show Error logging in view
                        NSApp.keyWindow?.close()
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
                    else {
                        SwiftRunCommands().session(function: "getSessionId", sessionName: sessionName) { id in
                            
                            if id == "1" {
                                // Show Error Logging In View
                                NSApp.keyWindow?.close()
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
                            else {
                                UserDefaults.standard.setValue(sessionName, forKey: "sessionNameTitle")
                                UserDefaults.standard.setValue(true, forKey: "inSession")
                                UserDefaults.standard.setValue(id, forKey: "sessionID")
                                
                                
                                let alert = NSAlert()
                                alert.messageText = "Session Started!"
                                alert.informativeText = "The '\(sessionName)' session has been started. Click 'End Session' in the menu bar to end it!"
                                alert.icon = NSImage(named: "StartSession")
                                alert.beginSheetModal(for: NSApp.keyWindow!) { _ in  NSApp.keyWindow?.close(); NSApp.keyWindow?.close() }
                            }
                        }
                        
                    }
                }
            }) {
                Text("Done")
            }
        }.padding().padding()
    }
}
