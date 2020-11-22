//
//  detailReviewTableViewController.swift
//  MovieDialog
//
//  Created by In Taek Cho on 30/01/2019.
//  Copyright © 2019 linc. All rights reserved.
//

import UIKit

class detailReviewTableViewController: UITableViewController {

    var dialogs:[Dialog]=[]
    var isReview:Bool?
    var isSimpleReview:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    func getImage(imageName: String) -> String{
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        
        if fileManager.fileExists(atPath: imagePath){
            return imagePath
        }else{
            return ""
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dialogs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! detailReviewTableViewCell
        
        cell.imageView?.image=UIImage(contentsOfFile: getImage(imageName: dialogs[indexPath.row].image))
        if isReview==true{
            cell.review.text=dialogs[indexPath.row].review
        }else if isSimpleReview==true{
            var string=""
            for i in dialogs[indexPath.row].simpleReview{
                string+=("#"+i+" ")
            }
            cell.review.text=string
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 141
    }
}
