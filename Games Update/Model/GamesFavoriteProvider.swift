//
//  GamesFavoriteProvider.swift
//  Games Update
//
//  Created by Muhammad Arif Hidayatulloh on 18/08/20.
//  Copyright © 2020 Ardat Tracode. All rights reserved.
//

import Foundation
import CoreData

class GamesFavoriteProvider{
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteGame")
        
        container.loadPersistentStores { storeDesription, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
    
    func getAllData(completion: @escaping(_ members: [ListGamesModel.DataLists]) -> ()){
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
            do {
                let results = try taskContext.fetch(fetchRequest)
                var members: [ListGamesModel.DataLists] = []
                for result in results {
                    let member = ListGamesModel.DataLists(
                        id: result.value(forKeyPath: "id") as? Int,
                        slug: result.value(forKeyPath: "slug") as? String,
                        name: result.value(forKeyPath: "name") as? String,
                        released: result.value(forKeyPath: "released") as? String,
                        tba: result.value(forKeyPath: "tba") as? Bool,
                        background_image: result.value(forKeyPath: "background_image") as? String,
                        rating: result.value(forKeyPath: "rating") as? Double,
                        rating_top: result.value(forKeyPath: "rating_top") as? Int)
                    
                    members.append(member)
                }
                completion(members)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func getData(_ id: Int, completion: @escaping(_ members: ListGamesModel.DataLists) -> ()){
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            do {
                if let result = try taskContext.fetch(fetchRequest).first{
                    let member = ListGamesModel.DataLists(
                        id: result.value(forKeyPath: "id") as? Int,
                        slug: result.value(forKeyPath: "slug") as? String,
                        name: result.value(forKeyPath: "name") as? String,
                        released: result.value(forKeyPath: "released") as? String,
                        tba: result.value(forKeyPath: "tba") as? Bool,
                        background_image: result.value(forKeyPath: "background_image") as? String,
                        rating: result.value(forKeyPath: "rating") as? Double,
                        rating_top: result.value(forKeyPath: "rating_top") as? Int)
                    completion(member)
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func createData(_ id:Int, _ slug:String, _ name:String, _ released:String, _ tba:Bool, _ background_image:String, _ rating:Double, _ rating_top:Int, completion: @escaping() -> ()){
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: taskContext) {
                let member = NSManagedObject(entity: entity, insertInto: taskContext)
                member.setValue(id, forKeyPath: "id")
                member.setValue(slug, forKeyPath: "slug")
                member.setValue(name, forKeyPath: "name")
                member.setValue(released, forKeyPath: "released")
                member.setValue(tba, forKeyPath: "tba")
                member.setValue(background_image, forKeyPath: "background_image")
                member.setValue(rating, forKeyPath: "rating")
                member.setValue(rating_top, forKeyPath: "rating_top")
                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func deleteData(_ id: Int, completion: @escaping() -> ()){
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult,
                batchDeleteResult.result != nil {
                completion()
            }
        }
    }
}
