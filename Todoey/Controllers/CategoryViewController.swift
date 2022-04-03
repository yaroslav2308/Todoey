//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Yaroslav Monastyrev on 16.03.2022.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()

    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError() }
        
        navBar.backgroundColor = UIColor.white
        navBar.barTintColor = UIColor.white
            
        navBar.tintColor = ContrastColorOf(UIColor.white, returnFlat: true)
        navBar.largeTitleTextAttributes = [.foregroundColor : ContrastColorOf(UIColor.white, returnFlat: true)]
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoye Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { [self] action in
            // what will happen once the user clicks the add button on Ui Alert
            let newCategory = Category()
            
            newCategory.name = textField.text!
            newCategory.hexColorValue = UIColor.randomFlat().hexValue()
            
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
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            if let categoryColour = UIColor(hexString: category.hexColorValue) {
                cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
                cell.backgroundColor = categoryColour
            }
        }
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
