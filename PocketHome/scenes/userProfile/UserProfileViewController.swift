//
//  UserProfileViewController.swift
//  PocketHome
//
//  Created by Issam Lanouari on 17/10/2020.
//

import UIKit
import RxSwift
import RxCocoa

class UserProfileViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var birthDateTextfield: UITextField!
    @IBOutlet private weak var cityTextField: UITextField!
    @IBOutlet private weak var postalCodeTextField: UITextField!
    @IBOutlet private weak var streetTextField: UITextField!
    @IBOutlet private weak var streetCodeTextField: UITextField!
    @IBOutlet private weak var countryTextField: UITextField!
    @IBOutlet private weak var saveButton: LocalizedButton!
    
    // MARK: - Properties
    
    private let viewModel: UserProfileViewModel
    private let picker = UIDatePicker()
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    
    init(
        viewModel: UserProfileViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
        addDissmissKeyboardGesture()
        createToolbar()
        setSaveButtonUI()
        setUpBindings()
    }
    
    // MARK: - Private methods
    
    private func showErrorAlert() {
        showErrorAlertController(title:  NSLocalizedString("profile.alert.title", comment: ""), message:  NSLocalizedString("profile.alert.message", comment: ""))
    }
    
    private func setSaveButtonUI() {
        saveButton.backgroundColor = .systemOrange
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = saveButton.bounds.size.height / 4
    }
    
}

// MARK :- Bindings

extension UserProfileViewController {
    
    private func setUpBindings() {
        lastNameTextField.rx.text.orEmpty <-> viewModel.lastName
        firstNameTextField.rx.text.orEmpty <-> viewModel.firstName
        birthDateTextfield.rx.text.orEmpty <-> viewModel.birthDate
        cityTextField.rx.text.orEmpty <-> viewModel.city
        postalCodeTextField.rx.text.orEmpty <-> viewModel.postalCode
        streetTextField.rx.text.orEmpty <-> viewModel.street
        streetCodeTextField.rx.text.orEmpty <-> viewModel.streetCode
        countryTextField.rx.text.orEmpty <-> viewModel.country
        
        saveButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if self.viewModel.firstName.value.isEmpty || self.viewModel.lastName.value.isEmpty {
                self.showErrorAlert()
            } else {
                self.view.endEditing(true)
                self.viewModel.saveProfile()
                self.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
    }
}

// MARK :- Keyboard

extension UserProfileViewController {
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func addDissmissKeyboardGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK :- DatePicker

extension UserProfileViewController {
    func createToolbar() {
        birthDateTextfield.inputView = picker
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    @objc private func datePickerValueChanged() {
        birthDateTextfield.rx.text.onNext(viewModel.dateFormatter.string(from: picker.date))
    }
}
