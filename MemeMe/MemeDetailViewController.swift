//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by fengchi on 2020/2/24.
//  Copyright © 2020 chifengnz. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet var memeImageView: UIImageView!
    var image:UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.memeImageView.image = self.image
        view.addSubview(memeImageView)
    }
}
