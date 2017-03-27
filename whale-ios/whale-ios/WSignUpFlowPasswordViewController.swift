//
//  WSignUpFlowPasswordViewController.swift
//  whale-ios
//
//  Created by Jake on 3/22/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WSignUpFlowPasswordViewController: UIViewController {

    enum Section: Int, CaseCountable {
        case title = 0, subtitle, passwordInput
    }
    
    // MARK: - Instance Vars
    
    var viewModel: WSignUpFlowPasswordViewModel!

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
        let indexPath = IndexPath(row: 0, section: Section.passwordInput.rawValue)
        if let cell = tableView.cellForRow(at: indexPath) as? WSignUpFlowPasswordInputCell {
            cell.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unregisterKeyboardNotifications()
    }
    
    // MARK: - Setup Views
    
    private func setupSubviews() {
        backButton.backgroundColor = .clear
        setupTableView()
        setupContinueView()
    }
    
    private func setupContinueView() {
        continueView.setContinueButton(withTitle: "Continue")
        continueView.delegate = self
    }
    
    func setupTableView() {
        tableView.backgroundColor = .white
        tableView.contentInset = UIEdgeInsets(top: tableViewTopInset, left: 0, bottom: 0, right: 0)
        registerCells()
    }
    
    func registerCells() {
        tableView.register(WSignUpFlowTitleCell.w_nib(), forCellReuseIdentifier: WSignUpFlowTitleCell.identifier)
        tableView.register(WSignUpFlowSubtitleCell.w_nib(), forCellReuseIdentifier: WSignUpFlowSubtitleCell.identifier)
        tableView.register(WSignUpFlowPasswordInputCell.w_nib(), forCellReuseIdentifier: WSignUpFlowPasswordInputCell.identifier)
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


extension WSignUpFlowPasswordViewController: UITableViewDataSource {
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
            
        case Section.subtitle.rawValue:
            return subtitleCell()
            
        case Section.passwordInput.rawValue:
            return passwordInputCell()
            
        default:
            fatalError()
        }
    }
}


// MARK: - Custom Cells

extension WSignUpFlowPasswordViewController {
    func titleCell() -> WSignUpFlowTitleCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WSignUpFlowTitleCell.identifier) as! WSignUpFlowTitleCell
        cell.titleLabel.text = "Choose a password"
        
        return cell
    }
    
    func subtitleCell() -> WSignUpFlowSubtitleCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WSignUpFlowSubtitleCell.identifier) as! WSignUpFlowSubtitleCell
        cell.subtitleLabel.text = "Your password must have at least 6 characters."
        
        return cell
    }
    
    
    func passwordInputCell() -> WSignUpFlowPasswordInputCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WSignUpFlowPasswordInputCell.identifier) as! WSignUpFlowPasswordInputCell
        setupRx(for: cell.passwordTextField)
        
        return cell
    }
    
    func setupRx(for textField: UITextField) {
        guard !didSetupRx else { return }
        
        didSetupRx = true
        
        viewModel.isValidPasswordObservable = textField
            .rx
            .text
            .throttle(0.3, scheduler: MainScheduler.instance)
            .map {
                [unowned self] (password) in
                self.viewModel.validate(password: password!)
            }
        
        viewModel.isValidPasswordObservable
            .subscribe(onNext: {
                [unowned self] (isValidPassword) in
                self.continueView.button(isEnabled: isValidPassword)
            })
            .addDisposableTo(disposeBag)
    }
}

// MARK: - UITableViewDelegate

extension WSignUpFlowPasswordViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case Section.title.rawValue:
            return WSignUpFlowTitleCell.estimatedHeight
            
        case Section.subtitle.rawValue:
            return WSignUpFlowSubtitleCell.estimatedHeight
            
        case Section.passwordInput.rawValue:
            return WSignUpFlowPasswordInputCell.estimatedHeight
            
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case Section.passwordInput.rawValue:
            return WSignUpFlowPasswordInputCell.height

        default:
            return UITableViewAutomaticDimension
        }
    }
}

// MARK: - WSignUpFlowContinueViewDelegate

extension WSignUpFlowPasswordViewController: WSignUpFlowContinueViewDelegate {
    func didTap(continueButton: UIButton, on view: WSignUpFlowContinueView) {
        let indexPath = IndexPath(row: 0, section: Section.passwordInput.rawValue)
        if let cell = tableView.cellForRow(at: indexPath) as? WSignUpFlowPasswordInputCell, let password = cell.passwordTextField.text {
            performSegue(withIdentifier: "toPickUsername", sender: password)
        }
    }
}

// MARK: - Navigation

extension WSignUpFlowPasswordViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPickUsername", let password = sender as? String {
            let destination = segue.destination as! WCreateUsernameViewController
            destination.viewModel = WCreateUsernameViewModel(email: viewModel.email, password: password)
        }
    }
}
