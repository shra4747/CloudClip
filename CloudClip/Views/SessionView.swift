//
//  SessionView.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 4/6/21.
//

import SwiftUI
import Foundation

struct SessionView: View {
    let files = FileManager().contentsOfDirectory(atURL: URL(fileURLWithPath: "/Users/shravanp/Library/Application Support/CloudClip/"), sortedBy: .created, ascending: true)
    var body: some View {
        HStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading) {
                    ForEach(files, id: \.self) { file in
                        Text(file.fileName).padding(.bottom, -5).font(.title).padding(.trailing, 30)
                        Image(nsImage: (LoadImage().loadImageFromFile(fileDestination: URL(fileURLWithPath: file.fileLocation)))).padding(.bottom, 50).padding(.trailing, 30)
                    }
                }
            }
        }.frame(width: 1280, height: 720, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding(.top, 20)
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView()
    }
}
