import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    var categories = [Category]()
 let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        getCategories()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categorycelldata", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Clicked at \(indexPath.row)")
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("cliking on: \(String(describing: (tableView.indexPathForSelectedRow)))")
    }

    
    @objc func addTapped()
    {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "Add Categories to Todo", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            
            self.saveCategory()
        }
        
        alert.addTextField { (uiTextField) in
            textField = uiTextField
        }
        alert.addAction(action)
        self.present(alert,animated: true)
    
    }
    
    func saveCategory() {
        do{
        try context.save()
        getCategories()
        }catch{
            print("error in saving data")
        }
        
    }
    
    func getCategories() {
        do{
            try self.categories =  context.fetch(Category.fetchRequest())
        }catch{
            
        }
        tableView.reloadData()
    }
}
