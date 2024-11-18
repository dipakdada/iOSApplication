//
//  WebViewController.swift
//  iOSAppplication
//
//  Created by Aress109 on 11/6/23.
//

import UIKit
import WebKit

class WebViewController: UIViewController,WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://catfact.ninja/fact")!
        
        // default configuration, store cache and cookie in the disk storage and other urlsession can access it
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url) { data, response, error in
            
            // ensure there is no error for this HTTP response
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            
            if data != nil {
                do {
                    
                }catch {
                    
                }
            }
        }
        
        // execute the HTTP request
        task.resume()
    }
    
}

//
//let myURL = URL(string: myUrlStr)
//       var myRequest = URLRequest(url: myURL!)
//       myRequest.httpMethod = "GET"
//       let session = URLSession.shared
//       let myTask =  session.dataTask(with: myURL!){ [self] (data, response, error )in
//           if error == nil {
//               if data != nil {
//                   do {
//                       empolyeeList = try JSONDecoder().decode(Employees.self, from: data!)
//                       print("employees : \(empolyeeList)")
//                       DispatchQueue.main.async {
//                           self.userShareTV.reloadData()
//                       }
//                   }catch let error{
//                       print("Error : \(error)")
//                   }
//               }
//           }
//       }
//       myTask.resume()
