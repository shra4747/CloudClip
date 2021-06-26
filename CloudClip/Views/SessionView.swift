//
//  SessionView.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 4/6/21.
//

import SwiftUI
import Foundation
import PythonKit
import WebKit

struct SessionView: View {
    
    @State private var sessionFolders: [SessionFolders] = []
    @State private var selectedFolderID: String = ""
    
    var body: some View {
        ZStack {
            //Background
            VStack {
                Rectangle().frame(width: 1280, height: 890).foregroundColor(Color.init(hex: "F5F4FF"))
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
                                        Text(session.folderName).font(.custom("Avenir Next", size: 24)).padding(.trailing, 20)
                                    }.onTapGesture {
                                        selectedFolderID = session.folderID
                                    }
                                }
                            }
                        }
                    }.frame(width: 270, height: 715, alignment: .leading)
                }
                
                Spacer()
                
                if selectedFolderID != "" {
                    WebView(request: URLRequest(url: URL(string: "https://drive.google.com/drive/u/0/folders/\(selectedFolderID)")!))
                }
                else {
                    VStack {
                        Text("!").font(.custom("Avenir Next Heavy", size: 60))
                        Text("No session selected!").font(.custom("Avenir Next", size: 50))
                    }.padding(.trailing, 300)
                }
            }
            
        }.frame(width: 1280, height: 820, alignment: .center).padding(.top, 20).onAppear {
            let sys = Python.import("sys")
            sys.path.append("\(Constants.cloudClipUserHomeDirectory)/CloudClipPython")
            let googleDriveDownlaod = Python.import("googleDriveDownload")
            for session in Array(googleDriveDownlaod.iterateSessions()) {
                sessionFolders.append(SessionFolders(folderName: "\(session["title"])", folderID: "\(session["id"])"))
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
