//
//  CreateNewItemViewController.swift
//  PracticeTooDooAplication
//
//  Created by Nikola Jurkovic on 25.03.2021..
//

import Foundation
import UIKit

class ItemsViewController: UIViewController {
   
    @IBOutlet var mainView: UIView!
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var categoryName: UILabel!
    @IBOutlet var taskCounter: UILabel!
    
    
    var category: Category?
    var items: [Item] = [] {
        didSet {
            taskCounter.text = "\(items.count) tasks"
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryName.text = category?.name
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
   
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if let category = category {
            items = Item.fetchItems(context: context, category: category) ?? []
        }
       
    }
    
    @IBAction func onBackButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "ViewController") as! ViewController
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func onSettingsButtonTapped() {
        let alert = UIAlertController(title: nil, message: "Settings", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default) { [unowned self] (action) in
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            if let category = self.category {
                for i in items {
                    context.delete(i)
                }
                context.delete(category)
                try? context.save()
                
            }
            navigationController?.popViewController(animated: true)
            
        }
        deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func onPlusButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "NewCategoryViewController") as! NewCategoryViewController
        viewController.modalPresentationStyle = .fullScreen
        viewController.category = category
        present(viewController, animated: true, completion: nil)
    }
    
}

extension ItemsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCell
        let item = items[indexPath.row]
        cell.selectionStyle = .none
        cell.taskDescription.text = item.name
        
        let normalState = UIImage(systemName: "minus")
        let selectedState = UIImage(systemName: "checkmark")
        cell.minPlusButton.setImage(normalState, for: .normal)
        cell.minPlusButton.setImage(selectedState, for: .selected)
        cell.onMinPlusTapped = { [unowned self] in
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            item.isDone = !item.isDone
            cell.minPlusButton.isSelected = item.isDone
            
            if cell.minPlusButton.isSelected == true {
                cell.taskDescription.textColor = .lightGray
            } else {
                cell.taskDescription.textColor = .black
            }
            try? context.save()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if editingStyle == .delete {
            let item = items[indexPath.row]
            context.delete(item)
            try? context.save()
            items.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }

}

class TaskCell: UITableViewCell {
    @IBOutlet var minPlusButton: UIButton!
    @IBOutlet var taskDescription: UILabel!
    
    var onMinPlusTapped: () -> Void = {}
    
    
    
    @IBAction func onClickedMinPlusButton() {
        onMinPlusTapped()
    }
}
