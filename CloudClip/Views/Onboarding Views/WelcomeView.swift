//
//  WelcomeView.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 6/27/21.
//

import SwiftUI
import PythonKit

struct WelcomeView: View {
    var body: some View {
        ZStack {
            Rectangle().frame(width: 1000, height: 700).foregroundColor(.white)
            VStack(spacing: 18) {
                Image("lighthouse")
                Text("Welcome to CloudClip!").font(.custom("Avenir Next Demi Bold", size: 50))
                Button(action: {
                    let sys = Python.import("sys")
                    sys.path.append("\(Constants.cloudClipUserHomeDirectory)/CloudClipPython")
                    let googleFile = Python.import("googleDriveFile")
                    
                    //Authenticate Google User
                    let authenticated = "\(googleFile.authenticate())"
                    
                    if authenticated == "0" {
                        let initialized = "\(googleFile.initializeRootClipDirectory())"
                        
                        if initialized == "0" {
                            // Proceed
                            UserDefaults.standard.setValue(true, forKey: "userLoggedIn")
                            NSApp.activate(ignoringOtherApps: true)
                            let alert = NSAlert()
                            alert.messageText = "Success!"
                            alert.informativeText = "You have successfully logged into your account!"
                            alert.icon = NSImage(named: "Success")
                            alert.beginSheetModal(for: NSApp.keyWindow!) { _ in NSApp.keyWindow?.close(); NSApp.keyWindow?.close()}
                        }
                        else {
                            // Error
                            let alert = NSAlert()
                            alert.messageText = "Error!"
                            alert.informativeText = "There was an error logging into your account. The app will quit, please relaunch it."
                            alert.icon = NSImage(named: "Error")
                            alert.beginSheetModal(for: NSApp.keyWindow!) { _ in  NSApp.terminate(Any.self)}
                        }
                    }
                    
                }) {
                    Image("siwg")
                }.buttonStyle(ScaleButtonStyle()).animation(.easeIn, value: true)
            }.frame(width: 1000, height: 700, alignment: .center)
        }
    }
}


struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
    }
}
