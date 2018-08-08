//
//  ViewController.swift
//  ToDoList
//
//  Created by Méryl VALIER on 07/08/2018.
//  Copyright © 2018 Dinoboros. All rights reserved.
//

import UIKit
import CoreData

class TodolistViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            
            saveItems()
        }
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
                
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.status = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                
                self.saveItems()
                
            } else {
                print("Champ vide !")
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Manipulation de données
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context : \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context : \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
    
}

//MARK: - Search Bar methods
extension TodolistViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
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

