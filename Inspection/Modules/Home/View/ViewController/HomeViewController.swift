//
//  HomeViewController.swift
//  Inspection
//
//  Created by Piyush Sinroja on 14/06/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tblViewInspection: UITableView!
    @IBOutlet weak var inspectionScoreLabel: UILabel!
   
    // MARK: - Variables
    
    private let inspectionQuetionReuseIdentifier = "InspectionQuetionsTableViewCell"
    private var homeViewModel = HomeViewModel()
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblViewInspection?.register(UINib(nibName: inspectionQuetionReuseIdentifier, bundle: nil), forCellReuseIdentifier: inspectionQuetionReuseIdentifier)
        tblViewInspection.estimatedRowHeight = 95
        tblViewInspection.rowHeight = UITableView.automaticDimension
        tblViewInspection.sectionHeaderTopPadding = 5
        tblViewInspection.separatorInset = .zero
        callGetInspectionAPI()
    }
    
    /// call get inspection api
    func callGetInspectionAPI() {
        setLoading(true)
        homeViewModel.getInspectionApi(success: { [weak self] in
            self?.setLoading(false)
            print(self?.homeViewModel.cdInspectionData ?? "")
            self?.calculateInspectionScore()
            DispatchQueue.main.async {
                self?.tblViewInspection.reloadData()
            }
        }, failure: { [weak self] errorStr in
            self?.setLoading(false)
            self?.showAlert(message: errorStr, buttonTitle: Constant.Button.okButton)
        })
    }
    
    // MARK: - IBActions
    
    @IBAction func submitButtonAction(_ sender: Any) {
        self.setLoading(true)
        homeViewModel.submitInspectionApi(success: { [weak self] in
            self?.setLoading(false)
            self?.showAlert(message: Messages.HomeScreen.dataUploaded, buttonTitle: Constant.Button.okButton)
        }, failure: { [weak self] errorStr in
            self?.setLoading(false)
            self?.showAlert(message: errorStr, buttonTitle: Constant.Button.okButton)
        })
    }
    
    @IBAction func saveDraftButtonAction(_ sender: Any) {
        PersistentStorage.shared.saveContext(completion: { [weak self] error in
            let message = error == nil ? Messages.HomeScreen.draftSaved : (error?.localizedDescription ?? Messages.HomeScreen.draftNotSaved)
            self?.showAlert(message: message, buttonTitle: Constant.Button.okButton)
        })
    }
    
    // MARK: - Helper Methods
    
    /// calculate inspection score
    func calculateInspectionScore() {
        let score = homeViewModel.getInspectionScore(cdCategories: homeViewModel.getInspectionCategory())
        DispatchQueue.main.async {
            self.inspectionScoreLabel.text = "Inspection Score: \(score)"
        }
    }
    
    /// handle tap gesture
    /// - Parameter sender: A discrete gesture recognizer that interprets single or multiple taps.
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil)  {
        if let viewnew = sender?.view as! HeaderView? {
            print("handleTap", homeViewModel.isExpandedCategory(section: viewnew.tag))
            homeViewModel.updateExpand(section: viewnew.tag, isExpand: !homeViewModel.isExpandedCategory(section: viewnew.tag))
            self.tblViewInspection.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeViewModel.numberOfSection
    }
    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if homeViewModel.isExpandedCategory(section: section) {
            return homeViewModel.getNumberOfRows(section: section)
        } else {
            return 0
        }
    }
    ///
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblViewInspection?.dequeueReusableCell(withIdentifier: inspectionQuetionReuseIdentifier, for: indexPath) as? InspectionQuetionsTableViewCell else { return UITableViewCell() }
        let model = homeViewModel.getQuestion(section: indexPath.section, row: indexPath.row)
        cell.questionLabel.text = model?.name
        cell.setDropDown(dropDown: cell.dropDown, button: cell.btnAnsweredSelection, questions: model, textField: cell.answerTextField)
        cell.didSelectAnswer = { [weak self] choiceId in
            self?.homeViewModel.getQuestion(section: indexPath.section, row: indexPath.row)?.selectedAnswerChoiceId = "\(choiceId)"
            self?.calculateInspectionScore()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate, UIGestureRecognizerDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewnew : HeaderView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)![0] as! HeaderView
        viewnew.tag = section
        
        if let cdCategories =  homeViewModel.getInspectionCategory() {
            let category = cdCategories[cdCategories.index(cdCategories.startIndex, offsetBy: section)]
            viewnew.lblHeader.text = category.name ?? ""
        }
    
        if homeViewModel.isExpandedCategory(section: section) {
            viewnew.imgview.transform = CGAffineTransform(rotationAngle: self.DEGREES_TO_RADIANS(value: 180.0))
        } else {
            viewnew.imgview.transform = CGAffineTransform(rotationAngle: self.DEGREES_TO_RADIANS(value: 0))
        }
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        viewnew.isUserInteractionEnabled = true
        viewnew.addGestureRecognizer(tap)
        return viewnew
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func DEGREES_TO_RADIANS(value: CGFloat) -> CGFloat {
        return ((CGFloat(Double.pi) * value)/180.0)
    }
}
