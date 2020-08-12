//
//  webView.swift
//  Project16
//
//  Created by Александр Банников on 12.08.2020.
//  Copyright © 2020 AlexBanana. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var urlString: String = "https://en.wikipedia.org/wiki/"
    var detailUrl: String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlString = urlString + detailUrl!
        if let url = URL(string: urlString) {
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        } else { return }
        
    }
}
