//
//  CDArea+CoreDataProperties.swift
//  Inspection
//
//  Created by Piyush Sinroja on 16/06/24.
//
//

import Foundation
import CoreData


extension CDArea {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDArea> {
        return NSFetchRequest<CDArea>(entityName: "CDArea")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var cdInspectionData: CDInspectionData?

}

extension CDArea : Identifiable {

}
