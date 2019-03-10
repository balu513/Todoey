//
//  DemoTableVC.swift
//  Todoy
//
//  Created by Balakrishna on 05/02/19.
//  Copyright © 2019 Balakrishna. All rights reserved.
//

import UIKit
import CoreData

class DemoTableVC: UITableViewController {

     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var searchBar: UISearchBar!
    
     var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
    
        print("Path is: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)) \n\n\n")
       
        loadAllItems()
        
        searchBar.delegate = self
    }
    // Load items from DB
    func loadAllItems() {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Exception while fetching data: \(error)")
        }
    
        tableView.reloadData()
        
    }
    // Load items from DB
    func loadItems(with searchWord : String) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predictae = NSPredicate.init(format: "title CONTAINS[cd] %@ ", searchWord)
        let sortDescriptor = NSSortDescriptor.init(key: title, ascending: true)
        
        request.predicate = predictae
        request.sortDescriptors = [sortDescriptor]
        
        do{
            itemArray = try context.fetch(request)
            print("Items By SEARCH:  \(itemArray)")
        }catch{
            print("Exception while fetching data: \(error)")
        }
        tableView.reloadData()
        
        
    }
    
    // commit changes into DB  Note: After doing Any CRUD operation we have to Call this to Commit changes into DB
    func saveItemsinDB() {
        
        do{
            try context.save()
            self.tableView.reloadData()
        }catch{
            print("Error while saving Record in Data Model: \(error)")
        }
        
        loadAllItems()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    @objc func addTapped(){
        var textField = UITextField()
                let alert = UIAlertController(title: "Add New Item", message: "Adding items to TODO", preferredStyle: .alert)
        
                let action = UIAlertAction(title: "Add", style: .default) { (uiAlertAction) in
        
                    // Adding new item into Context  (like stagging area)
                    let newItem = Item(context: self.context)
                    newItem.title = textField.text!
                    newItem.done = false
        
                    // Commit changes into DB
                    self.saveItemsinDB()
        
        
                }
                alert.addTextField { (uiTextField) in
                    textField = uiTextField
                }
                alert.addAction(action)
        
                self.present(alert,animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celldata", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        
        //Updating Fiield in stagging area  ie in Context
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //commit changes into DB
        saveItemsinDB()
        //Fetching Results from DB
        loadAllItems()
        
        
        // Delete item in stagging area
        // context.delete(itemArray[indexPath.row])
        // Commit changes into DB
        //saveItems()
        //Fetching from DB
        //loadAllItems()
    }

    
}
extension DemoTableVC  : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        print("Search word: \(String(describing: searchBar.text))")
        
        loadItems(with: searchBar.text!)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text?.count == 0)
        {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder();
            }
            
        }
    }


}
