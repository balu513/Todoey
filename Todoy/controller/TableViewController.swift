//
//  ViewController.swift
//  Todoy
//
//  Created by Balakrishna on 03/02/19.
//  Copyright © 2019 Balakrishna. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

//   var listItemsInUSerDefaults : [String] = ["APple","Grape","Mangoo","Banana","Papay","Mosambi","Sugar cane","Jack fruit","Kiwi","Date shake","Pista","Fruit Mix","Lemon","Watermilon","Clustered Apple","Goa"]
    
//   var listItems : [Item] = [Item(item: "Apple"),Item(item: "Grape"),Item(item: "Mangoo"),Item(item: "Banana"),Item(item: "Papay"),Item(item: "Mosambi"),Item(item: "Sugar cane"),Item(item: "Jack fruit"),Item(item: "Kiwi"),Item(item: "Date shake"),Item(item: "Pista"),Item(item: "Fruit Mix"),Item(item: "Lemon"),Item(item: "Watermilon"),Item(item: "Clustered Apple"),Item(item: "Goa")]
    
    
    var listItems = [Item]()
    
    let KEY : String = "userdefault_key"
    
    var defaults = UserDefaults.standard
    
    let fileDataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("itemdata.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        if let items = defaults.array(forKey: KEY) as? [String]{
//           listItemsInUSerDefaults = items
//        }
       
      
        print("File path : \(String(describing: fileDataPath))")
        
        loadItems()
        
        
    }
    

    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablerowcelltodey", for: indexPath)
        //cell.textLabel?.text = listItemsInUSerDefaults[indexPath.row]
        cell.textLabel?.text = listItems[indexPath.row].itemVal
        cell.accessoryType = listItems[indexPath.row].stat == true ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return listItemsInUSerDefaults.count
        return listItems.count
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "Adding items to TODO", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (uiAlertAction) in
            
            
            self.listItems.append(Item(item: textField.text!))
            
           // self.defaults.set(self.listItemsInUSerDefaults, forKey: self.KEY)
            
            self.saveItems()
            
            self.tableView.reloadData()
        }
        alert.addTextField { (uiTextField) in
            textField = uiTextField
        }
        alert.addAction(action)
        
        self.present(alert,animated: true)
        
        
    }
    
    func saveItems() {
        
        do{
        let data = try PropertyListEncoder().encode(listItems )
            try data.write(to: fileDataPath!)
        }catch{
            print("Error: \(error)")
        }
    }
    
    func loadItems() {
        do{
            let data = try? Data(contentsOf: fileDataPath!)
            listItems = try PropertyListDecoder().decode([Item].self, from: data!)
        }catch{
            print("Error in decode: \(error)")
        }
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        listItems[indexPath.row].stat = !listItems[indexPath.row].stat
        
        saveItems()
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        tableView.reloadData()
        print("Row clicked: \(listItems[indexPath.row])")
    }


}

