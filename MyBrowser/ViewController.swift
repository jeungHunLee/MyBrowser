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
    
    //url 불러오는 함수
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
    
    //activity indicator 로딩중
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        myActivityIndicator.startAnimating()
        myActivityIndicator.isHidden = false
    }
    
    //activity indicator 로딩 완료
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        myActivityIndicator.stopAnimating()
        myActivityIndicator.isHidden = true
    }
    
    //activity indicator 로딩 실패
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        myActivityIndicator.stopAnimating()
        myActivityIndicator.isHidden = true
    }
    
    //return 키 터치하면 url로 이동하고 키보드 내리는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let checkUrl = isValidUrl(url: txtUrl.text!)
        if checkUrl {
            if !(txtUrl.text!.hasPrefix("http://")) {
                txtUrl.text! = "http://" + txtUrl.text!
            }
            loadWebPage(txtUrl.text!)
            txtUrl.text = ""
        }
        else {
            let isValidUrlAlert = UIAlertController(title: "Warning", message: "유효하지 않은 url입니다.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
            isValidUrlAlert.addAction(onAction)
            present(isValidUrlAlert, animated: true, completion: nil)
        }
        txtUrl.resignFirstResponder()
        return true
    }
    
    //url이 유효한 형식인지 확인
    func isValidUrl(url: String) -> Bool {
            let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
            let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
            let result = urlTest.evaluate(with: url)
            return result
        }

    @IBAction func btnGoUrl(_ sender: UIButton) {
        let checkUrl = isValidUrl(url: txtUrl.text!)
        if checkUrl {
            if !(txtUrl.text!.hasPrefix("http://")) {
                txtUrl.text! = "http://" + txtUrl.text!
            }
            loadWebPage(txtUrl.text!)
            txtUrl.text = ""
        }
        //url이 유효하지 않다면 alert 표시
        else {
            let isValidUrlAlert = UIAlertController(title: "Warning", message: "유효하지 않은 url입니다.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
            isValidUrlAlert.addAction(onAction)
            present(isValidUrlAlert, animated: true, completion: nil)
        }
        txtUrl.resignFirstResponder()
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


