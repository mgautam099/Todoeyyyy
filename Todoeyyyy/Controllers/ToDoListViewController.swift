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
    
    let itemFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var itemArray = [Item]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
//        itemArray = decoder.decode([Item], from: itemFilePath)
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
        cell?.accessoryType = itemArray[indexPath.row].isComplete ? .checkmark:.none
        tableView.deselectRow(at: indexPath, animated: true)
        saveData()
    }
    
    //MARK - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // Mark what will happen
            self.itemArray.append(Item(textField.text!))
            self.saveData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: itemFilePath!)
        } catch {
            print("Error saving data \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(){
        
        let decoder = PropertyListDecoder()
        if let data = try? Data(contentsOf: itemFilePath!){
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding data \(error)")
            }
        }
        
    }
}

