//
//  LandingVC.swift
//  ChitChat
//
//  Created by Devashish Ghanshani on 15/05/25.
//

import UIKit
import CometChatSDK

class LandingVC: UIViewController {
    
    private let containerView = UIView()
    private let logoImageView = UIImageView()
    private let welcomeLabel = UILabel()
    private let continueButton = UIButton(type: .system)
    
    private let padding: CGFloat = 24
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUIBasedOnLoginStatus()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        logoImageView.image = UIImage(systemName: "bubble.left.and.bubble.right.fill")
        logoImageView.tintColor = .systemBlue
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        welcomeLabel.font = .systemFont(ofSize: 24, weight: .bold)
        welcomeLabel.textAlignment = .center
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        continueButton.backgroundColor = .systemBlue
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        continueButton.layer.cornerRadius = 12
        continueButton.clipsToBounds = true
        continueButton.addTarget(self, action: #selector(continueToChat), for: .touchUpInside)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear
        
        view.addSubview(containerView)
        containerView.addSubview(logoImageView)
        containerView.addSubview(welcomeLabel)
        containerView.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            logoImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            welcomeLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            welcomeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            welcomeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            continueButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
            continueButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            continueButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            continueButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    private func updateUIBasedOnLoginStatus() {
        if let savedUID = UserDefaults.standard.string(forKey: "currentUID") {
            welcomeLabel.text = "Hello, \(savedUID)"
            continueButton.setTitle("Continue to Chat", for: .normal)
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Logout",
                style: .plain,
                target: self,
                action: #selector(handleLogout)
            )
        } else {
            welcomeLabel.text = "Welcome to ChitChat"
            continueButton.setTitle("Get Started", for: .normal)
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc private func handleLogout() {
        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            CometChat.logout(onSuccess: { _ in
                UserDefaults.standard.removeObject(forKey: "currentUID")
                DispatchQueue.main.async {
                    self?.updateUIBasedOnLoginStatus()
                }
            }, onError: { error in
                self?.showAlert(title: "Error", message: error.errorDescription)
            })
        })
        
        present(alert, animated: true)
    }
    
    @objc private func continueToChat() {
        if UserDefaults.standard.string(forKey: "currentUID") != nil {
            let messagesVC = MessagesVC()
            messagesVC.user = User(uid: "supersecureuid-adminpanel-support", name: "Support")
            navigationController?.pushViewController(messagesVC, animated: true)
        } else {
            let authVC = AuthVC()
            navigationController?.pushViewController(authVC, animated: true)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
