//
//  DataManager.swift
//  TodoList
//
//  Created by Apps4World on 12/18/21.
//

import CoreData
import Foundation

/// Main data manager to handle the todo items
class DataManager: NSObject, ObservableObject {
    /// Dynamic properties that the UI will react to
    @Published var todoItems: [ProductItem] = [ProductItem]()
    
    /// Add the Core Data container with the model name
    let container: NSPersistentContainer = CoreDataStack.shared.persistentContainer
    
    /// Default init method. Load the Core Data container
    override init() {
        super.init()
        container.loadPersistentStores { _, _ in }
        if todoItems.count == 0 {
            fetchAllItems { items in self.todoItems = items }
        }
    }
    
    func fetchAllItems(completion: @escaping (_ items: [ProductItem]) -> Void) {
        let fetchRequest: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
        fetchRequest.fetchLimit = 3
        fetchRequest.predicate = NSPredicate(format: "isSelected == false")
        fetchRequest.sortDescriptors = [//NSSortDescriptor(key: "section", ascending: true),
                                        NSSortDescriptor(key: "order", ascending: true),
                                        NSSortDescriptor(key: "timestamp", ascending: false),
        ]
        if let results = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(fetchRequest) {
            completion(results.compactMap({ entity in
                let model = ProductItem(task: entity.name ?? "")
                model.isCompleted = entity.isSelected
                return model
            }))
        } else {
            completion([])
        }
    }
    
    static func updateStatus(forTask task: String) {
        let fetchRequest: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", task)
        let container = DataManager().container
        if let entity = try? container.viewContext.fetch(fetchRequest).first {
            entity.isSelected = !entity.isSelected
            try? container.viewContext.save()
        }
    }
}
