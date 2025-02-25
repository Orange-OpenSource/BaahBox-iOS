//
//  GenericWebViewController
//  Baah Box
//
//  Copyright (C) 2017 – 2024 Orange SA
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
//


import WebKit

public enum SourceType {
    case file(String)
    case url(String)
}

public class GenericWebViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet var webView: WKWebView!
    var fileName: String = ""
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        webView.backgroundColor = .white

        navigationController?.isNavigationBarHidden = false
      
        if let url = Bundle.main.url(forResource: "\(fileName)", withExtension: "html") {
                webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
            }
    
    

        // notification for dynamic fonts
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contentSizeDidChange(_:)),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }

    @objc private func contentSizeDidChange(_: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.webView != nil {
                strongSelf.webView.reload()
            }
        }
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

//    public func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        guard let url = navigationAction.request.url else {
//            decisionHandler(.allow)
//            return
//        }
//
//        if navigationAction.navigationType == .linkActivated {
//            UIApplication.shared.open(url)
//            decisionHandler(.cancel)
//            return
//        }
//
//        decisionHandler(.allow)
//    }
}
