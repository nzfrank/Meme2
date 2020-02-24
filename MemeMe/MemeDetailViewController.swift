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
    
    init(_ image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        memeImageView = UIImageView(image: image)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(memeImageView)
    }
}
