//
//  CDQuestions+CoreDataProperties.swift
//  Inspection
//
//  Created by Piyush Sinroja on 16/06/24.
//
//

import Foundation
import CoreData


extension CDQuestions {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDQuestions> {
        return NSFetchRequest<CDQuestions>(entityName: "CDQuestions")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var selectedAnswerChoiceId: String?
    @NSManaged public var cdCategories: CDCategories?
    @NSManaged public var cdAnswerChoices: Set<CDAnswerChoices>?

}

// MARK: Generated accessors for cdAnswerChoices
extension CDQuestions {

    @objc(addCdAnswerChoicesObject:)
    @NSManaged public func addToCdAnswerChoices(_ value: CDAnswerChoices)

    @objc(removeCdAnswerChoicesObject:)
    @NSManaged public func removeFromCdAnswerChoices(_ value: CDAnswerChoices)

    @objc(addCdAnswerChoices:)
    @NSManaged public func addToCdAnswerChoices(_ values: Set<CDAnswerChoices>)

    @objc(removeCdAnswerChoices:)
    @NSManaged public func removeFromCdAnswerChoices(_ values: Set<CDAnswerChoices>)

}

extension CDQuestions : Identifiable {

}
