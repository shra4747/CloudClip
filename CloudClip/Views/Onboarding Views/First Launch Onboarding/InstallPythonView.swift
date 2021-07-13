//
//  InstallPythonView.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 7/13/21.
//

import SwiftUI

struct InstallPythonView: View {
    @Binding var proceed: Int
    @State var notInstalled = true
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle().frame(width: 1000, height: 700).foregroundColor(.white)
            VStack(spacing: 18) {
                Text("Install Python 3.9").font(.custom("Avenir Next Demi Bold", size: 50))
                Image("pythonlogo")
                
                HStack(spacing: 20) {
                    Button(action: {
                        NSWorkspace().openFile("/Library/Application Support/CloudClipPython/python-3.9.6-macos11.pkg", withApplication: "Installer")
                        self.notInstalled = false
                        
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 40).frame(width: 330, height: 70).foregroundColor(notInstalled ? .blue : Color(.lightGray))
                            Text("Open Installer").font(.custom("Avenir Next", size: 34))
                        }
                    }.buttonStyle(ScaleButtonStyle()).animation(.easeIn, value: true).shadow(radius: 10)
                    
                    
                    if !notInstalled {
                        Button(action: {
                            self.proceed = 2
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 40).frame(width: 330, height: 70).foregroundColor(notInstalled ? Color(.lightGray) : .blue)
                                Text("Next").font(.custom("Avenir Next", size: 34))
                            }
                        }.buttonStyle(ScaleButtonStyle()).animation(.easeIn, value: true).shadow(radius: 10)
                    }
                }
            }.frame(width: 1000, height: 700, alignment: .center)
        }
    }
}

