//
//  MoviesTableViewController.swift
//  MovieDialog
//
//  Created by linc on 18/01/2019.
//  Copyright © 2019 linc. All rights reserved.
//

import UIKit
import os.log

protocol SendDataDelegate{
    func sendData(title:String, img:UIImage)
}

class MoviesTableViewController: UITableViewController, XMLParserDelegate {
    var delegate:SendDataDelegate?
    @IBOutlet weak var titleNavigationItem: UINavigationItem!
    
    //-----포스터 이미지를 다운로드하기 위한 비동기 작업 큐 생성(큐 레이블 : posterImage)
    let posterImageQueue = DispatchQueue(label:"posterImage") //포스터 이미지를 다운로드하는 DispatchQueue 생성
    
    //-----네이버 개발자 센터에서 발급받은 클라이언트 아이디와 클라이언트 시크릿
    let clientID        = "fydITIokFbDEWn4h7ht0"    // ClientID
    let clientSecret    = "64nYjTrAiw"              //ClientSecret
    
    var queryText:String?                  // SearchVC에서 받아 오는 검색어
    var movies:[Movie]      = []           // API를 통해 받아온 결과를 저장할 array
    
    var strXMLData: String?         = ""   // xml 데이터를 저장
    var currentTag: String?          = ""   // 현재 item의 element를 저장
    var currentElement: String      = ""   // 현재 element의 내용을 저장
    var item: Movie?                = nil  // 검색하여 만들어지는 Movie 객체
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let title = queryText{
            titleNavigationItem.title = title
        }
        searchMovies()
    }

    // MARK: - NaverAPI
    func searchMovies() {
        //movies 초기화
        movies = []
        
        //queryText가 없으면 return(검색한 text가 없으면 return)
        guard let query = queryText else{
            print("No query")
            return
        }
        
        
        //-----요청 텍스트를 담아 url 생성
        let urlString = "https://openapi.naver.com/v1/search/movie.xml?query=" + query //문자열 안에 url에 허용되지 않는 문자가 들어있을 때 인코딩을 통해서 HTTP 요청을 보낼 때 문제가 생기지 않도록 함
        let urlWithPercentEscapes = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = URL(string: urlWithPercentEscapes!)
        
        
        //-----URLRequest 생성(클라이언트 아이디와 클라이언트 시크릿을 함께 전송)
        var request = URLRequest(url: url!)
        request.addValue("application/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        
        //-----URL Connection 'task'를 생성
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // 에러가 있으면 리턴
            guard error == nil else {
                print("error")
                return
            }
            
            // 데이터가 비었으면 출력 후 리턴
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            //-----데이터 초기화
            self.item?.actors = "" //배우
            self.item?.director = "" //감독
            self.item?.imageURL = "" //포스터
            self.item?.link = "" //주소
            self.item?.pubDate = "" //개봉일
            self.item?.title = "" //제목
            self.item?.userRating = "" //평점
            
            // Parse the XML
            let parser = XMLParser(data: Data(data))
            parser.delegate = self
            let success:Bool = parser.parse() //아래의 parser함수 세 개가 순차적으로 호출됨
            if success { //파싱 성공
                //print(self.strXMLData)
                print("parse success!")
            } else { //파싱 실패
                print("parse failure!")
            }
        }
        task.resume()
    }
    
    //parser가 시작태그를 발견했을 때 호출됨. 태그는 elementName에 매개변수로 주어진다.
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "title" || elementName == "link" || elementName == "image" || elementName == "pubDate" || elementName == "director" || elementName == "actor" || elementName == "userRating" {
            currentElement = ""
            if elementName == "title" {
                item = Movie()
            }
        }
    }
    
    
    //시작 태그를 인식한 후 데이터를 읽었음을 의미.
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentElement += string
    }
    
    
    //끝 태그를 인식했다는 의미. 현재 태그에 해당하는 Movie의 속성을 지정해준다.
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "title" {
            item?.title = currentElement.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        } else if elementName == "link" {
            item?.link = currentElement
        } else if elementName == "image" {
            item?.imageURL = currentElement
        } else if elementName == "pubDate" {
            item?.pubDate = currentElement
        } else if elementName == "director" {
            item?.director = currentElement
            if item?.director != "" {
                item?.director?.removeLast()
            }
        } else if elementName == "actor" {
            item?.actors = currentElement
            if item?.actors != "" {
                item?.actors?.removeLast()
            }
        } else if elementName == "userRating" {
            item?.userRating = currentElement
            movies.append(self.item!)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: -Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCellIdentifier", for: indexPath) as! MoviesTableViewCell
        let movie = movies[indexPath.row]
        guard let title = movie.title, let pubDate = movie.pubDate, let userRating = movie.userRating, let director = movie.director, let actor = movie.actors else{
            return cell
        }
        
        //----------cell 구성 부분 생략
        // 제목 및 개봉년도 레이블
        cell.titleAndYearLabel.text = "\(title)(\(pubDate))"
        
        // 평점 레이블
        if userRating == "0.00" {
            cell.userRatingLabel.text = "정보 없음"
        } else {
            cell.userRatingLabel.text = "\(userRating)"
        }
        
        // 감독 레이블
        if director == "" {
            cell.directorLabel.text = "정보 없음"
        } else {
            cell.directorLabel.text = "\(director)"
        }
        
        // 출연 배우 레이블
        if actor == "" {
            cell.actorsLabel.text = "정보 없음"
        } else {
            cell.actorsLabel.text = "\(actor)"
        }
        //----------
        
        
        // Async activity
        // 영화 포스터 이미지 불러오기
        if let posterImage = movie.image { //image가 이미 존재하면
            cell.posterImageView.image = posterImage //즉시 이미지를 cell에 나타낸다
        } else { //이미지가 다운로드 되어 있지 않으면
            cell.posterImageView.image = UIImage(named: "noImage") //디폴트 이미지를 cell에 먼저 나타내고
            posterImageQueue.async(execute: { //큐에 이미지 다운로드 작업을 넣는다
                movie.getPosterImage()
                guard let thumbImage = movie.image else { //이미지 다운로드에 실패했을 경우
                    return //블럭 빠져나가기
                }
                DispatchQueue.main.async { //이미지 다운로드 작업이 완료되면
                    cell.posterImageView.image = thumbImage //포스터 이미지를 cell에 나타내는 작업을 main 큐에 넣기
                }
            })
        }
        return cell
    }
    
    
    //셀을 터치했을 때
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let titleString = movies[indexPath.row].title, let movieImage = movies[indexPath.row].image {
            delegate?.sendData(title:titleString, img:movieImage)
            dismiss(animated:true, completion:nil)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
}
