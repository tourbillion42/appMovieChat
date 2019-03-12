//
//  DetailViewController.swift
//  appMovieChat
//
//  Created by Hwang on 01/01/2019.
//  Copyright © 2019 Hwang. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController : UIViewController {
    
    @IBOutlet var wv: WKWebView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var mvo : MovieVO!
    
    override func viewDidLoad() {
        
        self.wv.navigationDelegate = self
        
        NSLog("linkUrl = \(self.mvo.detail!) , title = \(self.mvo.title!)")
        
        let naviBar = self.navigationItem
        naviBar.title = self.mvo.title
        
        if let url = self.mvo?.detail {
            if let urlObj = URL(string: url) {
                let req = URLRequest(url: urlObj)
                self.wv.load(req)
            }
            else {
                let alert = UIAlertController(title: "오류", message: "잘못된 URL 입니다", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "확인", style: .cancel) {(_) in _ = self.navigationController?.popViewController(animated: true)}
                
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        else {
            let alert = UIAlertController(title: "오류", message: "필수 파라미터가 누락되었습니다", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "확인", style: .cancel) {(_) in _ = self.navigationController?.popViewController(animated: true)}
            
            alert.addAction(cancelAction)
            self.present(alert, animated: false, completion: nil)
        }
    }
}

extension DetailViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.spinner.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.spinner.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.spinner.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.spinner.startAnimating()
    }
}

extension UIViewController {
    func alert(_ message : String, onClik : (() -> Void)? = nil) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel) {(_) in onClik?() })
        
        DispatchQueue.main.async {
            self.present(controller, animated: false)
        }
    }
}

