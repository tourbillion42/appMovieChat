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
        
        self.page += 1
        
        self.cellMovieAPI()
        
        self.tableView.reloadData()
    }
    
    func cellMovieAPI() {
        
        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=\(self.page)&count=30&genreId=&order=releasedateasc"
        let apiURL : URL! = URL(string: url)
        let apiData = try! Data(contentsOf: apiURL)
        
        let log = NSString(data: apiData, encoding: String.Encoding.utf8.rawValue) ?? ""
        NSLog("API Result = \(log)")
        
        do {
            let apiDictionary = try JSONSerialization.jsonObject(with: apiData, options: []) as! NSDictionary
            let hoppin = apiDictionary["hoppin"] as! NSDictionary
            let movies = hoppin["movies"] as! NSDictionary
            let movie = movies["movie"] as! NSArray
            
            for row in movie {
                let r = row as! NSDictionary
                let mvo = MovieVO()
                
                mvo.title = r["title"] as? String
                mvo.description = r["genreNames"] as? String
                mvo.detail = r["linkUrl"] as? String
                mvo.thumbnail = r["thumbnailImage"] as? String
                mvo.rating = (r["ratingAverage"] as! NSString).doubleValue
                
                let url : URL! = URL(string: mvo.thumbnail!)
                let imageURL = try! Data(contentsOf: url)
                
                mvo.thumbnailImage = UIImage(data: imageURL)
                
                self.list.append(mvo)
            }
            self.tableView.reloadData()
            
            let totalCount = (hoppin["totalCount"] as? NSString)!.integerValue
            
            if self.list.count >= totalCount {
                self.moreBtn.isHidden = true
            }
        }
        catch {
            NSLog("Error~!")
        }
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
        
        DispatchQueue.main.async(execute: {
            cell.thumbnail.image = self.getThumbnaiImage(indexPath.row)
        })
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("\(indexPath.row)")
    }
    
    func getThumbnaiImage(_ index : Int) -> UIImage {
        
        let mvo = self.list[index]
        
        if let savedImage = mvo.thumbnailImage {
            return savedImage
        }
        else {
            let url : URL! = URL(string: mvo.thumbnail!)
            let imageURL = try! Data(contentsOf: url)
            
            mvo.thumbnailImage = UIImage(data: imageURL)
            
            return mvo.thumbnailImage!
        }
    }
}

extension ListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "seDetail" {
            
            let path = self.tableView.indexPath(for: sender as! MovieCell)
            
            let detailIVC = segue.destination as? DetailViewController
            detailIVC?.mvo = self.list[path!.row]
        }
    }
}
