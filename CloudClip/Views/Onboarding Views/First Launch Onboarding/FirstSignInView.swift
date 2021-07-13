//
//  FirstSignInView.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 7/13/21.
//

import SwiftUI

struct FirstSignInView: View {
    @Binding var proceed: Int
    var body: some View {
        ZStack {
            Rectangle().frame(width: 1000, height: 700).foregroundColor(.white)
            VStack(spacing: 18) {
                Text("Sign in to Google").font(.custom("Avenir Next Demi Bold", size: 50))
                Image("lighthouse")
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
                                    alert.beginSheetModal(for: NSApp.keyWindow!) { _ in NSApp.keyWindow?.close(); proceed = 4}
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
