//
//  Task.swift
//  Stratagem
//
//  Created by 90306997 on 10/30/20.
//

import Foundation
import CoreData
class Task: NSManagedObject {
    
    static func fetchAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [Task] {
        let request : NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "taskName", ascending: true)]
        guard let tasks = try? AppDelegate.viewContext.fetch(request) else {
                return []
        }
        return tasks
        }
    
    static func deleteAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        Task.fetchAll(viewContext: viewContext).forEach({ viewContext.delete($0) })
        try? viewContext.save()
    }
    
}
