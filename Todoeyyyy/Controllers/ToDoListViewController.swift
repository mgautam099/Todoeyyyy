//
//  ViewController.swift
//  Todoeyyyy
//
//  Created by Mayank Gautam on 17/02/19.
//  Copyright © 2019 Mayank Gautam. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    let ID_TO_DO_ITEM_CELL = "toDoItemCell"
    let KEY_TO_DO_LIST = "ToDOList"
    
    var userDefaults = UserDefaults.standard
    var itemArray = [Item]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = userDefaults.array(forKey: KEY_TO_DO_LIST) as? [Item] {
            itemArray = items
        }
        // Do any additional setup after loading the view, typically from a nib.
//        tableView.register(UINib(nibName: "ToDoItemCell", bundle: nil), forCellReuseIdentifier: "toDoItemCell")
    }

    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ID_TO_DO_ITEM_CELL, for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].isComplete ? .checkmark:.none
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        itemArray[indexPath.row].isComplete = !itemArray[indexPath.row].isComplete
        cell.accessoryType = itemArray[indexPath.row].isComplete ? .checkmark:.none
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // Mark what will happen
            self.itemArray.append(Item(textField.text!))
            self.tableView.reloadData()
            self.userDefaults.set(self.itemArray, forKey: self.KEY_TO_DO_LIST)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

