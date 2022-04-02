//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Yaroslav Monastyrev on 16.03.2022.
//

import UIKit
import RealmSwift
class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()

    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.rowHeight = 100.0
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoye Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { [self] action in
            // what will happen once the user clicks the add button on Ui Alert
            let newCategory = Category()
            
            newCategory.name = textField.text!
            
            save(category: newCategory)
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Table Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath )
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
        return cell
    }
    
    //MARK: - TableView Delegate Method
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categories?[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    //MARK: - Data Munipulatin Methods
    func save(category: Category) {
        
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data Function
    
    override func updateModel(at indexPath: IndexPath) {
        
        guard let toDeleteItem = self.categories?[indexPath.row] else { print("Not able delete unexisting item")
            return}
        do {
            try self.realm.write {
                self.realm.delete(toDeleteItem)
            }
        } catch {
            print("\(error)")
        }
    }
}

//MARK: - Swipe Cell Delegate Methods

//extension CategoryViewController: SwipeTableViewCellDelegate {
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            guard let toDeleteItem = self.categoryArray?[indexPath.row] else { print("Not able delete unexisting item")
//                return}
//            do {
//                try self.realm.write {
//                    self.realm.delete(toDeleteItem)
//                }
//            } catch {
//                print("\(error)")
//            }
//
//        }
//
//        // customize the action appearance
//        deleteAction.image = UIImage(named: "delete-icon")
//
//        return [deleteAction]
//    }
//
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//        return options
//    }
//}

//extension CategoryViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
////
////        guard let searchBarText = searchBar.text else {
////            searchBar.placeholder = "Type Something"
////            return
////        }
//
//        let request: NSFetchRequest<Category> = Category.fetchRequest()
//
//        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//
//        loadCategories(with: request)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadCategories()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//        }
//    }
//}
