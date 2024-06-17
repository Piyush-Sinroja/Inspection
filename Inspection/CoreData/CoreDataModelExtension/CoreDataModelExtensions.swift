//
//  CoreDataModelExtensions.swift
//  Inspection
//
//  Created by Piyush Sinroja on 17/06/24.
//

import Foundation

extension CDInspectionData {
    func convertToInspection() -> Inspection {
        let area = self.cdArea?.convertToInspection()
        let survey = self.cdSurvey?.convertToSurvey()
        let inspectionType = self.cdInspectionType?.convertToInspectionType()
        return Inspection(area: area, id: Int(self.id), inspectionType: inspectionType, survey: survey)
    }
}

extension CDArea {
    func convertToInspection() -> Area {
        return Area(id: Int(self.id), name: self.name)
    }
}

extension CDSurvey {
    func convertToSurvey() -> Survey {
        var arrCategories: [Categories] = []
        for categories in self.cdCategories ?? [] {
            arrCategories.append(categories.convertToCategories())
        }
        return Survey(id: Int(self.id), categories: arrCategories)
    }
}

extension CDInspectionType {
    func convertToInspectionType() -> InspectionType {
        return InspectionType(access: self.access, id: Int(self.id), name: self.name)
    }
}

extension CDCategories {
    func convertToCategories() -> Categories {
        var arrQuestions: [Questions] = []
        for questions in self.cdQuestions ?? [] {
            arrQuestions.append(questions.convertToQuestions())
        }
        return Categories(id: Int(self.id), name: self.name, questions: arrQuestions)
    }
}

extension CDQuestions {
    func convertToQuestions() -> Questions {
        var arrAnswerChoices: [AnswerChoices] = []
        for answerChoices in self.cdAnswerChoices ?? [] {
            arrAnswerChoices.append(answerChoices.convertToAnswerChoice())
        }
        return Questions(id: Int(self.id), name: self.name, selectedAnswerChoiceId: self.selectedAnswerChoiceId, answerChoices: arrAnswerChoices)
    }
}

extension CDAnswerChoices {
    func convertToAnswerChoice() -> AnswerChoices {
       return AnswerChoices(id: Int(self.id), name: self.name, score: self.score)
    }
}
