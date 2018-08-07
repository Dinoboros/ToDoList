//
//  ViewController.swift
//  ToDoList
//
//  Created by Méryl VALIER on 07/08/2018.
//  Copyright © 2018 Dinoboros. All rights reserved.
//

import UIKit


class TodolistViewController: UITableViewController {

    var itemArray = ["Learn Swift", "Get an iPhone", "Get a iOS developement job", "Be rich"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK: - Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }

    //MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var checkItem = tableView.cellForRow(at: indexPath)?.accessoryType
        
        if checkItem == .checkmark {
            checkItem = .none
        } else {
            checkItem = .checkmark
        }
        
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
                self.itemArray.append(textField.text!)
                self.tableView.reloadData()
            } else {
                print("Champ vide !")
            }
        }))
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
}

