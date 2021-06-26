//
//  SessionView.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 4/6/21.
//

import SwiftUI
import Foundation
import PythonKit

struct SessionView: View {
    var body: some View {
        HStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading) {
                    
                }
            }
        }.frame(width: 1280, height: 720, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding(.top, 20).onAppear {
            let sys = Python.import("sys")
            sys.path.append("\(Constants.cloudClipUserHomeDirectory)/CloudClipPython")
            let googleDriveDownlaod = Python.import("googleDriveDownload")
            for session in Array(googleDriveDownlaod.iterateSessions()) {
                print(session["title"])
            }
        }
    }
}

