//
//  FileExtensionSortByDate.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 4/6/21.
//

import Foundation

extension FileManager {

    enum ContentDate {
        case created, modified, accessed

        var resourceKey: URLResourceKey {
            switch self {
            case .created: return .creationDateKey
            case .modified: return .contentModificationDateKey
            case .accessed: return .contentAccessDateKey
            }
        }
    }
   
    struct LocatedFileImage: Hashable {
       let fileName: String
       let fileLocation: String
   }

    func contentsOfDirectory(atURL url: URL, sortedBy: ContentDate, ascending: Bool = true, options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles]) -> [LocatedFileImage] {

       let key = sortedBy.resourceKey

       let files = try? contentsOfDirectory(at: url, includingPropertiesForKeys: [key], options: options)
       
       var locatedImages: [LocatedFileImage] = []
       
       for file in files ?? [] {
        let lfi = LocatedFileImage(fileName: file.deletingPathExtension().lastPathComponent, fileLocation: String(file.absoluteString).replacingOccurrences(of: "file://", with: "").replacingOccurrences(of: "%20", with: " "))
           locatedImages.append(lfi)
       }
       return locatedImages
    }
}
