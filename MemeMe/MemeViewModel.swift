//
//  MemeViewModel.swift
//  MemeMe1
//
//  Created by fengchi on 2020/2/1.
//  Copyright © 2020 vend. All rights reserved.
//

import Foundation
import UIKit

struct Memes: Codable {
    var memes: [Meme]
    
    init(memes: [Meme]) {
        self.memes = memes
    }
}

struct Meme: Codable {
    var topText: String
    var bottomText: String
    var originalImage: Image
    var memedImage: Image
}

class MemesViewModel {
    
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Memes.plist")
    
    func getMemes() -> Memes? {
        if let xml = FileManager.default.contents(atPath: path.absoluteString),
            let memes = try? PropertyListDecoder().decode(Memes.self, from: xml) {
            return memes
        } else {
            return nil
        }
    }
    
    func appendMemes(meme: Meme) {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
                
        var memes = Memes(memes: [])
        if let m = getMemes() {
            memes.memes = m.memes
        }
        
        do {
            memes.memes.append(meme)
            let data = try encoder.encode(memes)
            try data.write(to: path)
        } catch {
            print("🥵🥵🥵🥵🥵🥵🥵")
            print(error)
            print("🥵🥵🥵🥵🥵🥵🥵")
        }
    }
    
}

struct Image: Codable {
    let imageData: Data?
    
    init(withImage image: UIImage) {
        self.imageData = image.pngData()
    }
    
    func getImage() -> UIImage? {
        guard let imageData = self.imageData else {
            return nil
        }
        let image = UIImage(data: imageData)
        
        return image
    }
}
