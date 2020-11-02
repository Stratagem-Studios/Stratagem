//
//  UserData.swift
//  Stratagem
//
//  Created by 90306997 on 10/26/20.
//


// This will hold top level variables stored in the cloud for the exstence of a users profile

import CloudKit
import Foundation
import CoreData


class UserData: NSManagedObject {
    static func fetchAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [UserData] {
        let request : NSFetchRequest<UserData> = UserData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: “username”, ascending: true)]
        guard let tasks = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return tasks
    }
    
    static func deleteAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        UserData.fetchAll(viewContext: viewContext).forEach({ viewContext.delete($0) })
        try? viewContext.save()
    }
    
}
