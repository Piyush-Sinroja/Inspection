//
//  CDAnswerChoices+CoreDataProperties.swift
//  Inspection
//
//  Created by Piyush Sinroja on 17/06/24.
//
//

import Foundation
import CoreData


extension CDAnswerChoices {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDAnswerChoices> {
        return NSFetchRequest<CDAnswerChoices>(entityName: "CDAnswerChoices")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var score: Double
    @NSManaged public var cdQuestions: CDQuestions?

}

extension CDAnswerChoices : Identifiable {

}
