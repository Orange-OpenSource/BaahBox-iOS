/*
 *
 * ESSAbout
 *
 * File name:   ESSAboutDetailViewController.swift
 * Version:     2.1.0
 * Created:     04/10/2016
 * Created by:  Julien GALHAUT
 *
 * Copyright (C) 2016 Orange
 *
 * This software is confidential and proprietary information of Orange.
 * You shall not disclose such Confidential Information and shall use it only in
 * accordance with the terms of the agreement you entered into.
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 *
 * If you are Orange employee you shall use this software in accordance with
 * the Orange Source Charter ( http://opensource.itn.ftgroup/index.php/Orange_Source ).
 *
 */

import UIKit
import WebKit

class ESSAboutDetailViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var toolbarView: UIToolbar!
    
    var webView: WKWebView!
    var linkInBrowser: Bool! = false
    var filePath: String! = nil
    
    func configureView() {
        // Update the user interface for the detail item.
        if  self.urlString == nil && self.detailItem != nil {
            loadHTML()
        } else {
            loadURL()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let detail = self.detailItem {
            if let delegate: ESSAboutStatDelegate = ESSAboutManager.sharedInstance.essStatDelegate {
                delegate.componentDidShowView(detail.titleKey)
            }
            if (detail.titleKey.range(of: "ESSAbout.rubricTitle") != nil) {
                self.title = ESSAboutManager.bundle.localizedString(forKey: detail.titleKey, value: "", table: "ESSAbout")
            } else {
                self.title = detail.titleKey
            }
            self.linkInBrowser = detail.linkInBrowser
        }
        
        
        // Create WKWebView in code, because IB cannot add a WKWebView directly
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = UIColor.white;
        webView.isOpaque = false;
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        self.view.addSubview(webView)
        
        let standardSpacing: CGFloat = 0.0
        let bottomSpacing: CGFloat = (self.urlString == nil ? 0.0 : 44.0)
        
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: guide.topAnchor, constant: standardSpacing),
                guide.bottomAnchor.constraint(equalTo: webView.bottomAnchor, constant: bottomSpacing),
                webView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: standardSpacing),
                webView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: standardSpacing)
                ])
            
        } else {
            //let margins = view.layoutMarginsGuide
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[webView]-0-|",
                                                                    options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                    metrics: nil,
                                                                    views: ["webView": webView as Any]))
            NSLayoutConstraint.activate([
                
                //H
                webView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing),
                bottomLayoutGuide.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: bottomSpacing)
                ])
        }
        
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ESSAboutViewController.preferredContentSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
        
        
    }
    
    
    func preferredContentSizeChanged() {
        let navbarFont =  UIFont.boldSystemFont(ofSize: UIFont.fontSizeWithPreferredContentSizeBasedOnNormal(forSize: 17.0))
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSAttributedString.Key.font: navbarFont, NSAttributedString.Key.foregroundColor: ESSAboutManager.sharedInstance.titleColor as Any]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let navbarFont =  UIFont.boldSystemFont(ofSize: 17)
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSAttributedString.Key.font: navbarFont, NSAttributedString.Key.foregroundColor: ESSAboutManager.sharedInstance.titleColor as Any]
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else { return }
        
        switch keyPath {
        case "loading":
            // If you have back and forward buttons, then here is the best time to enable it
            backButton.isEnabled = webView.canGoBack
            forwardButton.isEnabled = webView.canGoForward
            stopButton.isEnabled = webView.isLoading
            
        case "estimatedProgress":
            // If you are using a `UIProgressView`, this is how you update the progress
            //progressView.hidden = webView.estimatedProgress == 1
            //progressView.progress = Float(webView.estimatedProgress)
            break
            
        default:
            break
        }
    }
    
    @IBAction func backAction(_ sender: AnyObject) {
        webView.goBack()
    }
    
    @IBAction func forwardAction(_ sender: AnyObject) {
        webView.goForward()
    }
    
    @IBAction func refreshAction(_ sender: AnyObject) {
        webView.reload()
    }
    
    @IBAction func stopAction(_ sender: AnyObject) {
        webView.stopLoading()
    }
    
    private func loadHTML() {
        let defaultBaseUrl = URL(fileURLWithPath: Bundle.main.bundlePath)
        guard var filePath = detailItem?.contentKey else {
            webView.loadHTMLString("<body><h1>Error loading html file</h1></body>", baseURL: defaultBaseUrl)
            return
        }
        var url : URL = URL(fileURLWithPath: filePath)
        if url.path != filePath {
            filePath = Bundle.main.path(forResource: filePath.components(separatedBy: ".")[0], ofType: "html")!
            url = defaultBaseUrl
        }
        let baseUrl = URL(fileURLWithPath: url.path)
        let fileContent : String
        do {
            fileContent = try String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
            if(fileContent.range(of: "<html>")==nil){
                let cssPath = ESSAboutManager.bundle.path(forResource: "styles_light", ofType: "css")
                var htmlStringFinal = "<html><head><link rel='stylesheet' type='text/css' href='"
                htmlStringFinal.append(cssPath!)
                htmlStringFinal.append("'/>")
                htmlStringFinal.append("<meta name='viewport' content='initial-scale=1.0' />")
                htmlStringFinal.append("</head>")
                htmlStringFinal.append(fileContent)
                htmlStringFinal.append("</html>")
                webView.loadHTMLString(htmlStringFinal, baseURL: baseUrl)
            }else{
                webView.loadHTMLString(fileContent, baseURL: baseUrl)
            }
        } catch {
            let errortBaseUrl = URL(fileURLWithPath: Bundle.main.bundlePath)
            webView.loadHTMLString("<body><h1>Error loading html file</h1></body>", baseURL: errortBaseUrl)
        }
        
    }
    
    func loadURL() {
        if let urlString = self.urlString {
            guard let url = URL(string: urlString) else {return}
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        if(webView != nil){
            if (webView.isLoading){
                webView.stopLoading()
            }
            webView.navigationDelegate = nil
            webView.uiDelegate = nil
            webView.removeObserver(self, forKeyPath: "loading")
            webView.removeObserver(self, forKeyPath: "estimatedProgress")
            detailItem = nil
        }
    }
    
    var urlString: String? {
        didSet {
            // Update the view.
        }
    }
    
    var detailItem: ESSAboutElement? {
        didSet {
        }
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        let url: URL! = navigationAction.request.url
        if self.urlString != nil {
            decisionHandler(.allow)
            return
        }
        
        if(url.absoluteString.contains("file://") == false){
            if(self.linkInBrowser == true ){
                UIApplication.shared.openURL(url!)
            } else {
                ESSAboutManager.performESSAboutDetailViewController(self, url: url.absoluteString)
            }
        }
        decisionHandler(.allow)
    }
}
