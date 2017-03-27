//
//  WSignUpFlowEmailViewController.swift
//  whale-ios
//
//  Created by Jake on 3/22/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WSignUpFlowEmailViewController: UIViewController {

    enum Section: Int, CaseCountable {
        case title = 0, emailInput
    }
    
    // MARK: - Instance Vars
    
    let viewModel = HUSignUpFlowEmailViewModel()
    
    private var isContinueViewFirstConstraint = true
    
    private let tableViewTopInset: CGFloat = 100

    fileprivate let disposeBag = DisposeBag()
    
    fileprivate var didSetupRx = false
    
    // MARK: - Subviews
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var continueView: WSignUpFlowContinueView!
    
    @IBOutlet weak var continueViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerKeyboardNotifications()
        
        // reloadData must be called before cellForRow(at:) or cell will be nil
        tableView.reloadData()
        let indexPath = IndexPath(row: 0, section: Section.emailInput.rawValue)
        if let cell = tableView.cellForRow(at: indexPath) as? WSignUpFlowInputFieldCell {
            cell.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unregisterKeyboardNotifications()
    }
    
    // MARK: - Setup Subviews
    
    private func setupSubviews() {
        backButton.backgroundColor = .clear
        setupTableView()
        setupContinueView()
    }
    
    private func setupContinueView() {
        continueView.setContinueButton(withTitle: "Continue")
        continueView.delegate = self
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .white
        tableView.contentInset = UIEdgeInsets(top: tableViewTopInset, left: 0, bottom: 0, right: 0)
        registerCells()
    }
    
    private func registerCells() {
        tableView.register(WSignUpFlowTitleCell.w_nib(), forCellReuseIdentifier: WSignUpFlowTitleCell.identifier)
        tableView.register(WSignUpFlowInputFieldCell.w_nib(), forCellReuseIdentifier: WSignUpFlowInputFieldCell.identifier)
    }
    
    // MARK: - Register/Unregister Keyboard Notifications
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    private func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Handle Keyboard Notifications
    
    func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = (notification as NSNotification).userInfo,
            let keyboardValue = userInfo[UIKeyboardFrameBeginUserInfoKey]
            else { return }

        let keyboardSize = (keyboardValue as AnyObject).cgRectValue.size
        let keyboardHeight = keyboardSize.height

        continueViewBottomConstraint.constant = keyboardHeight

        let tableViewBottomEdgeInset = keyboardHeight + WSignUpFlowContinueView.height
        tableView.contentInset = UIEdgeInsets(top: tableViewTopInset, left: 0, bottom: tableViewBottomEdgeInset, right: 0)
        
        guard !isContinueViewFirstConstraint else {
            isContinueViewFirstConstraint = false
            return
        }
        
        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        continueViewBottomConstraint.constant = 0
        tableView.contentInset = UIEdgeInsets(top: tableViewTopInset, left: 0, bottom: 0, right: 0)
        
        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
}

extension WSignUpFlowEmailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Section.title.rawValue:
            return titleCell()
            
        case Section.emailInput.rawValue:
            return emailInputCell()
        
        default:
            fatalError()
        }
    }
}

// MARK: - Custom Cells

extension WSignUpFlowEmailViewController {
    func titleCell() -> WSignUpFlowTitleCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WSignUpFlowTitleCell.identifier) as! WSignUpFlowTitleCell
        cell.titleLabel.text = "What's your email?"
        
        return cell
    }
    
    func emailInputCell() -> WSignUpFlowInputFieldCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WSignUpFlowInputFieldCell.identifier) as! WSignUpFlowInputFieldCell
        cell.inputTitleLabel.text = "EMAIL"
        cell.inputTextField.keyboardType = .emailAddress
        setupRx(for: cell.inputTextField)
        
        return cell
    }
    
    // MARK: - Rx
    
    func setupRx(for textField: UITextField) {
        guard !didSetupRx else { return }
        
        didSetupRx = true
        
        viewModel.isValidEmailObservable = textField
            .rx
            .text
            .throttle(0.3, scheduler: MainScheduler.instance)
            .map {
                [unowned self] (email) in
                self.viewModel.validate(email: email!)
        }
        
        viewModel.isValidEmailObservable
            .subscribe(onNext: {
            [unowned self] (isValidEmail) in
                self.continueView.button(isEnabled: isValidEmail)
            })
            .addDisposableTo(disposeBag)
    }
}

// MARK: - UITableViewDelegate

extension WSignUpFlowEmailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case Section.title.rawValue:
            return WSignUpFlowTitleCell.estimatedHeight
            
        case Section.emailInput.rawValue:
            return WSignUpFlowInputFieldCell.estimatedHeight
            
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case Section.emailInput.rawValue:
            return WSignUpFlowInputFieldCell.height
            
        default:
            return UITableViewAutomaticDimension
        }
    }
}

// MARK: - HUSignUpFlowContinueViewDelegate

extension WSignUpFlowEmailViewController: WSignUpFlowContinueViewDelegate {
    func didTap(continueButton: UIButton, on view: WSignUpFlowContinueView) {
        let indexPath = IndexPath(row: 0, section: Section.emailInput.rawValue)
        if let cell = tableView.cellForRow(at: indexPath) as? WSignUpFlowInputFieldCell, let email = cell.inputTextField.text {
            performSegue(withIdentifier: "toCreatePassword", sender: email)
        }

    }
}

// MARK: - Navigation

extension WSignUpFlowEmailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let email = sender as? String, segue.identifier == "toCreatePassword" {
            let destination = segue.destination as! WSignUpFlowPasswordViewController
            destination.viewModel = WSignUpFlowPasswordViewModel(email: email)
        }
    }
}
