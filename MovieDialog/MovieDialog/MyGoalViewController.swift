//
//  MyGoalViewController.swift
//  MovieDialog
//
//  Created by linc on 21/01/2019.
//  Copyright © 2019 linc. All rights reserved.
//

import UIKit

class MyGoalViewController: UIViewController {
    
    @IBOutlet weak var goalList: UITableView!
    
    var challenges:[Challenge]=[]
    var dialogs:[Dialog]=[]
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let encoder = PropertyListEncoder()
    let decoder = PropertyListDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalList.dataSource = self
        goalList.delegate = self
        // Do any additional setup after loading the view.
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let data = try? Data(contentsOf: URL(fileURLWithPath:documentsPath + "/challenge.plist")){
            if let decodedChallenge = try? decoder.decode([Challenge].self, from: data){
                challenges = decodedChallenge
                if challenges.count > 0 {

                }
                
                
                print(challenges)
            }else{
                print("디코딩 실패")
            }
        }else{
            print("기존 데이터 없음")
        }

        challenges = challenges.reversed()
        
        goalList.reloadData()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if challenges.count > 0 {
            let calendar = Calendar.current
            let date1 = calendar.startOfDay(for: Date())
            let date2 = calendar.startOfDay(for: challenges[0].time)
            var components1 = calendar.dateComponents([.day], from: date2, to: date1)
            
            // 목표를 추가 못하는 경우! 현재 진행중인 마감 안된 목표가 있을 경우
            if let ident = identifier , let day = components1.day {
                if ident == "addGoal" {
                    if challenges[0].goal > challenges[0].now , day < 0 {
                        let alert = UIAlertController(title: "현재 진행중인 목표가 있습니다.", message: "목표를 추가할 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title:"확인", style:UIAlertAction.Style.default) { UIAlertAction in
                            self.dismiss(animated:true, completion:nil)
                        })
                        present(alert, animated:true, completion:nil)
                        return false
                    }
                }
            }
        }
        
       
        return true
    }
    
}

extension MyGoalViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0{
            return 1
        }else{
            if challenges.count==0{
                return 0
            }else{
                return challenges.count-1
            }
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section==0{
            return "진행 중인 목표"
        }else{
            return "지난 목표들"
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if challenges.count>0{
            if indexPath.section==0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyGoalCell", for: indexPath) as! MyGoalCell
                let challenge = challenges[indexPath.row]
                
                cell.goalName.text = challenge.title
                //달성률
                
                cell.goalRate.text = String(Float(challenge.now*100 / challenge.goal))+"%"
                //진행바
                cell.progressFront.frame.size.width = CGFloat(298 * challenge.now / challenge.goal)
                
                let startDate = challenge.startTime
                let finishDate = challenge.time
                
                let today = Date()
                
                let calendar = Calendar.current
                
                let date1 = calendar.startOfDay(for: startDate)
                let date2 = calendar.startOfDay(for: finishDate)
                let date3 = calendar.startOfDay(for: today)
                
                let start = dateFormatter.string(from: challenge.startTime)
                let finish = dateFormatter.string(from: challenge.time)
                
                var components1 = calendar.dateComponents([.day], from: date3, to: date1)
                var components2 = calendar.dateComponents([.day], from: date3, to:date2)
                if components1.day! > 0{
                    cell.goalDday.text=String(start[start.startIndex...start.index(start.endIndex, offsetBy:-10)]) + " ~ " + String(finish[finish.startIndex...finish.index(finish.endIndex, offsetBy:-10)])
                    cell.status.text="진행 예정"
                }else if components1.day! <= 0, components2.day! > 0{
                    cell.goalDday.text = String(start[start.startIndex...start.index(start.endIndex, offsetBy:-10)]) + " ~ " + String(finish[finish.startIndex...finish.index(finish.endIndex, offsetBy:-10)])
                    if let day=components2.day{
                        cell.status.text="D - \(day)"
                    }
                }else{
                    cell.goalDday.text = String(start[start.startIndex...start.index(start.endIndex, offsetBy:-10)]) + " ~ " + String(finish[finish.startIndex...finish.index(finish.endIndex, offsetBy:-10)])
                    cell.status.text="마감"
                }
                
                cell.progressBack.layer.cornerRadius = 10
                cell.progressFront.layer.cornerRadius = 7
                
                
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyGoalListCell", for: indexPath) as! MyGoalListCell
                
                cell.goalListTitle.text = challenges[indexPath.row+1].title
                
                let start = dateFormatter.string(from: challenges[indexPath.row+1].startTime)
                let finish = dateFormatter.string(from: challenges[indexPath.row+1].time)
                
                cell.goalListDate.text=String(start[start.startIndex...start.index(start.endIndex, offsetBy:-10)]) + " ~ " + String(finish[finish.startIndex...finish.index(finish.endIndex, offsetBy:-10)])
                cell.goalListNum.text = "목표 영화 개수 : \(challenges[indexPath.row+1].goal)"
                
                //image rotate
                cell.goalListImage.transform = CGAffineTransform(rotationAngle: (-7.0 * .pi) / 180.0)
                
                if challenges[indexPath.row+1].now == challenges[indexPath.row+1].goal{
                    cell.goalListImage.image = UIImage(named: "missioncomplete")
                    // 달성 시
                }else{
                    // 미 달성시
                    cell.goalListImage.image = UIImage(named: "missionfail")
                }
                
                return cell
            }
        }
        return tableView.dequeueReusableCell(withIdentifier: "MyGoalListCell", for: indexPath) as! MyGoalListCell
    }
    
    
}

extension MyGoalViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}


