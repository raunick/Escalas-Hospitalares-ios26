//
//  ScaleResult+CoreDataProperties.swift
//  Escalas-Hospitalares-ios26
//
//  Created by Raunick Vileforte Vieira Generoso on 15/09/25.
//

import Foundation
import CoreData

extension ScaleResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScaleResult> {
        return NSFetchRequest<ScaleResult>(entityName: "ScaleResult")
    }

    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var descriptionText: String?
    @NSManaged public var id: UUID?
    @NSManaged public var interpretation: String?
    @NSManaged public var parameters: String?
    @NSManaged public var score: Int16
    @NSManaged public var scaleName: String?
    @NSManaged public var totalPoints: Int16
}

extension ScaleResult: Identifiable {

}