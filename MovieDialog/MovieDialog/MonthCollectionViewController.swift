//
//  MonthCollectionViewController.swift
//  MovieDialog
//
//  Created by In Taek Cho on 27/01/2019.
//  Copyright © 2019 linc. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MonthCollectionViewController: UICollectionViewController {

    var dialogs:[Dialog]?
    var month:String?
    
    func getImage(imageName: String) -> String{
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        
        if fileManager.fileExists(atPath: imagePath){
            return imagePath
        }else{
            return ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title=month
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mDETAIL_SEGUE" {
            if let detailVC = segue.destination as? ShowDiaryViewController, let cell = sender as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: cell) {
                
                let dialog=dialogs![indexPath.row]
                detailVC.dialog=dialog
            }
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if let num = dialogs?.count{
            return num
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monthCollection", for: indexPath) as! DialogCollectionViewCell
    
        // Configure the cell
        cell.monthMovieImage.image=UIImage(contentsOfFile: getImage(imageName: dialogs![indexPath.row].image))
        
        return cell
    }

}
