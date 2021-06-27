//
//  SessionStart.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 4/10/21.
//

import SwiftUI
import PythonKit

struct SessionStartView: View {
    @State var sessionName = ""
    var body: some View {
        VStack(spacing: 20) {
            TextField("Session Name:", text: $sessionName).textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                
                
                let sys = Python.import("sys")
                sys.path.append("\(Constants.cloudClipUserHomeDirectory)/CloudClipPython")
                let googleDriveFile = Python.import("googleDriveFile")
                googleDriveFile.startSession(sessionName)
                let id =  googleDriveFile.getSessionId(sessionName)
                let strId = (String(id)!)
                
                UserDefaults.standard.setValue(sessionName, forKey: "sessionNameTitle")
                UserDefaults.standard.setValue(true, forKey: "inSession")
                UserDefaults.standard.setValue(strId, forKey: "sessionID")
                
                
                let alert = NSAlert()
                alert.messageText = "Session Started!"
                alert.informativeText = "The '\(sessionName)' session has been started. Click 'End Session' in the menu bar to end it!"
                alert.icon = NSImage(named: "StartSession")
                alert.beginSheetModal(for: NSApp.keyWindow!) { _ in  NSApp.keyWindow?.close(); NSApp.keyWindow?.close() }
            }) {
                Text("Done")
            }
        }.padding().padding()
    }
}
