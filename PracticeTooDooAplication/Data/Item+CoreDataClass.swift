//
//  Item+CoreDataClass.swift
//  PracticeTooDooAplication
//
//  Created by Nikola Jurkovic on 24/03/2021.
//

import Foundation
import UIKit
import CoreData


@objc class Item: NSManagedObject {
    
    class func fetchItems(context: NSManagedObjectContext, category: Category) -> [Item]? {
        let request = NSFetchRequest<Item>(entityName: "Item")
        request.predicate = NSPredicate(format: "categoryId = %@", category) 
        return try? context.fetch(request)
    }
    
    class func getEntityDescription(context: NSManagedObjectContext) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: "Item", in: context)!
    }
    
    class func saveItem(context: NSManagedObjectContext, name: String, id: String, category: Category) {
        let item = Item(entity: getEntityDescription(context: context), insertInto: context)
        item.name = name
        item.id = id
        item.categoryId = category
        try? context.save()
    }


    @NSManaged var name: String
    @NSManaged var id: String
    @NSManaged var isDone: Bool
    @NSManaged var categoryId: Category

}
