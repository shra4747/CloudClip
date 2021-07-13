//
//  FirstLaunchWelcomeView.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 7/13/21.
//

import Foundation
import SwiftUI

struct FirstLaunchWelcomeView: View {
    
    @Binding var proceed: Int
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle().frame(width: 1000, height: 700).foregroundColor(.white)
            VStack(spacing: 18) {
                Image("lighthouse")
                Text("Welcome to CloudClip!").font(.custom("Avenir Next Demi Bold", size: 50))
                
                Button(action: {
                    self.proceed = 1
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 40).frame(width: 330, height: 70).foregroundColor(.blue)
                        Text("Get Started").font(.custom("Avenir Next", size: 34))
                    }
                }.buttonStyle(ScaleButtonStyle()).animation(.easeIn, value: true).shadow(radius: 10)
            }.frame(width: 1000, height: 700, alignment: .center)
        }
    }
}
