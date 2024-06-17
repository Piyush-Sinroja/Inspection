//
//  CDInspectionType+CoreDataProperties.swift
//  Inspection
//
//  Created by Piyush Sinroja on 16/06/24.
//
//

import Foundation
import CoreData


extension CDInspectionType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDInspectionType> {
        return NSFetchRequest<CDInspectionType>(entityName: "CDInspectionType")
    }

    @NSManaged public var id: Int16
    @NSManaged public var access: String?
    @NSManaged public var name: String?
    @NSManaged public var cdInspectionData: CDInspectionData?

}

extension CDInspectionType : Identifiable {

}
