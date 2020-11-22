//
//  SearchViewController.swift
//  MovieDialog
//
//  Created by linc on 17/01/2019.
//  Copyright © 2019 linc. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    var delegate:SendDataDelegate?
    
    
    @IBAction func cancelNavButton(_ sender: Any) {
        self.dismiss(animated:true, completion:nil)
    }
    
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        if let _ = searchTextField.text{
            performSegue(withIdentifier:"searchSegue", sender:self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }

    
    //MoviesTableViewController의 queryText 필드에 텍스트 필드의 내용을 저장해줌으로써 다음 뷰로 검색어를 넘김
    override func prepare(for segue:UIStoryboardSegue, sender:Any?){
        if let moviesVC = segue.destination as? MoviesTableViewController{
            if let text = searchTextField.text{
                moviesVC.delegate = delegate
                moviesVC.queryText = text
            }
        }
    }

}
