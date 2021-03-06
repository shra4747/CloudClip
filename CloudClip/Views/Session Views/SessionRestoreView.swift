//
//  SessionRestoreView.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 6/26/21.
//

import SwiftUI

struct SessionRestoreView: View {
    
    @State private var restorableSessions: [SessionFolders] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(spacing: 10) {
                Text("Restorable Sessions")
                    .font(.custom("Avenir Next Demi Bold", size: 30)).padding()
                Text("Tap on a session title to restore it! ")
                    .font(.custom("Avenir Next", size: 20)).padding(.leading).padding(.leading)
            }.padding(.top, 50)
            ScrollView(.vertical, showsIndicators: false) {
                List(restorableSessions, id: \.self) { session in
                    ZStack {
                        Rectangle().foregroundColor(Color(.lightGray))
                        Text(session.folderName + "  >")
                            .font(.custom("Avenir Next", size: 25))
                            .onTapGesture {
                                UserDefaults.standard.setValue(session.folderName, forKey: "sessionNameTitle")
                                UserDefaults.standard.setValue(true, forKey: "inSession")
                                UserDefaults.standard.setValue(session.folderID, forKey: "sessionID")
                                
                                let alert = NSAlert()
                                alert.messageText = "Session Restored!"
                                alert.informativeText = "The '\(session.folderName)' session has been restored. Click 'End Session' in the menu bar to end it!"
                                alert.icon = NSImage(named: "StartSession")
                                alert.beginSheetModal(for: NSApp.keyWindow!) { _ in  NSApp.keyWindow?.close(); NSApp.keyWindow?.close()}
                            }.multilineTextAlignment(.center)
                        
                    }
                }.frame(width: 500, height: 800)
            }.frame(width: 500, height: 800)
        }.onAppear {
            SwiftRunCommands().iterateSessions(function: "iterateSessions") { sessions in
                for session in sessions {
                    restorableSessions.append(SessionFolders(folderName: "\(session["title"] ?? "ERR")", folderID: "\(session["id"] ?? "ERR")"))
                }
            }
            
        }
    }
}

struct SessionRestoreView_Previews: PreviewProvider {
    static var previews: some View {
        SessionRestoreView()
    }
}
