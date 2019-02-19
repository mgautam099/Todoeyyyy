//
//  ViewController.swift
//  Todoeyyyy
//
//  Created by Mayank Gautam on 17/02/19.
//  Copyright © 2019 Mayank Gautam. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    let ID_TO_DO_ITEM_CELL = "toDoItemCell"
    
    var items: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        navigationItem.title = selectedCategory?.title
    }

    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ID_TO_DO_ITEM_CELL, for: indexPath)
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark:.none
        }
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let item = items?[indexPath.row] {
            do {
                try self.realm.write {
                    item.done = !item.done
                }
            } catch {
                print(error)
            }
            cell?.accessoryType = item.done ? .checkmark:.none
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let category = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item = Item()
                        item.title = textField.text!
                        category.items.append(item)
                    }
                } catch {
                    print(error)
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadData(){
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

//MARK - Search bar methods
extension ToDoListViewController: UISearchBarDelegate {
    
//    func search(with text: String){
//        items = items.filter {$0.title?.contains(text) ?? false}
//        tableView.reloadData()
////        let request : NSFetchRequest<Item> = Item.fetchRequest()
////        request.predicate = NSPredicate(format: "title CONTAINS %@", text)
////        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
////        loadData(with: request)
//    }
////
////    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
////        search(with: searchBar.text!)
////    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0{
//            loadData()
//        } else{
//            search(with: searchBar.text!)
//        }
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        print("Cancel Button")
//    }
    
}

