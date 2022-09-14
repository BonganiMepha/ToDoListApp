//
//  Category+CoreDataProperties.swift
//  ToDoListApp
//
//  Created by Pat on 2022/09/08.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var catName: String?
    @NSManaged public var todoListItem: Set<ToDoListItem>

}

// MARK: Generated accessors for todoListItem
extension Category {

    @objc(addTodoListItemObject:)
    @NSManaged public func addToTodoListItem(_ value: ToDoListItem)

    @objc(removeTodoListItemObject:)
    @NSManaged public func removeFromTodoListItem(_ value: ToDoListItem)

    @objc(addTodoListItem:)
    @NSManaged public func addToTodoListItem(_ values: NSSet)

    @objc(removeTodoListItem:)
    @NSManaged public func removeFromTodoListItem(_ values: NSSet)

}

extension Category : Identifiable {

}
