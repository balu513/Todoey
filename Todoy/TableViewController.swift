//
//  ViewController.swift
//  Todoy
//
//  Created by Balakrishna on 03/02/19.
//  Copyright © 2019 Balakrishna. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var list : [String] = ["APple","Grape","Mangoo","Banana"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    

    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablerowcelltodey", for: indexPath)
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        print("Row clicked: \(list[indexPath.row])")
    }


}

