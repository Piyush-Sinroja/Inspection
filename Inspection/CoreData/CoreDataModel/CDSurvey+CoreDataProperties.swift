//
//  CDSurvey+CoreDataProperties.swift
//  Inspection
//
//  Created by Piyush Sinroja on 16/06/24.
//
//

import Foundation
import CoreData


extension CDSurvey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDSurvey> {
        return NSFetchRequest<CDSurvey>(entityName: "CDSurvey")
    }

    @NSManaged public var id: Int16
    @NSManaged public var cdInspectionData: CDInspectionData?
    @NSManaged public var cdCategories: Set<CDCategories>?

}

// MARK: Generated accessors for cdCategories
extension CDSurvey {

    @objc(addCdCategoriesObject:)
    @NSManaged public func addToCdCategories(_ value: CDCategories)

    @objc(removeCdCategoriesObject:)
    @NSManaged public func removeFromCdCategories(_ value: CDCategories)

    @objc(addCdCategories:)
    @NSManaged public func addToCdCategories(_ values: Set<CDCategories>)

    @objc(removeCdCategories:)
    @NSManaged public func removeFromCdCategories(_ values: Set<CDCategories>)

}

extension CDSurvey : Identifiable {

}
