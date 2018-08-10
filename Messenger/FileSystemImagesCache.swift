//
//  FileSystemImagesCache.swift
//  Messenger
//
//  Created by Dmitry Vorozhbicky on 08.08.2018.
//  Copyright © 2018 Dmitry Vorozhbicky. All rights reserved.
//


import UIKit

class FileSystemImagesCache: CacheProtocol {
    
    func addImageToCache(key: NSString, object: UIImage) {
        let documentsDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("\(key).jpg")
        print("----------------------->1 \(fileURL)")
        if let data = UIImageJPEGRepresentation(object, 1.0),
            !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    func checkImageInCache(key: NSString) -> UIImage? {
        let path = (self.getDirectoryPath() as NSString).appendingPathComponent("\(key).jpg")
        
        print("----------------------->2 \(path)")
        return UIImage(contentsOfFile: path)
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
