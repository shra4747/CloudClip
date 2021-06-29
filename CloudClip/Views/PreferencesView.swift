//
//  PreferencesView.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 6/24/21.
//

import SwiftUI
import PythonKit
import KeyboardShortcuts

struct PreferencesView: View {
    var body: some View {
        TabView {
            GeneralSettingsView().tabItem {
                    Text("General")
            }
        }
        .padding(20)
        .frame(width: 375, height: 150)
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
        let sys = Python.import("sys")
        sys.path.append("\(Constants.cloudClipUserHomeDirectory)/CloudClipPython")
        let generalSettingsFile = Python.import("generalSettingsFile")
        generalSettingsFile.logOutGoogleAccount()
        
        let signedInState = (Bool(generalSettingsFile.checkLoggedStatus())!)
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
