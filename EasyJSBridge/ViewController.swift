//
//  ViewController.swift
//  EasyJSBridge
//
//  Created by Howard on 2019/2/19.
//  Copyright © 2019 Howard. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate {
    var wkWebView: WKWebView!
    var uiWebView: UIWebView!
    var easyJSBridge: EasyJSBridge!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initWKWebView()
        self.initView()
        self.registerBridge()
    }
    
    private func registerBridge() {
        //开启调试日志信息
        EasyJSBridge.enableLogging()
        self.easyJSBridge.registerHandler(handlerName: "test4", handler: { (data, responseCallback) in
            print("Hello App")
        })
        self.easyJSBridge.registerHandler(handlerName: "test5", handler: { (data, responseCallback) in
            print("Hello App:\(data ?? "")")
        })
        
        //注册一个方法供H5调用
        //handlerName:方法名
        //handler:- data:H5传递过来的数据 responseCallback:把处理好的数据返回给H5
        self.easyJSBridge.registerHandler(handlerName: "test6", handler: { (data, responseCallback) in
            print("Hello App:\(data ?? "")")
            responseCallback("123")
        })
    }
    
    private func initUIWebView() {
        self.uiWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        self.view.addSubview(self.uiWebView)
        let filePath = Bundle.main.path(forResource: "index", ofType: "html")
        self.uiWebView.loadHTMLString(try!String(contentsOfFile: filePath!, encoding: String.Encoding.utf8), baseURL:  URL(string: "https://www.test.com")!)
        // UIWebView中注入JSBridge
        self.easyJSBridge = EasyJSBridge.bridgeForUIWebView(webView: self.uiWebView)
        
    }
    
    private func initWKWebView() {
        self.wkWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        self.wkWebView.uiDelegate = self
        self.view.addSubview(self.wkWebView)
        let filePath = Bundle.main.path(forResource: "index", ofType: "html")
        self.wkWebView.loadHTMLString(try!String(contentsOfFile: filePath!, encoding: String.Encoding.utf8), baseURL:  URL(string: "https://www.test.com")!)
        //WKWebView中注入JSBridge
        self.easyJSBridge = EasyJSBridge.bridgeForWKWebView(webView: self.wkWebView)
    }
    
    private func initView() {
        var button = UIButton(type: .custom)
        button.setTitle("调H5方法(无参)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 40)
        button.addTarget(self, action: #selector(buttonAction(button:)), for: .touchUpInside)
        button.backgroundColor = UIColor.red
        button.tag = 1
        self.view.addSubview(button)
        
        button = UIButton(type: .custom)
        button.setTitle("调H5方法(带参)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        button.frame = CGRect(x: 100, y: 150, width: 200, height: 40)
        button.addTarget(self, action: #selector(buttonAction(button:)), for: .touchUpInside)
        button.backgroundColor = UIColor.red
        button.tag = 2
        self.view.addSubview(button)
        
        button = UIButton(type: .custom)
        button.setTitle("调H5方法(带参带H5响应)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        button.frame = CGRect(x: 100, y: 200, width: 200, height: 40)
        button.addTarget(self, action: #selector(buttonAction(button:)), for: .touchUpInside)
        button.backgroundColor = UIColor.red
        button.tag = 3
        self.view.addSubview(button)
    }
    
    @objc func buttonAction(button: UIButton) {
        if button.tag == 1 {
            //调用H5注册好的一个名为test1的方法
            self.easyJSBridge.callHandler(handlerName: "test1")
        } else if button.tag == 2 {
            //调用H5注册好的一个名为test2的方法，带参数
            self.easyJSBridge.callHandler(handlerName: "test2", data: "123")
        } else if button.tag == 3 {
            //调用H5注册好的一个名为test1的方法，带参数，带H5响应回调
            self.easyJSBridge.callHandler(handlerName: "test3", data: "123", responseCallback: { (response) in
                print("收到H5的响应数据:\(response ?? "")")
            })
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

