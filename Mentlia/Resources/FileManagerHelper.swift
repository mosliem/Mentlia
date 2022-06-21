//
//  FileManagerHelper.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 4/21/22.
//

import Foundation

class FileManagerHelper {
    
    static let shared = FileManagerHelper()
    private init(){}
    
    public func getDocumentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getAbsolutePath(path: String) -> String? {
        
        if let range = path.range(of: "//"){
            
            let absolutePath = String(path[range.upperBound...])
            return absolutePath
            
        }
        return nil
    }
    
}
