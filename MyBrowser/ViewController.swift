//
//  ViewController.swift
//  MyBrowser
//
//  Created by 이정훈 on 2022/07/29.
//

import UIKit
import WebKit
import Network

class ViewController: UIViewController, WKNavigationDelegate {
    let monitor = NWPathMonitor()    //네트워크 상태를 모니터링할 인스턴스
    
    @IBOutlet var txtUrl: UITextField!
    @IBOutlet var myWebView: WKWebView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    //@IBOutlet var progress: UIProgressView!    //progress bar
    
    //url 불러오는 함수
    func loadWebPage(_ url: String) {
        startMonitering()
        let encodedString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        //url에 유니코드가 포함 될경우 인코딩
        let myUrl = URL(string: encodedString)
        let myRequest = URLRequest(url: myUrl!)
        myWebView.load(myRequest)
        txtUrl.text! = url
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        txtUrl.delegate = self
        myWebView.navigationDelegate = self
        loadWebPage("https://www.google.com")
        
        txtUrl.keyboardType = .webSearch    //keyboard 스타일 지정
        txtUrl.clearButtonMode = .whileEditing    //text field를 수정하는 동안 clear 버튼 활성화
        
        startMonitering()    //네트워크 상태 모니터링 시작
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    //네트워크 모니터링 메서드
    func startMonitering() -> Void {
        monitor.start(queue: .global())
        monitor.pathUpdateHandler = { path in
            if path.status != .satisfied {    //네트워크 연결이 끊겼을때
                let filePath = Bundle.main.path(forResource: "loadFail", ofType: "html")
                let loadFailUrl = URL(fileURLWithPath: filePath!)
                let loadFailUrlRequest = URLRequest(url: loadFailUrl)
                self.myWebView.load(loadFailUrlRequest)
            }
        }
    }
    
    //activity indicator 로딩중
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        txtUrl.text! = webView.url!.absoluteString    //url을 String 타입으로 변환하여 대입
    }
    
    //activity indicator 로딩 완료
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    //activity indicator 로딩 실패
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    //url이 유효한 형식인지 확인
    func isValidUrl(url: String) -> Bool {
            let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
            let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
            let result = urlTest.evaluate(with: url)
            return result
    }

    @IBAction func btnGoBack(_ sender: UIBarButtonItem) {
        myWebView.goBack()
    }
    
    @IBAction func btnGoForward(_ sender: UIBarButtonItem) {
        myWebView.goForward()
    }
    
    @IBAction func btnReload(_ sender: UIBarButtonItem) {
        myWebView.reload()
    }
    
    @IBAction func goHome(_ sender: UIBarButtonItem) {
        loadWebPage("https://www.google.com")
    }
}

extension ViewController: UITextFieldDelegate {
    //url text 부분 선택시 전체 선택
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtUrl.selectAll(nil)
    }
    
    //return 키 터치하면 url로 이동하고 키보드 내리는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let checkUrl = isValidUrl(url: txtUrl.text!)
        
        if checkUrl {
            if !(txtUrl.text!.hasPrefix("https://")) {
                txtUrl.text! = "https://" + txtUrl.text!
            }
            
            loadWebPage(txtUrl.text!)
        } else {
            txtUrl.text! = "https://www.google.com/search?q=" + txtUrl.text!
            loadWebPage(txtUrl.text!)    //구글 검색으로 이동
        }
        
        txtUrl.resignFirstResponder()    //호출된 first respnder를 해지(키보드 내리기)
        return true
    }
}
