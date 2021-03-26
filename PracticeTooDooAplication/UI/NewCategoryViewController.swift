//
//  NewCategoryViewController.swift
//  PracticeTooDooAplication
//
//  Created by Nikola Jurkovic on 24/03/2021.
//

import Foundation
import UIKit

class NewCategoryViewController: UIViewController {
    
    @IBOutlet var xButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var textField: UITextField!
    
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let category = category {
            textField.placeholder = "To Do"
            textField.autocorrectionType = .no
        } else {
            textField.placeholder = "Category Name"
            textField.autocorrectionType = .no
        }
    }
    
    @IBAction func onXButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSaveButtonTapped() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if let name = textField.text, name.isEmpty == false {
            if let category = category {
                Item.saveItem(context: context, name: name, id: UUID().uuidString, category: category)
            } else {
                Category.insert(context: context, id: UUID().uuidString, name: name)
            }
            dismiss(animated: true, completion: nil)
        } else {
            showError(message: "Something went wrong, please try again.")
        }
        
        
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
