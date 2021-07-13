//
//  GetStaredView.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 7/13/21.
//

import SwiftUI

struct GetStaredView: View {
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle().frame(width: 1000, height: 700).foregroundColor(.white)
            VStack(spacing: 18) {
                Image("lighthouse")
                Text("Finished Setup!").font(.custom("Avenir Next Demi Bold", size: 50))
                Text("To grant this app permissions, clip this view (using Menu Bar or shortcut, command, shift, 3). Click Later if MacOS prompts ask you to quit this app. Once no more permussioons pop up, click quit and relaunch the app!").multilineTextAlignment(.center).font(.custom("Avenir Next", size: 22)).padding(25)
                
                Button(action: {
                    NSApp.terminate(Any.self)
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 40).frame(width: 330, height: 70).foregroundColor(.blue)
                        Text("Quit").font(.custom("Avenir Next", size: 34))
                    }
                }.buttonStyle(ScaleButtonStyle()).animation(.easeIn, value: true).shadow(radius: 10)
            }.frame(width: 1000, height: 700, alignment: .center)
        }
    }
}
