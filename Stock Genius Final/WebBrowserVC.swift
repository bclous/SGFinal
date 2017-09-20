//
//  WebBrowserVC.swift
//  Stock Genius
//
//  Created by Brian Clouser on 5/11/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

protocol WebBrowserViewControllerDelegate {
    func readyToReload()
}

class WebBrowserVC: UIViewController {


    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var browserFooterView: BrowserFooterView!
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    var newsItem : NewsItem?
    var ticker : String?
    var delegate : WebBrowserViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatWebView()
        formatHeader()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        delegate?.readyToReload()
        
    }
    
  
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func formatHeader() {
        if let ticker = ticker {
            tickerLabel.text = ticker
        }
        
        headerView.backgroundColor = SGConstants.mainBlackColor
        tickerLabel.font = tickerLabel.font.withSize(15.0)
    }
}

extension WebBrowserVC: UIWebViewDelegate, BrowserFooterDelegate {
    
    func formatWebView() {
        webView.delegate = self
        browserFooterView.delegate = self
        loadWebview()
        
    }
    
    func loadWebview() {
        
       
    
        let urlString = newsItem?.articleURL
        if let urlString = urlString {
            let url = URL(string: urlString)
            if let url = url {
                let userAgent = newsItem!.source == "SeekingAlpha" ? "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/603.3.8 (KHTML, like Gecko) Version/10.1.2 Safari/603.3.8" : "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.3 Mobile/14E277 Safari/603.1.30"
                let newRequest = URLRequest(url: url)
                UserDefaults.standard.register(defaults: ["UserAgent" : userAgent])
                webView.scalesPageToFit = true
                webView.loadRequest(newRequest)
            }
        }

    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        browserFooterView.formatBrowserFooter(backAvailable: webView.canGoBack, forwardAvailable: webView.canGoForward)
    }
    
    func userTap(choice: BrowserChoice) {
        switch choice {
        case .back:
            webView.goBack()
        case .forward:
            webView.goForward()
        case .share:
            shareArticle()
        }
    }
    
    func shareArticle() {
        let urlString = newsItem?.articleURL
        if let urlString = urlString {
            let url = URL(string: urlString)
            if let url = url {
                let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                navigationController?.present(activityViewController, animated: true, completion: { 
                    //stuff?
                })
            }
        }
    }
}