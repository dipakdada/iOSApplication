//
//  TableTableViewController.swift
//  iOSAppplication
//
//  Created by Aress109 on 11/1/23.
//

import UIKit

class TableTableViewController: UITableViewController {
    
    var employeeNames = ["Dipak","Yash","Shivani","Gaurav","Avinash","Vivek","Varun","Rushi","Mahesh"]
    
    // Store Selected Emp Names
    var selectedEmpoyee : [String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Allow multiselection in table first
        tableView.allowsMultipleSelection = true
    }
    
    // This is a Data sources method so we have to implement this method anyway to return the number of section in our Table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //  This is a Data sources method so we have to implement this method anyway to return the number of rows in our Table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return employeeNames.count
    }
    
    //  This method is use to manipulate the data of each cell in Table View and to set the title, deatiltext
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EMPT", for: indexPath)
       
        let bgColorView = UIView()
        bgColorView.backgroundColor = .lightGray
        cell.selectedBackgroundView = bgColorView
        
        cell.textLabel?.text = employeeNames[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEmpoyee[employeeNames[indexPath.row]] = employeeNames[indexPath.row]
        print(selectedEmpoyee.values)
    }
    
    //  Cell selection methods
    // override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //  Alert when selecting any cell in tableview
    //        let alert = UIAlertController(title: "Employee Name", message: "\(employeeNames[indexPath.row])", preferredStyle: .alert)
    //        let action = UIAlertAction(title: "OK", style: .default){ (action) in
    //            self.dismiss(animated: true, completion: nil)
    //        }
    //        alert.addAction(action)
    //        self.present(alert, animated: true)
    //    }
    
    // Cell deselection method
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedEmpoyee.removeValue(forKey: employeeNames[indexPath.row])
        print(selectedEmpoyee.values)
    }
    
}
