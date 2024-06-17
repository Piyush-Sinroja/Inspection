//
//  HomeViewModel.swift
//  Inspection
//
//  Created by Piyush Sinroja on 15/06/24.
//

import UIKit

class HomeViewModel {
    
    var cdInspectionData: CDInspectionData?
    
    // MARK: - API Call
    
    private let inspectionDataRepository : InspectionDataRepository = InspectionDataRepository()
    
    /// core data category
    private var cdCategories: [CDCategories]? {
        guard let cdCategories = cdInspectionData?.cdSurvey?.cdCategories else { return nil }
        return Array(cdCategories.sorted(by: {$0.id < $1.id}))
    }
    
    /// get inspection api
    /// - Parameters:
    ///   - success: success handler
    ///   - failure: fail handler with error string
    func getInspectionApi(success: @escaping () -> Void, failure: @escaping (_ errorStr: String) -> Void) {
    
        inspectionDataRepository.getCDInspectionData { [weak self] response in
            if(response != nil) {
                self?.cdInspectionData = response
                success()
            } else {
                AlamofireApiService.shared().requestFor(modelType: InspectionModel.self, apiType: ApiTypeConfiguration.getInspection, param: nil) { [weak self] response in
                    switch response {
                    case .success(let data):
                        guard let data = data,
                              let inspection = data.inspection else {
                            success()
                            return
                        }
                        self?.inspectionDataRepository.insertInspection(record: inspection) { [weak self] isInserted in
                            self?.inspectionDataRepository.getCDInspectionData { cdInspectionData in
                                self?.cdInspectionData = cdInspectionData
                                success()
                            }
                        }
                    case .failure(let error):
                        failure(error.localizedDescription)
                    }
                }
            }
        }
    }

    /// submit inspection api
    /// - Parameters:
    ///   - success: success handler
    ///   - failure: fail handler with error string
    func submitInspectionApi(success: @escaping () -> Void, failure: @escaping (_ errorStr: String) -> Void) {
        inspectionDataRepository.getCDInspectionData { [weak self] response in
            if response != nil {
                if let inspection = response?.convertToInspection(),
                   let strModel = try? InspectionModel(inspection: inspection).toJSON(),
                   let param = self?.convertStringToDictionary(text: strModel) {
                    print(param)
                    AlamofireApiService.shared().requestFor(modelType: EmptyEntity.self, apiType: ApiTypeConfiguration.submitInspection, param: param) { [weak self] response in
                        switch response {
                        case .success(_):
                            success()
                        case .failure(let error):
                            failure(error.localizedDescription)
                        }
                    }
                }
            } else {
                failure("Data not found")
            }
        }
    }
    
    /// number of section
    var numberOfSection: Int {
        return cdCategories?.count ?? 0
    }
    
    /// get number of rows from section
    /// - Parameter section: index section in int
    /// - Returns: rows count
    func getNumberOfRows(section: Int) -> Int {
        guard let cdCategories = cdCategories else { return 0 }
        return cdCategories[section].cdQuestions?.count ?? 0
    }
    
    /// get question core data model
    /// - Parameters:
    ///   - section: index section
    ///   - row: row value
    /// - Returns: core data questiion nsmanaged object model
    func getQuestion(section: Int, row: Int) -> CDQuestions? {
        guard let cdCategories = cdCategories else { return nil }
        let category = cdCategories[section]
        guard let questions = category.cdQuestions else { return nil }
        let arrQuestions = Array(questions).sorted(by: {$0.id < $1.id})
        let cdQuestions =  arrQuestions[row]
        return cdQuestions
    }
    
    /// get inspection category
    /// - Returns: array of CDCategories nsmanaged object model
    func getInspectionCategory() -> [CDCategories]? {
        guard let cdCategories = cdCategories else { return nil }
        return Array(cdCategories)
    }
    
    /// update expand value
    /// - Parameters:
    ///   - section: index section
    ///   - isExpand: isExpand bool value
    func updateExpand(section: Int, isExpand: Bool) {
        guard let cdCategories = cdCategories else { return }
        let category =  cdCategories[section]
        category.isExpand = isExpand
    }
    
    /// is expanded category from section
    /// - Parameter section: index section value
    /// - Returns: true if expanded otherwise false
    func isExpandedCategory(section: Int) -> Bool {
        guard let cdCategories = cdCategories else { return false }
        let category = cdCategories[section]
        return category.isExpand
    }
    
    /// get inspection score
    /// - Parameter cdCategories: array of CDCategories nsmanaged object models
    /// - Returns: inspection score value
    func getInspectionScore(cdCategories: [CDCategories]?) -> Double {
        // let choiceIDs = cdCategories.compactMap({$0.cdQuestions?.compactMap({$0.selectedAnswerChoiceId})}).flatMap({$0})
        var score: Double = 0
        for category in cdCategories ?? [] {
            for question in category.cdQuestions ?? [] {
                if let selectedChoiceId = question.selectedAnswerChoiceId,
                   !selectedChoiceId.isEmpty {
                    for ans in question.cdAnswerChoices ?? [] {
                        if ans.id == Int16(selectedChoiceId) {
                            score += ans.score
                        }
                    }
                }
            }
        }
        return score
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
}

extension Encodable {
    /// Converting object to postable JSON
    func toJSON(_ encoder: JSONEncoder = JSONEncoder()) throws -> String? {
        let jsonData = try encoder.encode(self)
        guard let result = String(data: jsonData, encoding: .utf8) else { return nil }
        return result
    }
}
