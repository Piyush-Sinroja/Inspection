//
//  CDInspectionData+CoreDataProperties.swift
//  Inspection
//
//  Created by Piyush Sinroja on 16/06/24.
//
//

import Foundation
import CoreData


extension CDInspectionData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDInspectionData> {
        return NSFetchRequest<CDInspectionData>(entityName: "CDInspectionData")
    }

    @NSManaged public var id: Int16
    @NSManaged public var cdArea: CDArea?
    @NSManaged public var cdSurvey: CDSurvey?
    @NSManaged public var cdInspectionType: CDInspectionType?

}

extension CDInspectionData : Identifiable {

}
