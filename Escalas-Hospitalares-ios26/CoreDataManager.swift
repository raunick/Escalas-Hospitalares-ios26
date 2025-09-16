//
//  CoreDataManager.swift
//  Escalas-Hospitalares-ios26
//
//  Created by Raunick Vileforte Vieira Generoso on 15/09/25.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EscalasHospitalares")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Save Result
    func saveScaleResult(
        scaleName: String,
        category: String,
        description: String,
        score: Int16,
        totalPoints: Int16,
        interpretation: String,
        parameters: String
    ) {
        let result = ScaleResult(context: context)
        result.id = UUID()
        result.scaleName = scaleName
        result.category = category
        result.descriptionText = description
        result.score = score
        result.totalPoints = totalPoints
        result.interpretation = interpretation
        result.parameters = parameters
        result.date = Date()

        saveContext()
    }

    // MARK: - Fetch Results
    func fetchAllResults() -> [ScaleResult] {
        let fetchRequest: NSFetchRequest<ScaleResult> = ScaleResult.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching results: \(error)")
            return []
        }
    }

    // MARK: - Delete Result
    func deleteResult(_ result: ScaleResult) {
        context.delete(result)
        saveContext()
    }

    // MARK: - Delete All Results
    func deleteAllResults() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ScaleResult.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Error deleting all results: \(error)")
        }
    }

    // MARK: - Save Context
    private func saveContext() {
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}