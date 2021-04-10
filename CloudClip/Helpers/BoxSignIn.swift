//
//  DropboxSignIn.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 4/7/21.
//

import Foundation
import Cocoa
import SwiftyDropbox

public class BoxSignIn {
    public func trySignIn() {
//        let image = LoadImage().loadImageFromFile(fileDestination: URL(fileURLWithPath: "/Users/shravanp/Library/Application Support/CloudClip/launched with commandline.jpg"))
        DropboxClientsManager.setupWithAppKeyDesktop("jbzmsjufj2ntft3")
        let client = DropboxClientsManager.authorizedClient
        guard client != nil else {
//
            return
        }
    }
    
    public func authorize() {
        DropboxClientsManager.authorizeFromController(sharedWorkspace: NSWorkspace.shared, controller: NSViewController(), openURL: { (url: URL) -> Void in NSWorkspace.shared.open(url)})

      let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read"], includeGrantedScopes: false)
      DropboxClientsManager.authorizeFromControllerV2(
          sharedWorkspace: NSWorkspace.shared,
          controller: NSViewController(),
          loadingStatusDelegate: nil,
          openURL: {(url: URL) -> Void in NSWorkspace.shared.open(url)},
          scopeRequest: scopeRequest
      )
    }
    
    @objc public func handleGetURLEvent(_ event: NSAppleEventDescriptor?, replyEvent: NSAppleEventDescriptor?) {
        if let aeEventDescriptor = event?.paramDescriptor(forKeyword: AEKeyword(keyDirectObject)) {
            if let urlStr = aeEventDescriptor.stringValue {
                let url = URL(string: urlStr)!
                let oauthCompletion: DropboxOAuthCompletion = {
                    if let authResult = $0 {
                        switch authResult {
                        case .success:
                            print("Success! User is logged into Dropbox.")
                        case .cancel:
                            print("Authorization flow was manually canceled by user!")
                        case .error(_, let description):
                            print("Error: \(String(describing: description))")
                        }
                    }
                }
                DropboxClientsManager.handleRedirectURL(url, completion: oauthCompletion)
                // this brings your application back the foreground on redirect
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }
    
}
