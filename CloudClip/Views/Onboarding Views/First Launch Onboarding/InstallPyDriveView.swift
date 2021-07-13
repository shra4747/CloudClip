//
//  InstallPyDriveView.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 7/13/21.
//

import SwiftUI

struct InstallPyDriveView: View {
    @Binding var proceed: Int
    @State var success = false
    @State var triedInstall = false
    @State var clicked = false
    @State var codeLog = ""
    @State var title = "Install PyDrive Package"
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle().frame(width: 1000, height: 700).foregroundColor(.white)
            VStack(spacing: 18) {
                Text(title).font(.custom("Avenir Next Demi Bold", size: 50))
                Image("pydrive").scaleEffect(0.6)
                
                if triedInstall == false {
                    Button(action: {
                        clicked = true
                        SwiftRunCommands().installPyDrive { result in
                            triedInstall = true
                            codeLog = result.log
                            success = result.success
                            if !success {
                                title = "ERROR INSTALLING PACKAGE"
                            }
                            else {
                                title = "Successfully Installed Package!"
                            }
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 40).frame(width: 330, height: 70).foregroundColor(.green)
                            Text("Install").font(.custom("Avenir Next", size: 34))
                        }
                    }.buttonStyle(ScaleButtonStyle()).animation(.easeIn, value: true).shadow(radius: 10)
                }
                
                
                
                if triedInstall && success == true {
                    HStack {
                        Button(action: {
                            var window: NSWindow!

                            window = NSWindow(
                                contentRect: NSRect(x: 0, y: 0, width: 700, height: 500),
                                styleMask: [.titled, .closable, .fullSizeContentView, .miniaturizable],
                                backing: .buffered, defer: false)
                            window.isReleasedWhenClosed = false
                            window.center()
                            window.contentView = NSHostingView(rootView:
                                                                ScrollView(.vertical) {
                                                                    Text(codeLog)
                                                                }
                                )
                            window.makeKeyAndOrderFront(true)
                            window.orderFront(true)
                            NSApp.activate(ignoringOtherApps: true)
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 40).frame(width: 330, height: 70).foregroundColor(Color(.lightGray))
                                Text("Show Log").font(.custom("Avenir Next", size: 34))
                            }
                        }.buttonStyle(ScaleButtonStyle()).animation(.easeIn, value: true).shadow(radius: 10)
                        
                        Button(action: {
                            self.proceed = 3
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 40).frame(width: 330, height: 70).foregroundColor(.blue)
                                Text("Next").font(.custom("Avenir Next", size: 34))
                            }
                        }.buttonStyle(ScaleButtonStyle()).animation(.easeIn, value: true).shadow(radius: 10)
                    }
                }
                else if triedInstall && success == false && clicked {
                    HStack {
                        Button(action: {
                            var window: NSWindow!

                            window = NSWindow(
                                contentRect: NSRect(x: 0, y: 0, width: 700, height: 500),
                                styleMask: [.closable, .fullSizeContentView, .miniaturizable],
                                backing: .buffered, defer: false)
                            window.isReleasedWhenClosed = false
                            window.center()
                            window.contentView = NSHostingView(rootView:
                                                                ScrollView(.vertical) {
                                                                    Text(codeLog)
                                                                }
                                )
                            window.makeKeyAndOrderFront(true)
                            window.orderFront(true)
                            NSApp.activate(ignoringOtherApps: true)
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 40).frame(width: 330, height: 70).foregroundColor(Color(.lightGray))
                                Text("Show Log").font(.custom("Avenir Next", size: 34))
                            }
                        }.buttonStyle(ScaleButtonStyle()).animation(.easeIn, value: true).shadow(radius: 10)
                    }
                }
                
                if !triedInstall && clicked {
                    LoadingCircles()
                }
            }.frame(width: 1000, height: 700, alignment: .center)
        }
    }
}

struct LoadingCircles: View {
    
    let timer = Timer.publish(every: 1.6, on: .main, in: .common).autoconnect()
    @State var leftOffset: CGFloat = -100
    @State var rightOffset: CGFloat = 100
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 20, height: 20)
                .offset(x: leftOffset)
                .opacity(0.7)
                .animation(Animation.easeInOut(duration: 1))
            Circle()
                .fill(Color.blue)
                .frame(width: 20, height: 20)
                .offset(x: leftOffset)
                .opacity(0.7)
                .animation(Animation.easeInOut(duration: 1).delay(0.2))
            Circle()
                .fill(Color.blue)
                .frame(width: 20, height: 20)
                .offset(x: leftOffset)
                .opacity(0.7)
                .animation(Animation.easeInOut(duration: 1).delay(0.4))
        }
        .onReceive(timer) { (_) in
            swap(&self.leftOffset, &self.rightOffset)
        }
    }
    
}
