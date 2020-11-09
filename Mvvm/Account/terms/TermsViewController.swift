//
//  TermsViewController.swift
//  Mvvm
//
//  Created by Naim Ali on 3/22/18.
//  Copyright © 2018 Sean Davis. All rights reserved.
//

import UIKit
import WebKit
class TermsViewController: AccountsAbstractController, WKUIDelegate, WKNavigationDelegate {
 
    var webView: WKWebView!

    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var navigationTitle: NavigationLabel!
    
    @IBOutlet weak var goBack: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.backgroundColor = Project.Colors.darkGreen
        
        navigationTitle.textColor = UIColor.white
        
        goBack.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        goBack.isUserInteractionEnabled = true
        
        // loading URL :
        let myBlog = "https://Mvvm.com/app/terms"
        let url = NSURL(string: myBlog)
        let request = URLRequest(url: url! as URL)
        
        // init and load request in webview.
        let frame = CGRect(x:0, y:50, width:view.frame.size.width ,height:view.frame.size.height - 50)
        webView = WKWebView(frame: frame)
        webView.navigationDelegate = self
        webView.load(request)
        self.view.addSubview(webView)
        self.view.sendSubview(toBack: webView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
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
