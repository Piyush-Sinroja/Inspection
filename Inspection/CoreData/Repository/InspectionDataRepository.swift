//
//  InspectionDataRepository.swift
//  Inspection
//
//  Created by Piyush Sinroja on 16/06/24.
//

import Foundation
import CoreData

protocol InspectionBaseRepository {
    func getCDInspectionData(completionHandler: @escaping(_ cdInspectionData: CDInspectionData?) -> Void)
}

protocol InspectionCoreDataRepository: InspectionBaseRepository {
    func insertInspection(record: Inspection, completiion: @escaping (_ isInserted: Bool) -> Void)
}

struct InspectionDataRepository : InspectionCoreDataRepository {
    
    /// insert inspection record
    /// - Parameters:
    ///   - record: inspection codable model
    ///   - completiion: completion handler
    func insertInspection(record: Inspection, completiion: @escaping (_ isInserted: Bool) -> Void) {

        debugPrint("InspectionCoreDataRepository: Insert record operation is starting")

        PersistentStorage.shared.persistentContainer.performBackgroundTask { privateManagedContext in
            
            let cdInspectionData = CDInspectionData(context: privateManagedContext)
            cdInspectionData.id = Int16(record.id ?? 0)
            
            let cdArea = CDArea(context: privateManagedContext)
            cdArea.id = Int16(record.area?.id ?? 0)
            cdArea.name = record.area?.name
            
            var setCDCategory = Set<CDCategories>()
            
            for category in record.survey?.categories ?? [] {
                let cdCategory = CDCategories(context: privateManagedContext)
                cdCategory.id = Int16(category.id ?? 0)
                cdCategory.name = category.name
                cdCategory.isExpand = true
                
                var arrCDQuestions = Set<CDQuestions>()
                for question in category.questions ?? [] {
                    let cdQuestion = CDQuestions(context: privateManagedContext)
                    cdQuestion.id = Int16(question.id ?? 0)
                    cdQuestion.name = question.name
                    cdQuestion.selectedAnswerChoiceId = question.selectedAnswerChoiceId

                    var arrCDAnswerChoices = Set<CDAnswerChoices>()
                    for answerChoices in question.answerChoices ?? [] {
                        let cdAnswerChoices = createCDAnswerChoices(answerChoices: answerChoices, managedContext: privateManagedContext)
                        arrCDAnswerChoices.insert(cdAnswerChoices)
                    }
                    cdQuestion.cdAnswerChoices = arrCDAnswerChoices
                    arrCDQuestions.insert(cdQuestion)
                }
                cdCategory.cdQuestions = arrCDQuestions
                setCDCategory.insert(cdCategory)
            }
            
            let cdSurvey = createCDSurvey(record: record, setCDCategory: setCDCategory, managedContext: privateManagedContext)
            let cdInspectionType = createCdInspectionType(record: record, managedContext: privateManagedContext)
           
            cdInspectionData.cdArea = cdArea
            cdInspectionData.cdSurvey = cdSurvey
            cdInspectionData.cdInspectionType = cdInspectionType

            if privateManagedContext.hasChanges {
                do {
                    try privateManagedContext.save()
                    completiion(true)
                    debugPrint("InspectionCoreDataRepository: Insert record operation is completed")
                } catch {
                    completiion(false)
                    debugPrint("InspectionCoreDataRepository: Insert record operation failed", error.localizedDescription)
                }
            }
        }
    }
    
    /// create core data answer choice model
    /// - Parameters:
    ///   - answerChoices: answer choice codable object
    ///   - managedContext: An object space to manipulate and track changes to managed objects.
    /// - Returns: core data answer choice nsmanaged object model
    func createCDAnswerChoices(answerChoices: AnswerChoices, managedContext: NSManagedObjectContext) -> CDAnswerChoices {
        let cdAnswerChoices = CDAnswerChoices(context: managedContext)
        cdAnswerChoices.id = Int16(answerChoices.id ?? 0)
        cdAnswerChoices.name = answerChoices.name
        cdAnswerChoices.score = answerChoices.score ?? 0
        return cdAnswerChoices
    }
    
    /// create core data survey  model
    /// - Parameters:
    ///   - record: inspection model
    ///   - setCDCategory: set of core data category model
    ///   - managedContext: An object space to manipulate and track changes to managed objects.
    /// - Returns: core data survey nsmanaged object model
    func createCDSurvey(record: Inspection, setCDCategory: Set<CDCategories>, managedContext: NSManagedObjectContext) -> CDSurvey {
        let cdSurvey = CDSurvey(context: managedContext)
        cdSurvey.id = Int16( record.survey?.id ?? 0)
        cdSurvey.cdCategories = setCDCategory
        return cdSurvey
    }
    
    /// create core data inspection type  model
    /// - Parameters:
    ///   - record: inspection model
    ///   - managedContext: An object space to manipulate and track changes to managed objects.
    /// - Returns: core data inspection type nsmanaged object model
    func createCdInspectionType(record: Inspection, managedContext: NSManagedObjectContext) -> CDInspectionType {
        let cdInspectionType = CDInspectionType(context: managedContext)
        cdInspectionType.id = Int16(record.inspectionType?.id ?? 0)
        cdInspectionType.access = record.inspectionType?.access
        cdInspectionType.name = record.inspectionType?.name
        return cdInspectionType
    }

    /// get core data inspection data
    /// - Parameter completionHandler: comletion handler with core data inspection data nsmanaged object model
    func getCDInspectionData(completionHandler: @escaping(_ cdInspectionData: CDInspectionData?) -> Void) {
        PersistentStorage.shared.printDocumentDirectoryPath()
        if let result = PersistentStorage.shared.fetchManagedObject(managedObject: CDInspectionData.self),
           let first = result.first {
            return completionHandler(first)
        } else {
            completionHandler(nil)
        }
    }
}

