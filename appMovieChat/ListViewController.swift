//
//  ListViewController.swift
//  appMovieChat
//
//  Created by Hwang on 01/01/2019.
//  Copyright © 2019 Hwang. All rights reserved.
//

import UIKit

class ListViewController : UITableViewController {

    @IBOutlet var moreBtn: UIButton!
    
    var page = 1
    
    lazy var list : [MovieVO] = {
        var dataList = [MovieVO]()
        
        return dataList
    }()
    
    override func viewDidLoad() {
        self.cellMovieAPI()
    }
    
    @IBAction func more(_ sender: Any) {
    
    }
    
    func cellMovieAPI() {
        
        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=1&count=30&genreId=&order=releasedateasc"
        let apiURL : URL! = URL(string: url)
        let apiData = try! Data(contentsOf: apiURL)
        
        let log = NSString(data: apiData, encoding: String.Encoding.utf8.rawValue) ?? ""
        NSLog("API Result = \(log)")
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = self.list[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MovieCell
        
        cell.title?.text = row.title
        cell.desc?.text = row.description
        cell.opendate?.text = row.opendate
        cell.rating?.text = "\(row.rating!)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("\(indexPath.row)")
    }
}
