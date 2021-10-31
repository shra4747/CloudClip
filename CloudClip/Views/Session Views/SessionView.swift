//
//  SessionView.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 4/6/21.
//

import SwiftUI
import Foundation
import WebKit
import Cocoa

struct SessionView: View {
    
    @State private var sessionFolders: [SessionFolders] = []
    @State private var selectedFolderFiles: Array<Dictionary<String, String>> = []
    @State var sessionName = "Choose a Session!"
    @State var scrollID = 0
    @State var isLoading = false
    
    var body: some View {
        ZStack {
            //Background
            VStack {
                Rectangle().frame(width: 1280, height: 880).foregroundColor(Color.init(hex: "F5F4FF"))
            }
            
            //Sidebar
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .frame(width: 280, height: 720)
                        .offset(x: -30)
                        .foregroundColor(Color.init(hex: "D0DBFF"))
                        .shadow(color: .gray, radius: 10, x: 0, y: 4)
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Sessions").font(.custom("Avenir Next Demi Bold", size: 42)).foregroundColor(Color.init(hex: "190060"))
                            Rectangle().frame(width: 176, height: 1).foregroundColor(Color.init(hex: "520092"))
                        }.padding().padding(.bottom, -12)
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading) {
                                ForEach(sessionFolders, id: \.self) { session in
                                    HStack {
                                        Rectangle().frame(width: 1, height: 32).foregroundColor(.white).shadow(radius: 2)
                                        Text(session.folderName).font(.custom("Avenir Next", size: 22)).padding(.trailing, 20)
                                    }.onTapGesture {
                                        self.isLoading = true
                                        sessionName = session.folderName
                                        SwiftRunCommands().fileInDirectory(function: "fileInDirectory", folderID: session.folderID) { files in
                                            selectedFolderFiles = files
                                            scrollID = 0
                                            isLoading = false
                                        }
                                    }
                                }
                            }
                        }
                    }.frame(width: 260, height: 715, alignment: .leading)
                }
                
                Spacer()
                Text(sessionName).font(.custom("Avenir Next Demi Bold", size: 40)).foregroundColor(.black)

                ZStack {
                    if sessionName == "Choose a Session!" {
                        Text("").font(.custom("Avenir Next Demi Bold", size: 40)).foregroundColor(.black)
                    }
                    else if isLoading {
                        if #available(macOS 11.0, *) {
                            ProgressView()
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    else {
                        ScrollView(.vertical) {
                            let s = CGFloat(1280-300)
                            VStack {
                                ForEach(0..<selectedFolderFiles.chunked(into: 2).count, id: \.self) { i in
                                    HStack(spacing: 50) {
                                        ForEach(0..<selectedFolderFiles.chunked(into: 2)[i].count, id: \.self) { x in
                                            HStack(spacing: 10) {
                                                let file = selectedFolderFiles.chunked(into: 2)[i][x]
                                                let link = file["thumbnailLink"]
                                                let image = "\(link ?? "")".loadImage()
                                                
                                                ZStack {
                                                    
                                                    RoundedRectangle(cornerRadius: 20)
                                                        
                                                        .frame(width: s/3, height: 300)
                                                        .opacity(1)
                                                        .foregroundColor(.white)
                                                        .shadow(radius: 15)
                                                    VStack(spacing: -5) {
                                                        ZStack {
                                                            HStack {
                                                                Image(nsImage: image).resizable().opacity(1)
                                                                    .cornerRadius(20)
                                                                    .padding(10)
                                                                    .scaledToFit()
                                                                Spacer()
                                                            }
                                                        }
                                                        VStack {
                                                            HStack {
                                                                Text("\(file["title"] ?? "")".replacingOccurrences(of: ".jpg", with: "")).font(.custom("Avenir Next Demi Bold", size: 30)).foregroundColor(.black)
                                                                Spacer()
                                                            }
                                                            HStack {
                                                                Text("\(file["id"] ?? "")").font(.custom("Avenir Next", size: 18)).foregroundColor(Color(.darkGray))
                                                                Spacer()
                                                            }
                                                        }.padding(10)
                                                        Spacer()
                                                    }.frame(width: s/3, height: 300)
                                                }.onTapGesture {
                                                    let link = "https://drive.google.com/file/d/\(file["id"] ?? "")/view"
                                                    let url = URL(string: "\(link)")!
                                                    NSWorkspace.shared.open(url)
                                                }
                                            }
                                        }
                                    }
                                    .padding()
                                    .frame(width: 1280-300)
                                }
                            }.padding(.vertical, 100)
                        }
                        .id(scrollID)
                        .frame(width: 1280-300)
                    }
                    
                    
                }
                
                
                
                Spacer()

//                else {
//                    VStack {
//                        Text("!").font(.custom("Avenir Next Heavy", size: 60))
//                        Text("No session selected!").font(.custom("Avenir Next", size: 50))
//                    }.padding(.trailing, 300)
//                }
            }
            
        }.frame(width: 1280, height: 820, alignment: .center).padding(.top, 20).onAppear {
            DispatchQueue.main.async {
                SwiftRunCommands().iterateSessions(function: "iterateSessions") { sessions in
                    for session in sessions {
                        sessionFolders.append(SessionFolders(folderName: "\(session["title"] ?? "ERR")", folderID: "\(session["id"] ?? "ERR")"))
                    }
                }
            }

            DispatchQueue.main.async {
                SwiftRunCommands().clipsDirectoryID(function: "getCloudClipFilesFolderID") { mainCloudClipFilesID in
                    if mainCloudClipFilesID == "1" {
                        // Show error logging in view
                        NSApp.keyWindow?.close()
                        var window: NSWindow!
                        
                        window = NSWindow(
                            contentRect: NSRect(x: 0, y: 0, width: 1000, height: 700),
                            styleMask: [.closable, .titled, .fullSizeContentView, .miniaturizable, .resizable],
                            backing: .buffered, defer: false)
                        window.isReleasedWhenClosed = false
                        window.center()
                        window.title = "Error Logging In"
                        window.contentView = NSHostingView(rootView: ErrorLogInView())
                        window.makeKeyAndOrderFront(true)
                        window.orderFront(true)
                        NSApp.activate(ignoringOtherApps: true)
                    }
                    else {
                        sessionFolders.insert(SessionFolders(folderName: "Other Clips", folderID: mainCloudClipFilesID), at: 0)
                    }
                }
            }
        }
    }
}

struct SessionFolders: Hashable {
    let folderName: String
    let folderID: String
}

struct WebView : NSViewRepresentable {
    
    let request: URLRequest
    
    func makeNSView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.load(request)
    }
    
}

extension String {
    func loadImage() -> NSImage {
        
        do {
            guard let url = URL(string: self) else {
                return NSImage()
            }
            
            let data: Data = try Data(contentsOf: url)
            
            return NSImage(data: data) ?? NSImage()
        } catch {
            
        }
        
        return NSImage()
    }
}


