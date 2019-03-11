//
//  SubjectsTableViewController.swift
//  Todoy
//
//  Created by Balakrishna on 11/03/19.
//  Copyright © 2019 Balakrishna. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class SubjectsTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    var realm = try! Realm()
    
    var subjects : Results<Subject>?

    var selectedBranch : Branch?
    {
        didSet{
            loadSubjects()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        tableView.rowHeight = 80
    }
    @objc func addTapped()
    {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Subject", message: "Add Subject to Colg", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
            
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            
            if let currentbranch = self.selectedBranch{
                do{
                try self.realm.write {
                    let subj = Subject()
                    subj.name = textField.text!
                    subj.createdDate = Date()
                    currentbranch.subjects.append(subj)
                    self.realm.add(subj)
                 }
                }catch{
                    print("error in saving subject: \(error)")
                }
               
            }
            self.tableView.reloadData()
            
        
        
        }
        
        alert.addTextField { (uiTextField) in
            textField = uiTextField
        }
        alert.addAction(action)
        self.present(alert,animated: true)
        
    }
    func loadSubjects() {
        subjects =  selectedBranch?.subjects.sorted(byKeyPath: "createdDate", ascending: false)
    }

    // MARK: - Table view data source

   override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        cell.textLabel?.text = subjects?[indexPath.row].name ?? "No Subjects"
        cell.accessoryType = subjects?[indexPath.row].isDone == true ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let subj = subjects?[indexPath.row]{
            do{
            try realm.write {
                subj.isDone = !subj.isDone
             }
            }catch{
                print("error in updating subj: \(error)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let item = self.subjects?[indexPath.row]
            {
            do{
                try self.realm.write {
                    self.realm.delete(item)
                }
            }catch{
                print("Error in deleting Subject:  \(error)")
            }
                
        }
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}
