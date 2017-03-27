//
//  WCreateUsernameViewController.swift
//  whale-ios
//
//  Created by Jake on 3/26/17.
//  Copyright © 2017 Jake. All rights reserved.
//


import UIKit
import RxCocoa
import RxSwift

class WCreateUsernameViewController: UIViewController {

    enum Section: Int, CaseCountable {
        case title = 0, subtitle, usernameInput
    }
    
    // MARK: - Instance Vars
    
    var viewModel: WCreateUsernameViewModel!
    
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
        
        viewModel.delegate = self
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerKeyboardNotifications()
        
        // reloadData must be called before cellForRow(at:) or cell will be nil
        tableView.reloadData()
        let indexPath = IndexPath(row: 0, section: Section.usernameInput.rawValue)
        if let cell = tableView.cellForRow(at: indexPath) as? WSignUpFlowInputFieldCell {
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
        continueView.setContinueButton(withTitle: "Let's Go")
        continueView.delegate = self
    }
    
    func setupTableView() {
        tableView.backgroundColor = .white
        tableView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        registerCells()
    }
    
    func registerCells() {
        tableView.register(WSignUpFlowTitleCell.w_nib(), forCellReuseIdentifier: WSignUpFlowTitleCell.identifier)
        tableView.register(WSignUpFlowSubtitleCell.w_nib(), forCellReuseIdentifier: WSignUpFlowSubtitleCell.identifier)
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
        _ = self.navigationController?.popViewController(animated: true)
    }
}

extension WCreateUsernameViewController: UITableViewDataSource {
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
            
        case Section.usernameInput.rawValue:
            return usernameInputCell()
            
        default:
            fatalError("Error: Unexpected index in tableView(_:cellForRowAt:)")
        }
    }
}

// MARK: - Custom Cells

extension WCreateUsernameViewController {
    func titleCell() -> WSignUpFlowTitleCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WSignUpFlowTitleCell.identifier) as! WSignUpFlowTitleCell
        cell.titleLabel.text = "Pick a username"
        
        return cell
    }
    
    func subtitleCell() -> WSignUpFlowSubtitleCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WSignUpFlowSubtitleCell.identifier) as! WSignUpFlowSubtitleCell
        cell.subtitleLabel.text = "Your friends can find you with your username."
        
        return cell
    }
    
    func usernameInputCell() -> WSignUpFlowInputFieldCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WSignUpFlowInputFieldCell.identifier) as! WSignUpFlowInputFieldCell
        cell.inputTextField.keyboardType = .twitter
        setupRx(for: cell.inputTextField)
        
        return cell
    }
    
    func setupRx(for textField: UITextField) {
        guard !didSetupRx else {
            return
        }
        
        didSetupRx = true
        
        viewModel.isValidUsernameObservable = textField
            .rx
            .text
            .throttle(0.3, scheduler: MainScheduler.instance)
            .map {
                [unowned self] (username) in
                self.viewModel.validate(username: username!)
            }
        
        viewModel.isValidUsernameObservable
            .subscribe(onNext: {
                [unowned self] (isValidPassword) in
                self.continueView.button(isEnabled: isValidPassword)
            })
            .addDisposableTo(disposeBag)
    }
}

extension WCreateUsernameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case Section.title.rawValue:
            return WSignUpFlowTitleCell.estimatedHeight
        
        case Section.subtitle.rawValue:
            return WSignUpFlowSubtitleCell.estimatedHeight
        
        case Section.usernameInput.rawValue:
            return WSignUpFlowInputFieldCell.estimatedHeight
            
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case Section.usernameInput.rawValue:
            return WSignUpFlowInputFieldCell.height
            
        default:
            return UITableViewAutomaticDimension
        }
    }
}

// MARK: - WSignUpFlowContinueViewDelegate

extension WCreateUsernameViewController: WSignUpFlowContinueViewDelegate {
    func didTap(continueButton: UIButton, on view: WSignUpFlowContinueView) {
        // Prevents user from being created twice.
        guard !continueView.isLoading else {
            return
        }
        
        continueView.isLoading = true
        
        let indexPath = IndexPath(row: 0, section: Section.usernameInput.rawValue)
        if let cell = tableView.cellForRow(at: indexPath) as? WSignUpFlowInputFieldCell,
            let username = cell.inputTextField.text {
            viewModel.createNewUser(witWsername: username)
        }
    }
}

extension WCreateUsernameViewController: WCreateUsernameViewModelDelegate {
    func didCreate(newUser: User) {
        continueView.isLoading = false
        
        let storyboard = UIStoryboard(name: Constants.Storyboard.main, bundle: Bundle.main)
        let initialViewController = storyboard.instantiateInitialViewController()!
        initialViewController.modalTransitionStyle = .flipHorizontal
        
        self.present(initialViewController, animated: true, completion: nil)
    }
    
    func failedToCreateUser(witWsername username: String) {
        continueView.isLoading = false
        
        let alertController = UIAlertController(title: "Username Taken!", message: "\(username) has already been taken. Please try another username.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
