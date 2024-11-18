//
//  HomeViewController.swift
//  iOSAppplication
//
//  Created by Aress109 on 10/31/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBAction func goToProfile(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(identifier:"ProfileViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
