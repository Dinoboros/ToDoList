//
//  CategorieTableViewController.swift
//  ToDoList
//
//  Created by Méryl VALIER on 08/08/2018.
//  Copyright © 2018 Dinoboros. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategorieTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Ajouter une catégorie", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Votre nouvelle catégorie"
            textField = textfield
        }
        
        alert.addAction(UIAlertAction(title: "Ajoutez la catégorie", style: .default, handler: { (action) in
            if textField.text! != "" {
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.color = UIColor.randomFlat.hexValue()
                newCategory.dateCreated = Date()
                self.save(category: newCategory)
            } else {
                print("Champ vide !")
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        // Configure the cell...
        guard let category = categoryArray?[indexPath.row] else { fatalError() }
        cell.textLabel?.text = category.name
        cell.backgroundColor = UIColor(hexString: (category.color)) ?? UIColor.white
        cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: category.color)!, returnFlat: true)
        
        return cell
    }

    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    
    // MARK: - Manipulation de données
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context : \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        categoryArray = realm.objects(Category.self).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category.items)
                    self.realm.delete(category)
                }
            } catch {
                print("Error delete task, \(error)")
            }
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodolistViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
}









