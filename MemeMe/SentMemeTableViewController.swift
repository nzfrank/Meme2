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
    private let reusableCellID = "TableViewCellID"
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    
    // MARK: UITableViewController delegate funcs
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Memes.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: reusableCellID)!
        let meme = Memes.memes[(indexPath as NSIndexPath).row]
        let title = meme.topText + " " + meme.bottomText
        cell.textLabel?.text = title
        cell.imageView!.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = Memes.memes[(indexPath as NSIndexPath).row]
        
        let vc = self.storyboard?.instantiateViewController(identifier: "details_vc") as! MemeDetailViewController
        vc.image = meme.memedImage
        self.navigationController!.pushViewController(vc, animated: true)
    }
}
