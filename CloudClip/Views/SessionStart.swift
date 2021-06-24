//
//  SessionStart.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 4/10/21.
//

import SwiftUI
import PythonKit

struct SessionStart: View {
    @State var sessionName = ""
    var body: some View {
        VStack(spacing: 20) {
            TextField("Session Name:", text: $sessionName).textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                NSApp.keyWindow?.close()
                NSApp.keyWindow?.close()
                let sys = Python.import("sys")
                sys.path.append("/Users/shravanp/CloudClipPython")
                let example = Python.import("example")
                example.startSession(sessionName)
                let id =  example.getSessionId(sessionName)
                let strId = (String(id)!)
                UserDefaults.standard.setValue(true, forKey: "inSession")
                UserDefaults.standard.setValue(strId, forKey: "sessionID")
            }) {
                Text("Done")
            }
        }.padding().padding()
    }
}
