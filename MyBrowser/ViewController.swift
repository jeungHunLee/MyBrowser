//
//  ViewController.swift
//  MyBrowser
//
//  Created by 이정훈 on 2022/07/29.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate {
    @IBOutlet var txtUrl: UITextField!
    @IBOutlet var myWebView: WKWebView!
    @IBOutlet var myActivityIndicator: UIActivityIndicatorView!
    
    func loadWebPage(_ url: String) {
        let myUrl = URL(string: url)
        let myRequest = URLRequest(url: myUrl!)
        myWebView.load(myRequest)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        txtUrl.delegate = self
        myWebView.navigationDelegate = self
        loadWebPage("https://www.google.co.kr/")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        myActivityIndicator.startAnimating()
        myActivityIndicator.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        myActivityIndicator.stopAnimating()
        myActivityIndicator.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        myActivityIndicator.stopAnimating()
        myActivityIndicator.isHidden = true
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {  //return 키 터치하면 키보드 내리는 메서드
        textField.resignFirstResponder()
        return true
    }
    
    func checkUrl(_ url: String) -> String {
        var strUrl = url
        let flag = strUrl.hasPrefix("http://")
        
        if !flag {
            strUrl = "http://" + strUrl
        }
        
        return strUrl
    }

    @IBAction func btnGoUrl(_ sender: UIButton) {
        let myUrl = checkUrl(txtUrl.text!)
        txtUrl.text = ""
        loadWebPage(myUrl)
    }
    
    @IBAction func btnGoBack(_ sender: UIButton) {
        myWebView.goBack()
    }
    
    @IBAction func btnGoForward(_ sender: UIButton) {
        myWebView.goForward()
    }
    
    @IBAction func btnReload(_ sender: UIButton) {
        myWebView.reload()
    }
    
    @IBAction func goHome(_ sender: UIButton) {
        loadWebPage("https://www.google.co.kr/")
    }
}

