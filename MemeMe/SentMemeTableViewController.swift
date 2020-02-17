//
//  SentMemeTableViewController.swift
//  MemeMe
//
//  Created by fengchi on 2020/2/16.
//  Copyright © 2020 chifengnz. All rights reserved.
//

import Foundation
import UIKit

class SentMemeTableViewController: UITableViewController {
    
    // MARK: Properties
    
    let memeVM = MemesViewModel()
    var memes: Memes?
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        memes = memeVM.getMemes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    
    // MARK: UITableViewController delegate funcs
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let m = memes{
            return m.memes.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let memes = memes?.memes else { return UITableViewCell() }
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let meme = memes[(indexPath as NSIndexPath).row]
        cell.imageView!.image = meme.memedImage.getImage()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let memes = memes?.memes else { return }

        let meme = memes[(indexPath as NSIndexPath).row]
        
        let vc = UIViewController()
        let imageView = UIImageView(image: meme.memedImage.getImage())
        vc.view.addSubview(imageView)

//        // Get the first node
//        let firstNodeInTheAdventure = selectedAdventure.startNode
//
//        // Get a StoryNodeController from the Storyboard
//        let storyNodeController = self.storyboard!.instantiateViewController(withIdentifier: "StoryNodeViewController") as! StoryNodeViewController
//
//        // Set the story node so that we will see the start of the story
//        storyNodeController.storyNode = firstNodeInTheAdventure
        
        // Push the new controller onto the stack
        self.navigationController!.pushViewController(vc, animated: true)
    }
}
