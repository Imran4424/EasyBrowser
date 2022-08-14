//
//  BasicWebViewController.swift
//  EasyBrowser
//
//  Created by Shah Md Imran Hossain on 13/8/22.
//

import UIKit
import WebKit

class BasicWebViewController: UIViewController {
    var urlString: String?
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com", "shahcodersden.com", "hackingwithswift.com", "google.com"]

    // load view get called before view did load
    override func loadView() {
        super.loadView()
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "house.fill"), style: .plain, target: self, action: #selector(homeTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: webView, action: #selector(webView.goBack))
        let forwardButton = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: webView, action: #selector(webView.goForward))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [backButton, spacer, progressButton, spacer, forwardButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        guard let urlString = urlString else {
            print("[BasicWebViewController] urlString is nil")
            return
        }
        
        let url = URL(string: urlString)!
        webView.load(URLRequest(url: url))
        // allows the web view to travel forward and backward
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func homeTapped() {
        //        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        //
        //        for website in websites {
        //            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        //        }
        //
        //        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        //        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        //        present(ac, animated: true)
        
        guard let homeViewController = storyboard?.instantiateViewController(withIdentifier: "homeView") as? HomeViewController else {
            print("[BasicWebViewController] home view is not initiated")
            return
        }
              
        // for presenting view controller in full screen
        homeViewController.modalPresentationStyle = .fullScreen
        
        // present when current view controller don't have navigation view controller
        present(homeViewController, animated: true, completion: nil)
    }
    
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else {
            print("Action title is nil")
            return
        }
        
        let url = URL(string: "https://" + actionTitle)!
        webView.load(URLRequest(url: url))
        // allows the web view to travel forward and backward
        webView.allowsBackForwardNavigationGestures = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
}

extension BasicWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        let alert = UIAlertController(title: "Failed!!!", message: "Website not found", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
        
        decisionHandler(.cancel)
    }
}

