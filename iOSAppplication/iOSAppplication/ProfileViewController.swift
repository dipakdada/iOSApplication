//
//  ProfileViewController.swift
//  iOSAppplication
//
//  Created by Aress109 on 10/31/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // Redirect to Root View
    @IBAction func goToWelcome(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        
    }
}
