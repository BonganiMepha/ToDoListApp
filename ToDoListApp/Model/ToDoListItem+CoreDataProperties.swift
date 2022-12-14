//
//  ToDoListItem+CoreDataProperties.swift
//  ToDoListApp
//
//  Created by IACD-026 on 2022/08/22.
//
//

import Foundation
import CoreData
import UIKit


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }
    


    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var isComplete: Bool
    @NSManaged public var isArchived: Bool
    @NSManaged public var taskDescription: String?
    @NSManaged public var origin: Category
    @NSManaged public var attachment: Data?
    

}

extension ToDoListItem : Identifiable {

}
