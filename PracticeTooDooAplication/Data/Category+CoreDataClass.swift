//
//  Category+CoreDataClass.swift
//  PracticeTooDooAplication
//
//  Created by Nikola Jurkovic on 24/03/2021.
//

import Foundation
import UIKit
import CoreData


@objc class Category: NSManagedObject {
    
    class func fetchCategories(context: NSManagedObjectContext) -> [Category]? {
        return try? context.fetch(NSFetchRequest<Category>(entityName: "Category"))
    }
    
    class func getEntityDescription(context: NSManagedObjectContext) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: "Category", in: context)!
    }
    
    class func insert(context: NSManagedObjectContext, id: String, name: String) {
        let category = Category(entity: getEntityDescription(context: context), insertInto: context)
        category.id = id
        category.name = name
        try? context.save()
    }
    
    @NSManaged var name: String
    @NSManaged var id: String
}
