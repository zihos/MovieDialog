//
//  EditViewController.swift
//  MovieDialog
//
//  Created by linc on 27/01/2019.
//  Copyright © 2019 linc. All rights reserved.
//

import UIKit
import Photos

class EditViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var dialog:Dialog?
    var dialogs:[Dialog]=[]
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let encoder = PropertyListEncoder()
    let decoder = PropertyListDecoder()
    
    let picker = UIImagePickerController() //갤러리 및 카메라에서 사진을 불러올 때 사용
    
    //-----Cancel button
    @IBAction func cancelNavButton(_ sender: Any) {
        self.dismiss(animated:true, completion:nil)
    }
    
    var checkImage:Bool = false
    
    @IBOutlet weak var movieImage: UIImageView! //영화 포스터
    @IBOutlet weak var textTitle: UITextField!//영화 제목
    @IBOutlet weak var date: UILabel! //관람일.
    
    //-----Save button
    @IBAction func saveNavButton(_ sender: Any) {
        if textTitle.text == "" {
            let alert = UIAlertController(title: "영화 제목을 입력해 주세요.", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title:"확인", style:UIAlertAction.Style.default) { UIAlertAction in })
            present(alert, animated:true, completion:nil)
            return
        }
        
        let originalCreatedDate = dialog?.createdDate
        
        
        //-----일기 생성일 계산
        let today = NSDate() //현재 날짜
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        //let todayString = dateFormatter.string(from: today as Date)
        
        //-----사진 저장시 이름 계산
        let dateFormatterForFileName = DateFormatter()
        dateFormatterForFileName.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        let imageName = dateFormatterForFileName.string(from: today as Date)+".png"
        
        //-----사진 저장
        if let saveImg = movieImage.image{
            saveImage(incomeImage: saveImg, imageName: imageName) //사진 저장
        }
        
        //-----리뷰
        var optionalFreeReviewText = ""
        if let tempReviewText = reviewInputText.text{ //리뷰가 비어있지 않다면 저장
            optionalFreeReviewText = tempReviewText
        }
        if reviewInputText.textColor == UIColor.lightGray { //리뷰가 placeholder라면
            optionalFreeReviewText = ""
        }
        
        if star5.isSelected == true{
            countStar = 5
        } else if star4.isSelected == true {
            countStar = 4
        } else if star3.isSelected == true {
            countStar = 3
        } else if star2.isSelected == true {
            countStar = 2
        } else if star1.isSelected == true {
            countStar = 1
        } else {
            countStar = 0
        }
        
        //-----객체 생성
        let newDiary = Dialog(title: textTitle.text!, image: imageName, date: date.text!, star: countStar, simpleReview: checkBoxChecked(), review: optionalFreeReviewText, createdDate: originalCreatedDate!)
        
        //createdDate 비교
        
        dialog=newDiary
        
        if let data=try? Data(contentsOf: URL(fileURLWithPath:documentsPath+"/dialog.plist")){
            if let decodedDialogs=try? decoder.decode([Dialog].self, from: data){
                dialogs=decodedDialogs
                print(dialogs)
            }else{
                print("디코딩 실패")
            }
        }else{
            print("기존 데이터 없음")
        }
        
        for (index,d) in dialogs.enumerated(){
            if dialog?.createdDate==d.createdDate{
                dialogs[index]=dialog!
                break
            }
        }
        
        if let data = try? encoder.encode(dialogs){
            try? data.write(to: URL(fileURLWithPath: documentsPath + "/dialog.plist"))
            self.dismiss(animated:true, completion:nil)
        }else{
            print("변경사항이 저장되지 않았습니다!")
        }
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    func saveImage(incomeImage:UIImage, imageName:String){
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        
        //print(imagePath)
        let image = incomeImage //이미지 받아오기(매개변수)
        let data = image.pngData() //png
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil) //도큐먼트에 저장
    }
    
    func checkBoxChecked() -> [String] {
        var simpleReviewResult:[String] = []
        if check1.isSelected == true{
            simpleReviewResult += [label1.text!]
        }
        if check2.isSelected == true{
            simpleReviewResult += [label2.text!]
        }
        if check3.isSelected == true{
            simpleReviewResult += [label3.text!]
        }
        if check4.isSelected == true{
            simpleReviewResult += [label4.text!]
        }
        if check5.isSelected == true{
            simpleReviewResult += [label5.text!]
        }
        if check6.isSelected == true{
            simpleReviewResult += [label6.text!]
        }
        if check7.isSelected == true{
            simpleReviewResult += [label7.text!]
        }
        if check8.isSelected == true{
            simpleReviewResult += [label8.text!]
        }
        if check9.isSelected == true{
            simpleReviewResult += [label9.text!]
        }
        if check10.isSelected == true{
            simpleReviewResult += [label10.text!]
        }
        if check11.isSelected == true{
            simpleReviewResult += [label11.text!]
        }
        if check12.isSelected == true{
            simpleReviewResult += [label12.text!]
        }
        
        return simpleReviewResult
    }
    
    @IBAction func selectPicButtonUpdated(_ sender: UIButton) {
        let actionSheet = UIAlertController(title:"포스터 입력 방식을 선택해 주세요", message:nil, preferredStyle:.actionSheet)
        actionSheet.addAction(UIAlertAction(title:"웹에서 검색하기", style:.default, handler:{result in
            //검색창 띄우기
            if let _ = self.storyboard!.instantiateViewController(withIdentifier: "SearchViewID") as? SearchViewController{
                //self.present(searchController, animated:true, completion:nil)
                self.performSegue(withIdentifier: "toSearchSegue", sender: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title:"갤러리에서 불러오기", style:.default, handler:{result in
            //갤러리에서 이미지 불러오기
            self.openLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title:"사진 찍기", style:.default, handler:{result in
            //카메라로 사진 찍기
            self.openCamera()
        }))
        actionSheet.addAction(UIAlertAction(title:"취소", style:.cancel, handler:nil))
        self.present(actionSheet, animated:true, completion:nil)
    }
    
    
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    var countStar:Int = 0
    
    
    @IBAction func handleStar1(_ sender: Any) {
        star1.isSelected = true
        star2.isSelected = false
        star3.isSelected = false
        star4.isSelected = false
        star5.isSelected = false
        countStar = 1
    }
    
    @IBAction func handleStar2(_ sender: Any) {
        star1.isSelected = true
        star2.isSelected = true
        star3.isSelected = false
        star4.isSelected = false
        star5.isSelected = false
        countStar = 2
    }
    @IBAction func handleStar3(_ sender: Any) {
        star1.isSelected = true
        star2.isSelected = true
        star3.isSelected = true
        star4.isSelected = false
        star5.isSelected = false
        countStar = 3
    }
    
    @IBAction func handleStar4(_ sender: Any) {
        star1.isSelected = true
        star2.isSelected = true
        star3.isSelected = true
        star4.isSelected = true
        star5.isSelected = false
        countStar = 4
    }
    
    @IBAction func handleStar5(_ sender: Any) {
        star1.isSelected = true
        star2.isSelected = true
        star3.isSelected = true
        star4.isSelected = true
        star5.isSelected = true
        countStar = 5
    }
    
    
    @IBAction func selectDate(_ sender: Any) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        let alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        alert.view.addSubview(datePicker)
        
        alert.addAction(UIAlertAction(title:"완료", style:.default, handler:{result in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from:datePicker.date)
            self.date.font = UIFont(name:self.date.font.fontName, size:17)
            self.date.frame.origin = CGPoint(x:207, y:150)
            self.date.text = dateString
            
        }))
        alert.addAction(UIAlertAction(title:"취소", style:.cancel, handler:nil))
        self.present(alert, animated:true, completion:nil)
        
    }
    
    @IBOutlet weak var simpleView:UIView!
    @IBOutlet weak var normalView:UIView!
    @IBAction func segControl(_ sender:UISegmentedControl){
        if sender.selectedSegmentIndex == 0{
            simpleView.isHidden = false
            normalView.isHidden = true
        } else {
            simpleView.isHidden = true
            normalView.isHidden = false
        }
    }
    
    @IBOutlet weak var check1: UIButton!
    @IBOutlet weak var check2: UIButton!
    @IBOutlet weak var check3: UIButton!
    @IBOutlet weak var check4: UIButton!
    @IBOutlet weak var check5: UIButton!
    @IBOutlet weak var check6: UIButton!
    @IBOutlet weak var check7: UIButton!
    @IBOutlet weak var check8: UIButton!
    @IBOutlet weak var check9: UIButton!
    @IBOutlet weak var check10: UIButton!
    @IBOutlet weak var check11: UIButton!
    @IBOutlet weak var check12: UIButton!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label7: UILabel!
    @IBOutlet weak var label8: UILabel!
    @IBOutlet weak var label9: UILabel!
    @IBOutlet weak var label10: UILabel!
    @IBOutlet weak var label11: UILabel!
    @IBOutlet weak var label12: UILabel!
    
    
    @IBAction func checkAction1(_ sender: Any) {
        if check1.isSelected == true{
            check1.isSelected = false
        } else {
            check1.isSelected = true
        }
    }
    @IBAction func checkAction2(_ sender: Any) {
        if check2.isSelected == true{
            check2.isSelected = false
        } else {
            check2.isSelected = true
        }
    }
    @IBAction func checkAction3(_ sender: Any) {
        if check3.isSelected == true{
            check3.isSelected = false
        } else {
            check3.isSelected = true
        }
    }
    @IBAction func checkAction4(_ sender: Any) {
        if check4.isSelected == true{
            check4.isSelected = false
        } else {
            check4.isSelected = true
        }
    }
    @IBAction func checkAction5(_ sender: Any) {
        if check5.isSelected == true{
            check5.isSelected = false
        } else {
            check5.isSelected = true
        }
    }
    @IBAction func checkAction6(_ sender: Any) {
        if check6.isSelected == true{
            check6.isSelected = false
        } else {
            check6.isSelected = true
        }
    }
    @IBAction func checkAction7(_ sender: Any) {
        if check7.isSelected == true{
            check7.isSelected = false
        } else {
            check7.isSelected = true
        }
    }
    @IBAction func checkAction8(_ sender: Any) {
        if check8.isSelected == true{
            check8.isSelected = false
        } else {
            check8.isSelected = true
        }
    }
    @IBAction func checkAction9(_ sender: Any) {
        if check9.isSelected == true{
            check9.isSelected = false
        } else {
            check9.isSelected = true
        }
    }
    @IBAction func checkAction10(_ sender: Any) {
        if check10.isSelected == true{
            check10.isSelected = false
        } else {
            check10.isSelected = true
        }
    }
    @IBAction func checkAction11(_ sender: Any) {
        if check11.isSelected == true{
            check11.isSelected = false
        } else {
            check11.isSelected = true
        }
    }
    @IBAction func checkAction12(_ sender: Any) {
        if check12.isSelected == true{
            check12.isSelected = false
        } else {
            check12.isSelected = true
        }
    }
    
    //@IBOutlet weak var reviewInputText: UITextField!
    @IBOutlet weak var reviewInputText: UITextView!
    
    //리뷰 글자 수 제한
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let str = textView.text else { return true }
        let newLength = str.characters.count + text.characters.count - range.length
        return newLength <= 450
    }
    
    //리뷰 입력을 시작할 때 placeholder 지워주기
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            textView.textAlignment = NSTextAlignment.left
        }
    }
    
    //리뷰를 작성하지 않았을 때 placeholder 생성해주기
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "  이곳에 리뷰를 입력해 주세요.                                  최대 450자까지 입력 가능합니다."
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        simpleView.isHidden = false
        normalView.isHidden = true
        textTitle.placeholder = "영화 제목을 입력해 주세요"
        
        
        textTitle.text = dialog?.title //제목 설정
        getImage(imageName: (dialog?.image)!)
        date.text = dialog?.date //관람일 설정
        self.date.font = UIFont(name:self.date.font.fontName, size:17)
        self.date.frame.origin = CGPoint(x:207, y:150)
        switch(dialog?.star) {
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
        
        if let simple = dialog?.simpleReview {
            for item in simple {
                switch(item) {
                case label1.text: check1.isSelected = true
                case label2.text: check2.isSelected = true
                case label3.text: check3.isSelected = true
                case label4.text: check4.isSelected = true
                case label5.text: check5.isSelected = true
                case label6.text: check6.isSelected = true
                case label7.text: check7.isSelected = true
                case label8.text: check8.isSelected = true
                case label9.text: check9.isSelected = true
                case label10.text: check10.isSelected = true
                case label11.text: check11.isSelected = true
                case label12.text: check12.isSelected = true
                default:
                    break
                }
            }
        }
        
        reviewInputText.text = dialog?.review
        if reviewInputText.text.count == 0 {
            reviewInputText.text = "  이곳에 리뷰를 입력해 주세요.                                  최대 450자까지 입력 가능합니다." //placeholder
            reviewInputText.textColor = UIColor.lightGray
            reviewInputText.textAlignment = NSTextAlignment.center
        }
        
    }
    
    func getImage(imageName:String){
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.cachesDirectory,.userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath:imagePath){
            movieImage.image = UIImage(contentsOfFile:imagePath)
        } else{
            print("no image")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewInputText.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object:nil)
    }
    

    func openLibrary(){
        picker.sourceType = .photoLibrary
        present(picker, animated:false, completion:nil)
    }
    
    func openCamera(){
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker, animated:false, completion:nil)
        } else{
            print("Camera not available")
        }
    }
    
    @objc func keyboardWillShow(_ sender:Notification){
        if reviewInputText.isFirstResponder{
            self.view.frame.origin.y = -240 //Move view 150 points upward
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        reviewInputText.resignFirstResponder()
        return true
    }
    @objc func keyboardWillHide(_ sender: Notification){
        self.view.frame.origin.y = 0 //Move view to original position
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    
    

}
