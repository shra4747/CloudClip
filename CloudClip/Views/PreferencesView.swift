//
//  PreferencesView.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 6/24/21.
//

import SwiftUI

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
    
    @State var loggedInEmail = false
    @State var fontSize = 12.0

    var body: some View {
        Form {
            Toggle("Show Previews", isOn: $showPreview)
            Slider(value: $fontSize, in: 9...96) {
                Text("Font Size (\(fontSize, specifier: "%.0f") pts)")
            }
        }
        .padding(20)
        .frame(width: 350, height: 100)
    }
}
