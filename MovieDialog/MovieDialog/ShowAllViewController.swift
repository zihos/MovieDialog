//
//  ShowAllViewController.swift
//  MovieDialog
//
//  Created by linc on 17/01/2019.
//  Copyright © 2019 linc. All rights reserved.
//

import UIKit

class ShowAllViewController: UIViewController{
    
    @IBOutlet weak var sort: UISegmentedControl!
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    
    @IBAction func indexChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
//            print("1")
            collectionView1.isHidden = false
            collectionView2.isHidden = true
        }else if sender.selectedSegmentIndex == 1{
//            print("2")
            collectionView1.isHidden = true
            collectionView2.isHidden = false
        }
    }
    
    func getImage(imageName: String) -> String{
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        
        if fileManager.fileExists(atPath: imagePath){
            return imagePath
        }else{
            return ""
        }
    }
    
    var dialogs:[Dialog]=[]
    var monthDic:[String:[Dialog]]=[:]
    var month:[String]=[]
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let encoder = PropertyListEncoder()
    let decoder = PropertyListDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        collectionView1.delegate = self
        collectionView1.dataSource=self
        
        collectionView2.delegate = self
        collectionView2.dataSource=self
    }
    
    var checkOnboard = true

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        indexChange(sort)
        
        if let data=try? Data(contentsOf: URL(fileURLWithPath:documentsPath+"/dialog.plist")){
            if let decodedDialogs=try? decoder.decode([Dialog].self, from: data){
                dialogs=decodedDialogs
//                print(dialogs)
            }else{
                print("디코딩 실패")
            }
        }else{
            print("기존 데이터 없음")
            if checkOnboard == true {
                if let onboard = self.storyboard!.instantiateViewController(withIdentifier: "OnboardID") as? OnboardViewController{
                    //self.performSegue(withIdentifier: "EditSegue", sender: nil)
                    checkOnboard = false
                    present(onboard, animated: false, completion:nil)
                }
            }
            
        }
        dialogs=dialogs.reversed()
        
        monthDic=[:]
        for dialog in dialogs{
            if var eachDialog=monthDic[dialog.date.substring(to: dialog.date.index(dialog.date.startIndex,offsetBy:7))]{
//                print("before")
//                print(eachDialog)
//                print(monthDic)
                eachDialog.append(dialog)
                monthDic[dialog.date.substring(to: dialog.date.index(dialog.date.startIndex,offsetBy:7))]=eachDialog
//                print("after")
//                print(eachDialog)
//                print(monthDic)
            }else{
//                print("ok")
                monthDic[dialog.date.substring(to: dialog.date.index(dialog.date.startIndex,offsetBy:7))]=[]
                monthDic[dialog.date.substring(to: dialog.date.index(dialog.date.startIndex,offsetBy:7))]?.append(dialog)
            }
        }
//        monthDic=monthDic.sorted{$0.0>$1.0}
        month=Array(monthDic.keys)
//        print(monthDic)
//        print(month)
        
        collectionView1.reloadData()
        collectionView2.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DETAIL_SEGUE" {
            if let detailVC = segue.destination as? ShowDiaryViewController, let cell = sender as? UICollectionViewCell, let indexPath = collectionView1.indexPath(for: cell) {
                
                let dialog=dialogs[indexPath.row]
                detailVC.dialog=dialog
            }
        }else if segue.identifier == "MONTH_SEGUE"{
            if let detailVC=segue.destination as? MonthCollectionViewController, let cell = sender as? UICollectionViewCell, let indexPath=collectionView2.indexPath(for: cell){
                
                let dialogs=monthDic[month[indexPath.row]]
                detailVC.dialogs = dialogs
                detailVC.month=month[indexPath.row]
            }
        }
    }

}

extension ShowAllViewController:UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView==collectionView1{
            return dialogs.count
        }else{
//            print(monthDic.count)
            return monthDic.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView1{
            let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "defaultCollection", for: indexPath) as! DialogCollectionViewCell

            if dialogs.count>0{
                cell.movieImage.image=UIImage(contentsOfFile: getImage(imageName: dialogs[indexPath.row].image))
            }
            return cell
        }else{
        
            let cell2=collectionView.dequeueReusableCell(withReuseIdentifier: "defaultCollection2", for: indexPath) as! DialogCollectionViewCell
            
            cell2.monthLabel.text=month[indexPath.row]
            
            //cell2.monthView.layer.cornerRadius=20
            //cell2.monthView.layer.borderColor = UIColor.black.cgColor
            //cell2.monthView.layer.borderWidth = 2
            cell2.monthView.layer.backgroundColor = UIColor.white.cgColor
            
            return cell2
        }
    }
    
}

extension ShowAllViewController:UICollectionViewDelegate{

}
