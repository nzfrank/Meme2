//
//  SentMemeCollectionViewController.swift
//  MemeMe
//
//  Created by fengchi on 2020/2/16.
//  Copyright © 2020 chifengnz. All rights reserved.
//

import Foundation
import UIKit

class SentMemeCollectionViewController: UICollectionViewController {
    
    // MARK: Properties
    private let reusableCellID = "CollectionViewCellID"
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionViewLayout.collectionView?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Memes.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCellID, for: indexPath) as! MemeCollectionViewCell
        let meme = Memes.memes[(indexPath as NSIndexPath).row]
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let meme = Memes.memes[(indexPath as NSIndexPath).row]
        
        let vc = UIViewController()
        let imageView = UIImageView(image: meme.memedImage)
        vc.view.addSubview(imageView)
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3, height: collectionView.frame.size.height/3)
    }
}

class MemeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var memeImageView: UIImageView!
}
