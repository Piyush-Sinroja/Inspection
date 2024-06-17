//
//  CDCategories+CoreDataProperties.swift
//  Inspection
//
//  Created by Piyush Sinroja on 17/06/24.
//
//

import Foundation
import CoreData


extension CDCategories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCategories> {
        return NSFetchRequest<CDCategories>(entityName: "CDCategories")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var isExpand: Bool
    @NSManaged public var cdSurvey: CDSurvey?
    @NSManaged public var cdQuestions: Set<CDQuestions>?

}

// MARK: Generated accessors for cdQuestions
extension CDCategories {
    
    @objc(addCdQuestionsObject:)
    @NSManaged public func addToCdQuestions(_ value: CDQuestions)
    
    @objc(removeCdQuestionsObject:)
    @NSManaged public func removeFromCdQuestions(_ value: CDQuestions)
    
    @objc(addCdQuestions:)
    @NSManaged public func addToCdQuestions(_ values: Set<CDQuestions>)
    
    @objc(removeCdQuestions:)
    @NSManaged public func removeFromCdQuestions(_ values: Set<CDQuestions>)
}

extension CDCategories : Identifiable {

}
