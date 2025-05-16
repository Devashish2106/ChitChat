//
//  AuthVC.swift
//  ChitChat
//
//  Created by Devashish Ghanshani on 15/05/25.
//

import UIKit
import CometChatSDK

class AuthVC: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let segmentedControl = UISegmentedControl(items: ["Login", "Sign Up"])
    
    private let loginStackView = UIStackView()
    private let loginUIDField = CustomTextField(placeholder: "Email or UID")
    private let loginPasswordField = CustomTextField(placeholder: "Password")
    private let loginButton = CustomButton(title: "Login")
    
    private let signupStackView = UIStackView()
    private let emailField = CustomTextField(placeholder: "Email (used as UID)")
    private let nameField = CustomTextField(placeholder: "Full Name")
    private let passwordField = CustomTextField(placeholder: "Password")
    private let signupButton = CustomButton(title: "Create Account")
    
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private let padding: CGFloat = 24
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupActions()
    }
    
    private func configureUI() {
        title = "Account"
        view.backgroundColor = .systemBackground
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        
        loginPasswordField.isSecureTextEntry = true
        passwordField.isSecureTextEntry = true
        
        loginStackView.axis = .vertical
        loginStackView.spacing = 16
        loginStackView.translatesAutoresizingMaskIntoConstraints = false
        
        signupStackView.axis = .vertical
        signupStackView.spacing = 16
        signupStackView.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        loginStackView.addArrangedSubview(loginUIDField)
        loginStackView.addArrangedSubview(loginPasswordField)
        loginStackView.addArrangedSubview(loginButton)
        
        signupStackView.addArrangedSubview(emailField)
        signupStackView.addArrangedSubview(nameField)
        signupStackView.addArrangedSubview(passwordField)
        signupStackView.addArrangedSubview(signupButton)
        
        signupStackView.isHidden = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(segmentedControl)
        contentView.addSubview(loginStackView)
        contentView.addSubview(signupStackView)
        contentView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            loginStackView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 32),
            loginStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            loginStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            loginStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -padding),
            
            signupStackView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 32),
            signupStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            signupStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            signupStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -padding),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: loginStackView.bottomAnchor, constant: 16)
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupActions() {
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
    }
    
    @objc private func segmentChanged() {
        loginStackView.isHidden = segmentedControl.selectedSegmentIndex != 0
        signupStackView.isHidden = segmentedControl.selectedSegmentIndex != 1
    }
    
    @objc private func handleLogin() {
        guard let uid = loginUIDField.text, !uid.isEmpty else {
            showAlert(title: "Missing UID", message: "Please enter your email or UID.")
            return
        }
        
        guard let password = loginPasswordField.text, !password.isEmpty else {
            showAlert(title: "Missing Password", message: "Please enter your password.")
            return
        }
        
        showLoading(true)
        
        CometChat.login(UID: uid, authKey: "714bd551e086a044b65f78e9030d06cdc69a4974") { [weak self] user in
            UserDefaults.standard.set(uid, forKey: "currentUID")
            self?.showLoading(false)
            DispatchQueue.main.async {
                self?.navigateToChat()
            }
        } onError: { [weak self] error in
            self?.showLoading(false)
            self?.showAlert(title: "Login Error", message: error.errorDescription)
        }
    }
    
    @objc private func handleSignup() {
        guard let email = emailField.text, !email.isEmpty else {
            showAlert(title: "Missing Email", message: "Please enter your email.")
            return
        }
        
        guard let name = nameField.text, !name.isEmpty else {
            showAlert(title: "Missing Name", message: "Please enter your name.")
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            showAlert(title: "Missing Password", message: "Please enter a password.")
            return
        }
        
        showLoading(true)
        
        let user = User(uid: email, name: name)
        CometChat.createUser(user: user, authKey: "714bd551e086a044b65f78e9030d06cdc69a4974") { [weak self] user in
            self?.login(uid: email)
        } onError: { [weak self] error in
            self?.showLoading(false)
            self?.showAlert(title: "Signup Error", message: error?.errorDescription ?? "Unknown error")
        }
    }
    
    private func login(uid: String) {
        CometChat.login(UID: uid, authKey: "714bd551e086a044b65f78e9030d06cdc69a4974") { [weak self] user in
            UserDefaults.standard.set(uid, forKey: "currentUID")
            self?.showLoading(false)
            DispatchQueue.main.async {
                self?.navigateToChat()
            }
        } onError: { [weak self] error in
            self?.showLoading(false)
            self?.showAlert(title: "Login Error", message: error.errorDescription)
        }
    }
    
    private func navigateToChat() {
        let messagesVC = MessagesVC()
        messagesVC.user = User(uid: "supersecureuid-adminpanel-support", name: "Support")
        navigationController?.setViewControllers([LandingVC(), messagesVC], animated: true)
    }
    
    private func showLoading(_ isLoading: Bool) {
        DispatchQueue.main.async { [weak self] in
            if isLoading {
                self?.activityIndicator.startAnimating()
                self?.loginButton.isEnabled = false
                self?.signupButton.isEnabled = false
            } else {
                self?.activityIndicator.stopAnimating()
                self?.loginButton.isEnabled = true
                self?.signupButton.isEnabled = true
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
