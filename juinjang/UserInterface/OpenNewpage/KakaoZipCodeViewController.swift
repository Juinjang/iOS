//
//  KakaoZipCodeViewController.swift
//  juinjang
//
//  Created by 임수진 on 1/27/24.
//

import UIKit
import WebKit

class KakaoZipCodeViewController: UIViewController {
    
    var webView: WKWebView?
    let indicator = UIActivityIndicatorView(style: .medium)
    var address = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
        setupLayout()
    }

    func setAttributes() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "callBackHandler")

        let configuration = WKWebViewConfiguration() // contentController를 WKWebView와 연결하는 것을 도움
        configuration.userContentController = contentController

        webView = WKWebView(frame: .zero, configuration: configuration)
        self.webView?.navigationDelegate = self

        guard let url = URL(string: "https://suzinlim.github.io/Kakao-Postcode/"),
            let webView = webView
            else { return }
        let request = URLRequest(url: url) // URLRequest 생성해서
        webView.load(request) // webView가 URL 로드
        indicator.startAnimating()
    }

    func setupLayout() {
        guard let webView = webView else { return }
        view.addSubview(webView)
        webView.addSubview(indicator)
        
        webView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }

        indicator.snp.makeConstraints {
            $0.centerX.equalTo(webView.snp.centerX)
            $0.centerY.equalTo(webView.snp.centerY)
        }
    }
}

extension KakaoZipCodeViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let data = message.body as? [String: Any] {
            address = data["roadAddress"] as? String ?? ""
        }
        print("도로명 주소:", address)
        
        // -MARK: 모달로 표시된 뷰 컨트롤러가 UINavigationController를 포함하는 경우
        // 현재 뷰 컨트롤러를 present한 뷰 컨트롤러가 UINavigationController인지 검사
        if let navigationController = presentingViewController as? UINavigationController {
            // navigationController의 topViewController를 검사
            let openNewPage2VC = navigationController.topViewController as? OpenNewPage2ViewController
            openNewPage2VC?.addressTextField.text = address
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension KakaoZipCodeViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
}
