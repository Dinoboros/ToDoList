//
//  ViewController.swift
//  ToDoList
//
//  Created by Méryl VALIER on 07/08/2018.
//  Copyright © 2018 Dinoboros. All rights reserved.
//

import UIKit


class TodolistViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Swift"
        newItem.status = false
        itemArray.append(newItem)
        
        if let items = defaults.array(forKey: "TodolistArray") as? [Item] {
            itemArray = items
        }
    }

    //MARK: - Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.status ? .checkmark : .none
        
        return cell
    }

    //MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].status = !itemArray[indexPath.row].status
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - Ajouter des items
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Ajouter une catégorie", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Votre nouvelle catégorie"
            textField = textfield
        }
        
        alert.addAction(UIAlertAction(title: "Ajoutez la catégorie", style: .default, handler: { (action) in
            if textField.text! != "" {
                let newItem = Item()
                newItem.title = textField.text!
                
                self.itemArray.append(newItem)
                
                self.defaults.set(self.itemArray, forKey: "TodolistArray")
                
                self.tableView.reloadData()
            } else {
                print("Champ vide !")
            }
        }))
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
}

