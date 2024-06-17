//
//  InspectionModel.swift
//  Inspection
//
//  Created by Piyush Sinroja on 15/06/24.
//

import Foundation

struct InspectionModel : Codable {
    
    var inspection : Inspection?

    enum CodingKeys: String, CodingKey {
        case inspection = "inspection"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        inspection = try values.decodeIfPresent(Inspection.self, forKey: .inspection)
    }
    
    init(inspection: Inspection?) {
        self.inspection = inspection
    }
}

struct Inspection : Codable {
    
    let area : Area?
    let id : Int?
    let inspectionType : InspectionType?
    var survey : Survey?

    enum CodingKeys: String, CodingKey {

        case area = "area"
        case id = "id"
        case inspectionType = "inspectionType"
        case survey = "survey"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        area = try values.decodeIfPresent(Area.self, forKey: .area)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        inspectionType = try values.decodeIfPresent(InspectionType.self, forKey: .inspectionType)
        survey = try values.decodeIfPresent(Survey.self, forKey: .survey)
    }
    
    init(area: Area?, id: Int?, inspectionType: InspectionType?, survey: Survey?) {
        self.area = area
        self.id = id
        self.inspectionType = inspectionType
        self.survey = survey
    }
}

struct InspectionType : Codable {
    let access : String?
    let id : Int?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case access = "access"
        case id = "id"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        access = try values.decodeIfPresent(String.self, forKey: .access)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
    
    init(access: String?, id: Int?, name: String?) {
        self.access = access
        self.id = id
        self.name = name
    }

}

struct Survey : Codable {
    var categories : [Categories]?
    let id : Int?
    
    enum CodingKeys: String, CodingKey {
        case categories = "categories"
        case id = "id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categories = try values.decodeIfPresent([Categories].self, forKey: .categories)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
    }

    init(id: Int?, categories: [Categories]?) {
        self.id = id
        self.categories = categories
    }
}

struct Area : Codable {
    let id : Int?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
    
    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}

struct Categories : Codable {
    let id : Int?
    let name : String?
    let questions : [Questions]?
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case questions = "questions"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        questions = try values.decodeIfPresent([Questions].self, forKey: .questions)
    }
    
    init(id: Int?, name: String?, questions: [Questions]?) {
        self.id = id
        self.name = name
        self.questions = questions
    }
}

struct Questions : Codable {
    
    let id : Int?
    let name : String?
    let selectedAnswerChoiceId : String?
    let answerChoices : [AnswerChoices]?
    
    enum CodingKeys: String, CodingKey {

        case answerChoices = "answerChoices"
        case id = "id"
        case name = "name"
        case selectedAnswerChoiceId = "selectedAnswerChoiceId"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        answerChoices = try values.decodeIfPresent([AnswerChoices].self, forKey: .answerChoices)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        selectedAnswerChoiceId = try values.decodeIfPresent(String.self, forKey: .selectedAnswerChoiceId)
    }

    init(id: Int?, name: String?, selectedAnswerChoiceId: String?, answerChoices: [AnswerChoices]?) {
        self.id = id
        self.name = name
        self.selectedAnswerChoiceId = selectedAnswerChoiceId
        self.answerChoices = answerChoices
    }
}

struct AnswerChoices : Codable {
    let id : Int?
    let name : String?
    let score : Double?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case score = "score"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        score = try values.decodeIfPresent(Double.self, forKey: .score)
    }
    
    init(id: Int?, name: String?, score: Double?) {
        self.id = id
        self.name = name
        self.score = score
    }
}
