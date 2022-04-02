//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Yaroslav Monastyrev on 16.11.2021.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 100.0
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = todoItems?[indexPath.row].title ?? "No Items Added yet"
        
        if let isDone = todoItems?[indexPath.row].done {
            cell.accessoryType = isDone ? .checkmark : .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            
            do {
                try realm.write({
                    item.done = !item.done
                })
            } catch  {
                print("Error updating done variable, \(error)")
            }
            
        }
        
        tableView.reloadData()
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoye Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { [self] action in
            // what will happen once the user clicks the add button on Ui Alert
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write({
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        print(currentCategory.items)
                    })
                } catch {
                    print("Error saving item \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    //MARK: - Delete Item Data Method
    
    override func updateModel(at indexPath: IndexPath) {
        guard let toDeleteItem = self.todoItems?[indexPath.row] else { print("Not able delete unexisting item")
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

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        guard let searchBarText = searchBar.text else {
//            searchBar.placeholder = "Type Something"
//            return
//        }
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}
