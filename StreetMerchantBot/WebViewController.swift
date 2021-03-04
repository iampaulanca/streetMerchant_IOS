//
//  WebViewController.swift
//  StreetMerchantBot
//
//  Created by Paul Ancajima on 3/3/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    private let url: URL
    
    private let webView: WKWebView = {
       let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.load(URLRequest(url: self.url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }

}
