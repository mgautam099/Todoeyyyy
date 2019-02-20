//
//  CategoryListViewController.swift
//  Todoeyyyy
//
//  Created by Mayank Gautam on 19/02/19.
//  Copyright © 2019 Mayank Gautam. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryListViewController: SwipeTableViewController {

    var categories: Results<Category>?
    var selectedCategory: Category?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.updateNavBar(withHexColor: "7A81FF")
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].title
        if let color = UIColor.init(hexString: categories?[indexPath.row].color ?? "7A81FF") {
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            cell.tintColor = ContrastColorOf(color, returnFlat: true)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categories?[indexPath.row]
        performSegue(withIdentifier: "showToDoItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField?
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if let text = textField?.text, !text.isEmpty {
                let category = Category()
                category.title = text
                category.color = UIColor.randomFlat.hexValue()
                self.save(category: category)
            }
            //Todo display error if text empty
        }
        alert.addAction(alertAction)
        alert.addTextField { (categoryTextField) in
            categoryTextField.placeholder = "Create new category"
            textField = categoryTextField
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving Categories \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryToDelete = self.categories?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(categoryToDelete)
                }
            } catch {
                print("Error deleting category: \(error)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toDoListController = segue.destination as? ToDoListViewController {
            toDoListController.selectedCategory = selectedCategory
        }
    }

}
