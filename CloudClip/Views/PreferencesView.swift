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
            Button(action: {
                 logOut()
            }) {
                Text("Log Out")
            }.alert(isPresented: $successAlert) {
                Alert(title: Text("Successfully Logged Out"), message: Text("You have successfully logged out of your account. "), dismissButton: .default(Text("Great!")))
            }
            .alert(isPresented: $errorAlert) {
                Alert(title: Text("Error Logging Out"), message: Text("There was an error logging you out of your account."), dismissButton: .default(Text("Okay.")))
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
            print("Error")
        }
        else {
            self.successAlert = true
        }
    }
}
