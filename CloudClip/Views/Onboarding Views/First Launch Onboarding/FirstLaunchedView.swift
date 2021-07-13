//
//  FirstLaunchedView.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 7/13/21.
//

import SwiftUI

struct FirstLaunchedView: View {
    
    @State var proceed = 0
    
    var body: some View {
        if proceed == 0 {
            FirstLaunchWelcomeView(proceed: $proceed).transition(AnyTransition.move(edge: .leading)).animation(.default)
        }
        else if proceed == 1 {
            InstallPythonView(proceed: $proceed).transition(AnyTransition.move(edge: .leading)).animation(.default)
        }
        else if proceed == 2 {
            InstallPyDriveView(proceed: $proceed).transition(AnyTransition.move(edge: .leading)).animation(.default)
        }
        else if proceed == 3 {
            FirstSignInView(proceed: $proceed).transition(AnyTransition.move(edge: .leading)).animation(.default)
        }
        else if proceed == 4 {
            FirstFinalChecksView(proceed: $proceed).transition(AnyTransition.move(edge: .leading)).animation(.default)
        }
        else if proceed == 5 {
            GetStaredView()
        }
    }
}

struct FirstLaunchedView_Previews: PreviewProvider {
    static var previews: some View {
        FirstLaunchedView()
    }
}
