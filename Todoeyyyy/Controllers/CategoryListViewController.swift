//
//  CategoryListViewController.swift
//  Todoeyyyy
//
//  Created by Mayank Gautam on 19/02/19.
//  Copyright © 2019 Mayank Gautam. All rights reserved.
//

import UIKit
import CoreData

class CategoryListViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories = [Category]()
    var selectedCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].title
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
        performSegue(withIdentifier: "showToDoItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField?
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if let text = textField?.text, !text.isEmpty {
                let category = Category(context: self.context)
                category.title = text
                self.categories.append(category)
                self.saveCategories()
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
    
    func saveCategories(){
        do {
            try context.save()
        } catch {
            print("Error saving Categories \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toDoListController = segue.destination as? ToDoListViewController {
            toDoListController.selectedCategory = selectedCategory
        }
    }

}
