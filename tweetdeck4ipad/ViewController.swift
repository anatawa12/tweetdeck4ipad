//
//  ViewController.swift
//  tweetdeck4ipad
//
//  Created by anatawa12 on 2022/05/24.
//
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var webview: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad();

        webview.navigationDelegate = self
        webview.scrollView.isScrollEnabled = false
        webview.configuration.userContentController.addUserScript(WKUserScript(
            source: """
                    (() => {
                      var meta = document.createElement('meta');
                      meta.name = 'viewport';
                      meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
                      var head = document.getElementsByTagName('head')[0];
                      head.appendChild(meta);

                      const style = document.createElement("style");
                      style.innerHTML = `
                      html {
                        --scale: 0.6;
                        transform-origin: top left;
                        transform: scale(var(--scale));
                        width: calc(100% / var(--scale));
                        height: calc(100% / var(--scale));
                      }

                      .js-app-columns-container.app-columns-container {
                        direction: rtl;
                      }

                      .js-app-columns.app-columns>* {
                        direction: ltr;
                      }

                      .tweet-action .icon {
                        font-size: 24px;
                      }
                      `;
                      document.head.append(style)
                    })()
                    """, injectionTime: .atDocumentEnd, forMainFrameOnly: true))
        webview.load(URLRequest(url: URL(string: "https://tweetdeck.twitter.com/")!))
        // login detection: js-signin-ui class
    }


    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        NSLog("decidePolicyFor \(String(describing: navigationAction.request.url))");
        if let url = navigationAction.request.url,
            url.host == "t.co" {
            await UIApplication.shared.open(url)
            return .cancel
        }
        return .allow
    }
}
