
import UIKit
import SwipeCellKit
import RealmSwift
import ChameleonFramework

class BranchTableViewController: SwipebleTableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var branches : Results<Branch>!
    
    var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        loadBranches()
        
    
        
        // Do any additional setup after loading the view.
    }
    @objc func addTapped()
    {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Branch", message: "Add Branch to Colg", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
        
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            let branch = Branch()
            
            branch.name = textField.text!
            
            self.save(branch: branch)
            self.loadBranches()
        }
        
        alert.addTextField { (uiTextField) in
            textField = uiTextField
        }
        alert.addAction(action)
        self.present(alert,animated: true)
        
    }
    
    func save(branch : Branch) {
        
        do{
        try realm.write {
            realm.add(branch)
        }
        }catch{
            print("Error in saving Branch \(error)")
        }
        
    }
    
    func loadBranches() {
        branches = realm.objects(Branch.self)
        tableView.reloadData()
    }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return branches.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "branchCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        cell.textLabel?.text = branches[indexPath.row].name
        cell.backgroundColor = UIColor.randomFlat
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Clicked at row pos: \(indexPath.row)")
        performSegue(withIdentifier: "gotoSubjects", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SubjectsTableViewController
        
        if let indexpath = tableView.indexPathForSelectedRow{
            destinationVC.selectedBranch = branches[indexpath.row]
        }
    }
    override func swipedItem(pos: Int) {
        super.swipedItem(pos: pos)
        print("Swiped item at pos in child class: \(pos)")
    }
}
