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
                var newRequest = URLRequest(url: url)
                newRequest.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.6 Safari/537.11", forHTTPHeaderField: "User-Agent")
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
