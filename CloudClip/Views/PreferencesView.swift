//
//  PreferencesView.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 6/24/21.
//

import SwiftUI
import KeyboardShortcuts

struct PreferencesView: View {
    var body: some View {
        TabView {
            GeneralSettingsView().tabItem {
                Text("General")
            }
            AdvancedSettingsView().tabItem{
                Text("Advanced")
            }
        }
        .padding(20)
        .frame(width: 375, height: 150)
    }
}

struct AdvancedSettingsView: View {
    var body: some View {
        Form {
            VStack(alignment: .center) {
                
                Button(action: {
                    UserDefaults.standard.setValue(false, forKey: "userHasLaunchedApp")
                    SwiftRunCommands().generalSettings(function: "logOutGoogleAccount", completion: { _ in })
                    NSApp.keyWindow?.close()
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
                }) {
                    Text("Reset App").frame(width: 200)
                }
                
                HStack {
                    Button(action: {
                        SwiftRunCommands().installPyDrive { result in
                            if result.success {
                                let alert = NSAlert()
                                alert.messageText = "Success!"
                                alert.informativeText = "Successfully Installed PyDrive"
                                alert.icon = NSImage(named: "Success")
                                alert.beginSheetModal(for: NSApp.keyWindow!) { _ in NSApp.keyWindow?.close() }
                            }
                            else {
                                let alert = NSAlert()
                                alert.messageText = "Error!"
                                alert.informativeText = "Error Installing PyDrive"
                                alert.icon = NSImage(named: "Error")
                                alert.beginSheetModal(for: NSApp.keyWindow!) { _ in NSApp.keyWindow?.close() }
                            }
                        }
                    }) {
                        Text("Install PyDrive").frame(width: 200)
                    }
                }
                
                HStack {
                    Button(action: {
                        NSWorkspace().openFile("/Library/Application Support/CloudClipPython/python-3.9.6-macos11.pkg", withApplication: "Installer")
                    }) {
                        Text("Install Python").frame(width: 200)
                    }
                }
                   
            }
        }
        .padding(20)
        .frame(width: 350, height: 100)
    }
}

struct GeneralSettingsView: View {
    
    @State var successAlert = false
    @State var errorAlert = false
    
    var body: some View {
        Form {
            VStack(alignment: .center) {
                HStack {
                    Text("Screenshot Shortcut")
                    KeyboardShortcuts.Recorder(for: .screenShotRegion)
                }
                
                Button(action: {
                    self.logOut()
                }) {
                    Text("Log Out").frame(width: 200)
                }
                
                Button(action: {
                    SoundEffects().playSound(effectType: .clipped)
                }) {
                    Text("Play Sound")
                }
            }
        }
        .padding(20)
        .frame(width: 350, height: 100)
    }
    
    func logOut() {
        SwiftRunCommands().generalSettings(function: "logOutGoogleAccount", completion: { _ in })
        
        SwiftRunCommands().generalSettings(function: "checkLoggedStatus") { signedInState in
            if signedInState {
                let alert = NSAlert()
                alert.messageText = "Error!"
                alert.informativeText = "There was an error logging out of your account."
                alert.icon = NSImage(named: "Error")
                alert.beginSheetModal(for: NSApp.keyWindow!) { _ in }
            }
            else {
                UserDefaults.standard.setValue(false, forKey: "userLoggedIn")
                let alert = NSAlert()
                alert.messageText = "Success!"
                alert.informativeText = "You have successfully logged out of your account!"
                alert.icon = NSImage(named: "Success")
                alert.beginSheetModal(for: NSApp.keyWindow!) { _ in
                    
                    NSApp.keyWindow?.close()
                    NSApp.keyWindow?.close()
                    
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
                }
            }
        }
    }
}
