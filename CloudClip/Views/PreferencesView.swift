//
//  PreferencesView.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 6/24/21.
//

import SwiftUI
import PythonKit

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
            VStack(alignment: .leading) {
                Button(action: {
                    self.logOut()
                }) {
                    Text("Log Out").frame(width: 200)
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
            let alert = NSAlert()
            alert.messageText = "Success!"
            alert.informativeText = "You have successfully logged out of your account!"
            alert.icon = NSImage(named: "Success")
            alert.beginSheetModal(for: NSApp.keyWindow!) { _ in }
        }
    }
}
