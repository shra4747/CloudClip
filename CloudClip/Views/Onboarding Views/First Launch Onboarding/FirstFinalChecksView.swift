//
//  FirstFinalChecksView.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 7/13/21.
//

import SwiftUI

struct FirstFinalChecksView: View {
    
    @Binding var proceed: Int
    @State var progressValue: Float = 0.0
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle().frame(width: 1000, height: 700).foregroundColor(.white)
            VStack(spacing: 18) {
                Image("lighthouse")
                Text("Run Housekeeping Checks").font(.custom("Avenir Next Demi Bold", size: 50))
                ProgressBar(value: $progressValue).frame(width: 500, height: 20)
                if progressValue != 1 {
                    Button(action: {
                        progressValue = 0.15
                        SwiftRunCommands().startup(function: "authenticate") { authenticationStatus in
                            if authenticationStatus == "0" || authenticationStatus.contains("successful") {
                                // Keep Going
                                sleep(2)
                                progressValue = 0.4
                                UserDefaults.standard.setValue(true, forKey: "userHasLaunchedApp")
                                progressValue = 0.8
                                sleep(1)
                                progressValue = 1
                            }
                            else {
                                // Error
                            }
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 40).frame(width: 330, height: 70).foregroundColor(.yellow)
                            Text("Run").font(.custom("Avenir Next", size: 34))
                        }
                    }.buttonStyle(ScaleButtonStyle()).animation(.easeIn, value: true).shadow(radius: 10)
                }
                else {
                    Button(action: {
                        proceed = 5
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 40).frame(width: 330, height: 70).foregroundColor(.red)
                            Text("Finish").font(.custom("Avenir Next", size: 34))
                        }
                    }.buttonStyle(ScaleButtonStyle()).animation(.easeIn, value: true).shadow(radius: 10)
                }
            }.frame(width: 1000, height: 700, alignment: .center)
        }
    }
}

struct ProgressBar: View {
    @Binding var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(.systemTeal))
                
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(.systemBlue))
                    .animation(.linear)
            }.cornerRadius(45.0)
        }
    }
}
