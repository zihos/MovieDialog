//
//  ShowDiaryViewController.swift
//  MovieDialog
//
//  Created by linc on 23/01/2019.
//  Copyright © 2019 linc. All rights reserved.
//

import UIKit

class ShowDiaryViewController: UIViewController {
    
    //-----Cancel button
    @IBAction func cancelNavButton(_ sender: Any) {
        self.dismiss(animated:true, completion:nil)
    }
    
    //-----edit button
    @IBAction func editNavButton(_ sender: Any) {
        if let editView = self.storyboard!.instantiateViewController(withIdentifier: "EditID") as? EditViewController{
            //self.performSegue(withIdentifier: "EditSegue", sender: nil)
            present(editView, animated: true, completion:nil)
            editView.dialog = self.dialog
        }
    }
    
    var dialogs:[Dialog]=[]
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let encoder = PropertyListEncoder()
    let decoder = PropertyListDecoder()
    
    //-----delete button
    @IBAction func deleteDialog(_ sender: Any) {
        let alert = UIAlertController(title: "일기가 삭제됩니다", message: "정말 삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:"확인", style:UIAlertAction.Style.default) { UIAlertAction in
            if let data=try? Data(contentsOf: URL(fileURLWithPath:self.documentsPath+"/dialog.plist")){
                if let decodedDialogs=try? self.decoder.decode([Dialog].self, from: data){
                    self.dialogs=decodedDialogs
                    //                print(dialogs)
                }else{
                    print("디코딩 실패")
                }
            }else{
                print("기존 데이터 없음")
            }
            
            for (index,d) in self.dialogs.enumerated(){
                if self.dialog?.image==d.image{
                    self.dialogs.remove(at: index)
                    break
                }
            }
            
            if let data = try? self.encoder.encode(self.dialogs){
                try? data.write(to: URL(fileURLWithPath: self.documentsPath + "/dialog.plist"))
                self.dismiss(animated:true, completion:nil)
            }else{
                print("변경사항이 저장되지 않았습니다!")
            }
        })
        alert.addAction(UIAlertAction(title:"취소", style:UIAlertAction.Style.cancel){ UIAlertAction in })
        present(alert, animated:true, completion:nil)
        
        
        
    }
    
    @IBOutlet weak var titleLabel: UILabel! //영화 이름
    @IBOutlet weak var dateLabel: UILabel! //관람일
    @IBOutlet weak var imageLabel: UIImageView! //영화 포스터
    @IBOutlet weak var imageBackground: UIImageView! //영화 포스터
    
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var reviewLabel: UILabel!
    
    var dialog:Dialog?
    
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = dialog?.title
        dateLabel.text = dialog?.date
        //이미지
        switch(dialog!.star){
        case 1:
            star1.isSelected = true
            star2.isSelected = false
            star3.isSelected = false
            star4.isSelected = false
            star5.isSelected = false
        case 2:
            star1.isSelected = true
            star2.isSelected = true
            star3.isSelected = false
            star4.isSelected = false
            star5.isSelected = false
        case 3:
            star1.isSelected = true
            star2.isSelected = true
            star3.isSelected = true
            star4.isSelected = false
            star5.isSelected = false
        case 4:
            star1.isSelected = true
            star2.isSelected = true
            star3.isSelected = true
            star4.isSelected = true
            star5.isSelected = false
        case 5:
            star1.isSelected = true
            star2.isSelected = true
            star3.isSelected = true
            star4.isSelected = true
            star5.isSelected = true
        default:
            star1.isSelected = false
            star2.isSelected = false
            star3.isSelected = false
            star4.isSelected = false
            star5.isSelected = false
        }
        
        if let simpleReview = dialog?.simpleReview{
            var simpleString = ""
            for item in simpleReview{
                simpleString += "#\(item)   "
            }
            label1.text = simpleString
        }
        
        if dialog?.simpleReview.count == 0 {
            label1.text = "간편리뷰가 없습니다."
        }
        
        reviewLabel.text = dialog?.review
        
        if reviewLabel.text == "" {
            reviewLabel.text = "해당 일기에 기록된 리뷰가 없습니다."
            reviewLabel.textAlignment = NSTextAlignment.center
        }
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getImage(imageName: (dialog?.image)!)
        // Do any additional setup after loading the view.
    }
    

    func getImage(imageName:String){
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.cachesDirectory,.userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath:imagePath){
            imageLabel.image = UIImage(contentsOfFile:imagePath)
            imageBackground.image = UIImage(contentsOfFile:imagePath)
        } else{
            print("no image")
        }
    }
    
}
