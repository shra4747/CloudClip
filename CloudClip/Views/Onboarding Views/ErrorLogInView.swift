//
//  ErrorLogInView.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 6/27/21.
//

import SwiftUI

struct ErrorLogInView: View {
    var body: some View {
        ZStack {
            Rectangle().frame(width: 1000, height: 700).foregroundColor(.white)
            VStack(spacing: 18) {
                Image("enverror")
                Text("There was an error accessing your account. Please sign back in. ").font(.custom("Avenir Next", size: 35)).multilineTextAlignment(.center)
                Button(action: {
                    SwiftRunCommands().startup(function: "authenticate") { authenticationStatus in
                        if authenticationStatus == "0" || authenticationStatus.contains("successful") {
                            
                            SwiftRunCommands().startup(function: "initializeRootClipDirectory") { initializationStatus in
                                if initializationStatus == "0" {
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
                }) {
                    Image("siwg")
                }.buttonStyle(ScaleButtonStyle()).animation(.easeIn, value: true)
            }.frame(width: 1000, height: 700, alignment: .center)
        }
    }
}

struct ErrorLogInView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorLogInView()
    }
}
