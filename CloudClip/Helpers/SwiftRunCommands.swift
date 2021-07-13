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

        process.launchPath = "/usr/bin/python3"
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

        process.launchPath = "/usr/bin/python3"
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

        process.launchPath = "/usr/bin/python3"
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

        process.launchPath = "/usr/bin/python3"
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
    
    func startup(function: String, completion: @escaping (String) -> ()) {
        let process = Process()
        let pipe = Pipe()

        process.launchPath = "/usr/bin/python3"
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

        process.launchPath = "/usr/bin/python3"
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

        process.launchPath = "/usr/bin/python3"
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
    
    func installPyDrive() {
        let process = Process()
        process.launchPath = "/usr/bin/pip3"
        process.currentDirectoryPath = "/Library/Application Support/CloudClipPython"
        process.arguments = [("install"), ("PyDrive"), ("--user")]
        process.waitUntilExit()
        process.launch()
    }
}

