//
//  TermsVC.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 7/20/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class TermsVC: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatWebView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true) { 
            //done
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TermsVC: UIWebViewDelegate {
    
    func formatWebView() {
        webview.delegate = self
        loadWebview()
        spinner.startAnimating()
    }
    
    func loadWebview() {
        
        let urlString = "https://www.thestockgenius.com/terms"
        let url = URL(string: urlString)
        if let url = url {
            let request = URLRequest(url: url)
            webview.loadRequest(request)
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        spinner.stopAnimating()
        spinner.alpha = 0
        
    }

}

