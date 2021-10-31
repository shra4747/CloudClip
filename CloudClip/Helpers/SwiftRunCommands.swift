//
//  SwiftRunCommands.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 7/12/21.
//

import Foundation

class SwiftRunCommands {
    func upload(fileLocation: String, fileName: String, completion: @escaping (String) -> ()) {
        let process = Process()
        let pipe = Pipe()

        process.launchPath = "/Applications/Xcode.app/Contents/Developer/Library/Frameworks/Python3.framework/Versions/3.8/Resources/Python.app/Contents/MacOS/Python"
        process.currentDirectoryPath = "/Library/Application Support/CloudClipPython"
        process.arguments = [("uploadsingle.py"), ("upload"), (fileLocation), (fileName)]
        process.standardOutput = pipe
        process.standardError = pipe
        process.launch()
        process.waitUntilExit()


        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\n", with: "")
        completion(output)
    }
    
    func uploadToSession(sessionID: String, fileLocation: String, fileName: String, completion: @escaping (String) -> ()) {
        let process = Process()
        let pipe = Pipe()

        process.launchPath = "/Applications/Xcode.app/Contents/Developer/Library/Frameworks/Python3.framework/Versions/3.8/Resources/Python.app/Contents/MacOS/Python"
        process.currentDirectoryPath = "/Library/Application Support/CloudClipPython"
        process.arguments = [("uploadtosession.py"), ("uploadToSession"), (sessionID), (fileLocation), (fileName)]
        process.standardOutput = pipe
        process.standardError = pipe
        process.launch()
        process.waitUntilExit()


        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\n", with: "")
        completion(output)
    }
    
    func session(function: String, sessionName: String, completion: @escaping (String) -> ()) {
        let process = Process()
        let pipe = Pipe()

        process.launchPath = "/Applications/Xcode.app/Contents/Developer/Library/Frameworks/Python3.framework/Versions/3.8/Resources/Python.app/Contents/MacOS/Python"
        process.currentDirectoryPath = "/Library/Application Support/CloudClipPython"
        process.arguments = [("session.py"), (function), "\(sessionName)"]
        process.standardOutput = pipe
        process.standardError = pipe
        process.launch()
        process.waitUntilExit()


        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\n", with: "")
        completion(output)
    }
    
    func iterateSessions(function: String, completion: @escaping (Array<Dictionary<String, String>>) -> ()) {
        let process = Process()
        let pipe = Pipe()

        process.launchPath = "/Applications/Xcode.app/Contents/Developer/Library/Frameworks/Python3.framework/Versions/3.8/Resources/Python.app/Contents/MacOS/Python"
        process.currentDirectoryPath = "/Library/Application Support/CloudClipPython"
        process.arguments = [("iteratesessions.py"), (function)]
        process.standardOutput = pipe
        process.standardError = pipe
        process.launch()
        process.waitUntilExit()


        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\n", with: "")
        
        var returnableSession: [[String: String]] = []
        for component in (output.components(separatedBy: "-+-+-+")) {
            if component.count > 1 {
                let folderStructure = (component.components(separatedBy: " | "))
                let title = folderStructure[0].trimmingCharacters(in: .whitespaces)
                let id = folderStructure[1].trimmingCharacters(in: .whitespaces)
                returnableSession.append(["title":title, "id": id])
            }
        }
        completion(returnableSession)
    }
    
