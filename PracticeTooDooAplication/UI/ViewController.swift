//
//  ViewController.swift
//  PracticeTooDooAplication
//
//  Created by Nikola Jurkovic on 24/03/2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!

    var categories = [Category]() {
        didSet {
            collectionView.reloadData()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        categories = Category.fetchCategories(context: context) ?? []
    }
    
    
    func moveToCreatingCategoryViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "NewCategoryViewController") as! NewCategoryViewController
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    func moveToItemsViewController(category: Category) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "ItemsViewController") as! ItemsViewController
        viewController.category = category
        navigationController?.pushViewController(viewController, animated: true)
        navigationController?.isNavigationBarHidden = true
        
    }

}

class CreateNewCategoryCell: UICollectionViewCell {
    
    @IBOutlet var createButton: UILabel!
    @IBOutlet var plusImage: UIImageView!
    
   
}

class CategoryCell: UICollectionViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var numberOfTasks: UILabel!
    @IBOutlet var plusImage: UIImageView!
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if categories.isEmpty || indexPath.row == categories.count {
            moveToCreatingCategoryViewController()
        } else {
            let category = categories[indexPath.row]
            moveToItemsViewController(category: category)
        }
        
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        if categories.isEmpty || indexPath.row == categories.count {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "CreateNewCategoryCell", for: indexPath) as! CreateNewCategoryCell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            let item = categories[indexPath.row]
            let itemCount = Item.fetchItems(context: context, category: item)?.count ?? 0
            cell.name.text = item.name
            cell.numberOfTasks.text = "\(itemCount) tasks"
            return cell
        }
    }

    
}


