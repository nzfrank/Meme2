//
//  SentMemeViewController.swift
//  MemeMe1
//
//  Created by fengchi on 2020/2/10.
//  Copyright © 2020 vend. All rights reserved.
//

import Foundation
import UIKit

class SentMemeViewController: UINavigationController {
    
    public var sentMemes: [Meme]?
    private var createMemeButton: UIBarButtonItem = {
        let b = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createMeme))
        return b
    }()
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = createMemeButton
        super.viewDidLoad()
    }
    
    @objc func createMeme() {
        
    }
}