    func fileInDirectory(function: String, folderID: String, completion: @escaping (Array<Dictionary<String, String>>) -> ()) {
        print(folderID)
        let process = Process()
        let pipe = Pipe()
        
        process.launchPath = "/Applications/Xcode.app/Contents/Developer/Library/Frameworks/Python3.framework/Versions/3.8/Resources/Python.app/Contents/MacOS/Python"
        process.currentDirectoryPath = "/Library/Application Support/CloudClipPython"
        process.arguments = [("fileInDirectory.py"), (function), (folderID)]
        process.standardOutput = pipe
        process.standardError = pipe
        process.launch()
        process.waitUntilExit()
        
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\n", with: "")

        var returnableSession: [[String: String]] = []

        for component in (output.components(separatedBy: "-+-+-+")) {
            if component.count > 1 {
                let folderStructure = (component.components(separatedBy: " | "))
                let title = folderStructure[0].trimmingCharacters(in: .whitespaces)
                
                let other = folderStructure[1].trimmingCharacters(in: .whitespaces)
                let iddates = (other.components(separatedBy: " ! "))
                let id = iddates[0].trimmingCharacters(in: .whitespaces)
                let thumbnailLink = iddates[1].trimmingCharacters(in: .whitespaces)
                
                returnableSession.append(["title":title, "id": id, "thumbnailLink":thumbnailLink])
            }
        }
        completion(returnableSession)
    }
    
    func startup(function: String, completion: @escaping (String) -> ()) {
        let process = Process()
        let pipe = Pipe()

        process.launchPath = "/Applications/Xcode.app/Contents/Developer/Library/Frameworks/Python3.framework/Versions/3.8/Resources/Python.app/Contents/MacOS/Python"
        process.currentDirectoryPath = "/Library/Application Support/CloudClipPython"
        process.arguments = [("startup.py"), (function)]
        process.standardOutput = pipe
        process.standardError = pipe
        process.launch()
        process.waitUntilExit()


        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\n", with: "")
        
        
        
        completion(output)
    }

    func clipsDirectoryID(function: String, completion: @escaping (String) -> ()) {
        let process = Process()
        let pipe = Pipe()

        process.launchPath = "/Applications/Xcode.app/Contents/Developer/Library/Frameworks/Python3.framework/Versions/3.8/Resources/Python.app/Contents/MacOS/Python"
        process.currentDirectoryPath = "/Library/Application Support/CloudClipPython"
        process.arguments = [("directoryclipsid.py"), (function)]
        process.standardOutput = pipe
        process.standardError = pipe
        process.launch()
        process.waitUntilExit()


        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\n", with: "")
        completion(output)
    }

    
    func generalSettings(function: String, completion: @escaping (Bool) -> ()) {
        let process = Process()
        let pipe = Pipe()

        process.launchPath = "/Applications/Xcode.app/Contents/Developer/Library/Frameworks/Python3.framework/Versions/3.8/Resources/Python.app/Contents/MacOS/Python"
        process.currentDirectoryPath = "/Library/Application Support/CloudClipPython"
        process.arguments = [("generalsettings.py"), (function)]
        process.standardOutput = pipe
        process.standardError = pipe
        process.launch()
        process.waitUntilExit()


        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\n", with: "").lowercased()
        completion(Bool(output) ?? false)
    }
    
    func commandTab() {
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        let s = "tell application \"System Events\" to keystroke tab using {command down}"
        task.arguments = [("-e"), (s)]
        task.launch()
        task.waitUntilExit()
    }
    
    func installPyDrive(completion: @escaping (pydriveinstallreturn) -> ()) {
        completion(pydriveinstallreturn(log: "", success: true))
//        let process = Process()
//        let pipe = Pipe()
//        /Applications/Xcode.app/Contents/Developer/Library/Frameworks/Python3.framework/Versions/3.8/Resources/Python.app/Contents/MacOS/Python
//
//        process.launchPath = "/usr/bin/pip3"
//        process.currentDirectoryPath = "/Library/Application Support/CloudClipPython"
//        process.arguments = [("install"), ("PyDrive"), ("--user")]
//        process.standardOutput = pipe
//        process.standardError = pipe
//        process.launch()
//        process.waitUntilExit()
//
//
//        let data = pipe.fileHandleForReading.readDataToEndOfFile()
//        let output = String(data: data, encoding: .utf8)!
//        if output.lowercased().contains("successfully") || output.lowercased().contains("satisfied") {
//            completion(pydriveinstallreturn(log: output, success: true))
//        }
//        else {
//            completion(pydriveinstallreturn(log: output, success: false))
//        }
    }
    
    struct pydriveinstallreturn {
        let log: String
        let success: Bool
    }
}

