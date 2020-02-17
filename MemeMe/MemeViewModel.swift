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
}

struct Meme: Codable {
    var topText: String
    var bottomText: String
    var originalImage: Image
    var memedImage: Image
}

class MemesViewModel {
    
    let filename = "Memes"
    
    func getMemes() -> Memes? {
        if let path = Bundle.main.path(forResource: filename, ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path),
            let memes = try? PropertyListDecoder().decode(Memes.self, from: xml) {
            return memes
        } else {
            return nil
        }
    }
    
    func appendMemes(meme: Meme) {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename + ".plist")
        
        var memes:Memes!
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
