//
//  InfoViewController.swift
//  MovieDialog
//
//  Created by In Taek Cho on 21/01/2019.
//  Copyright © 2019 linc. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var starNum: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var total: UIView!
    @IBOutlet weak var now: UIView!
    @IBOutlet weak var planetName: UILabel!
    //    @IBOutlet weak var firstMovie: UIImageView!
//    @IBOutlet weak var secondMovie: UIImageView!
//    @IBOutlet weak var thirdMovie: UIImageView!
//
//    @IBOutlet weak var firstTimes: UILabel!
//    @IBOutlet weak var secondTimes: UILabel!
//    @IBOutlet weak var thirdTimes: UILabel!
    
//    var rankMovie:[UIImageView]=[]
//    var rankTimes:[UILabel]=[]
    @IBAction func helpButton(_ sender: Any) {
        let alert = UIAlertController(title: "My Movie Planet", message: "영화 일기를 작성하며 매긴 별점을 모아 다음 단계의 별로 성장할 수 있습니다! 열심히 일기를 작성해서 나만의 행성을 키워보세요.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:"확인", style:UIAlertAction.Style.default) { UIAlertAction in })
        present(alert, animated:true, completion:nil)
        return
    }
    
    var dialogs:[Dialog]=[]
    var allStar:Int=0

//    var timesOfMovie:[String:Int]=[:]
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let encoder = PropertyListEncoder()
    let decoder = PropertyListDecoder()
    
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
        //starImage.image = UIImage(named: "starLevel01")

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        total.layer.cornerRadius=10
        now.layer.cornerRadius=7
//
//
//        if let path = Bundle.main.path(forResource: "dialog", ofType: "plist") {
//            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
//                if let decodedDialogs = try? decoder.decode([Dialog].self, from: data) {
//                    dialogs = decodedDialogs
//                }
//            }
//            encoder.outputFormat = .xml
//            if let data = try? encoder.encode(dialogs) {
//                try? data.write(to: URL(fileURLWithPath: documentsPath + "/dialog.plist"))
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let data=try? Data(contentsOf: URL(fileURLWithPath:documentsPath+"/dialog.plist")){
            if let decodedDialogs=try? decoder.decode([Dialog].self, from: data){
                dialogs=decodedDialogs
                allStar=0
                for dialog in dialogs{
                    allStar+=dialog.star
                }
                //                print(dialogs.count)
                
                //                print(dialogs.filter({$0.review != ""}).count)
                
                //                print(dialogs.filter({$0.simpleReview.count>0}).count)
//                timesOfMovie=[:]
//                for dialog in dialogs{
//                    if let times=timesOfMovie[dialog.title]{
//                        timesOfMovie[dialog.title]=(times+1)
//                    }else{
//                        timesOfMovie[dialog.title]=1
//                    }
//                }
                //                print(timesOfMovie.sorted{$0.1>$1.1})
            }
        }else{
            print("저장된 데이터 없음")
        }
        starNum.text = String(allStar)+" Stars"
        
        now.frame.size.width = CGFloat(343 * allStar / 200)

        if allStar >= 200 {
            starImage.image = UIImage(named: "starLevel12")
            planetName.text="은하계"
        } else if allStar >= 180 {
            starImage.image = UIImage(named: "starLevel11")
            planetName.text="태양"
        } else if allStar >= 160 {
            starImage.image = UIImage(named: "starLevel10")
            planetName.text="해왕성"
        } else if allStar >= 140 {
            starImage.image = UIImage(named: "starLevel09")
            planetName.text="천왕성"
        } else if allStar >= 120 {
            starImage.image = UIImage(named: "starLevel08")
            planetName.text="토성"
        } else if allStar >= 100 {
            starImage.image = UIImage(named: "starLevel07")
            planetName.text="목성"
        } else if allStar >= 80 {
            starImage.image = UIImage(named: "starLevel06")
            planetName.text="화성"
        } else if allStar >= 60 {
            starImage.image = UIImage(named: "starLevel05")
            planetName.text="지구"
        } else if allStar >= 40 {
            starImage.image = UIImage(named: "starLevel04")
            planetName.text="달"
        } else if allStar >= 20 {
            starImage.image = UIImage(named: "starLevel03")
            planetName.text="금성"
        } else if allStar >= 1 {
            starImage.image = UIImage(named: "starLevel02")
            planetName.text="수성"
        } else {
            starImage.image = UIImage(named: "starLevel01")
            planetName.text="소행성"
        }
        

//        rankMovie=[firstMovie,secondMovie,thirdMovie]
//        rankTimes=[firstTimes,secondTimes,thirdTimes]
//        //            cell.detailTextLabel?.text = timesOfMovie.sorted{$0.1>$1.1}[0].0
//        let rank=timesOfMovie.sorted{$0.1>$1.1}
//        print(rank)
//        var index=0
//
//        for r in rank{
//            for dialog in dialogs{
//                if dialog.title==r.key{
//                    rankMovie[index].image=UIImage(contentsOfFile: getImage(imageName: dialog.image))
//                    rankTimes[index].text=String(r.value)+"번"
//                    break
//                }
//            }
//            index+=1
//            if index==3 {
//                break
//            }
//        }

        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        dialogs=dialogs.reversed()
        if segue.identifier=="REVIEW_SEGUE"{
            if let detailVC = segue.destination as? detailReviewTableViewController, let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                if indexPath.row == 1{
                    let reviewD=dialogs.filter{$0.review.count>0}
                    detailVC.dialogs=reviewD
                    detailVC.isReview=true
                }else if indexPath.row == 2{
                    let simpleReviewD=dialogs.filter{$0.simpleReview.count>0}
                    detailVC.dialogs=simpleReviewD
                    detailVC.isSimpleReview=true
                }

            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier=="REVIEW_SEGUE", let cell = sender as? UITableViewCell, let indexPath=tableView.indexPath(for: cell){
            if indexPath.row==0{
                return false
            }
        }
        return true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension InfoViewController:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        


        let cell=tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.detailTextLabel?.textColor = .blue
        
        if indexPath.row == 0 {
            cell.textLabel?.text="관람 작품 수"
            cell.detailTextLabel?.text = String(dialogs.count)+" 개"
            cell.accessoryType = .none
        }else if indexPath.row==1{
            cell.textLabel?.text="작성 리뷰 수"
            cell.detailTextLabel?.text=String(dialogs.filter({$0.review != ""}).count)+" 개"
            cell.accessoryType = .disclosureIndicator
        }else{
            cell.textLabel?.text="작성 간편리뷰 수"
            cell.detailTextLabel?.text = String(dialogs.filter({$0.simpleReview.count>0}).count)+" 개"
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
}

extension InfoViewController:UITableViewDelegate{
    
}

