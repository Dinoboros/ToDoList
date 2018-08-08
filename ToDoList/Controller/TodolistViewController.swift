//
//  ViewController.swift
//  ToDoList
//
//  Created by Méryl VALIER on 07/08/2018.
//  Copyright © 2018 Dinoboros. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodolistViewController: SwipeTableViewController {

    let realm = try! Realm()
    var todoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let colorhex = selectedCategory?.color else { fatalError() }
        setNavigationBar(withHexCode: colorhex)
        title = selectedCategory?.name
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setNavigationBar(withHexCode: "76D6FF")
    }
    
    //MARK: - Set Navigation Bar
    func setNavigationBar(withHexCode colorhex: String) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller inconnu")}
        guard let navBarColor = UIColor(hexString: colorhex) else { fatalError()}
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        searchBar.barTintColor = navBarColor
    }
    
    
    //MARK: - Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.status ? .checkmark : .none
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(todoItems!.count))) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                cell.tintColor = ContrastColorOf(color, returnFlat: true)
            }
        } else {
            cell.textLabel?.text = "Pas de tâches ajoutées"
        }
        
        return cell
    }

    
    //MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.status = !item.status
                }
            } catch {
                print("Error update status, \(error)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }

    
    //MARK: - Ajouter des items
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Ajouter une tâche", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Votre nouvelle tâche"
            textField = textfield
        }
        
        alert.addAction(UIAlertAction(title: "Ajoutez la tâche", style: .default, handler: { (action) in
            if textField.text! != "" {
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.status = false
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving tasks, \(error)")
                    }
                }
                self.tableView.reloadData()
                
            } else {
                print("Champ vide !")
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Manipulation de données
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("Error delete task, \(error)")
            }
        }
    }

}


//MARK: - Search Bar methods
extension TodolistViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                self.searchBar.resignFirstResponder()
            }
        }
    }
}

