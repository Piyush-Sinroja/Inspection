//
//  InspectionQuetionsTableViewCell.swift
//  Inspection
//
//  Created by Piyush Sinroja on 15/06/24.
//

import UIKit
import DropDown

class InspectionQuetionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    
    @IBOutlet weak var btnAnsweredSelection: UIButton!
    var dropDown = DropDown()
    
    var didSelectAnswer:((_ choiceId: Int)-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    /// setup view
    func setupView() {
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = .tintColor
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.white
        DropDown.appearance().setupCornerRadius(10)
        answerTextField.setLeftPaddingPoints(10)
        //DropDown.appearance().cellHeight = 60
    }
    
    func setDropDown(dropDown: DropDown, button: UIView, questions: CDQuestions?, textField: UITextField) {
        guard let question = questions else { return }
        
        if let selectedAnswer = question.selectedAnswerChoiceId,
           let first = question.cdAnswerChoices?.first(where: {$0.id == Int16(selectedAnswer)}) {
            answerTextField.text = first.name
        } else {
            answerTextField.text = ""
            answerTextField.placeholder = "Select here"
        }
        
        let dataSource = questions?.cdAnswerChoices?.sorted(by: {$0.id < $1.id}).filter({$0.name != nil})
        dropDown.anchorView = button
        dropDown.bottomOffset = CGPoint(x: 0, y: button.bounds.height)
        //dropDown.width = 200
        dropDown.dataSource = dataSource?.compactMap({$0.name}) ?? []

        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            textField.text = item
            if let dataSource = dataSource {
                didSelectAnswer?((Int(dataSource[index].id)))
            }
            print("Selected item: \(item) at index: \(index)")
        }
    }
    
    
    @IBAction func btnAnsweredSelection(_ sender: Any) {
        dropDown.show()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
