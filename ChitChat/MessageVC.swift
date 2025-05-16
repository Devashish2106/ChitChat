//
//  ViewController.swift
//  ChitChat
//
//  Created by Devashish Ghanshani on 15/05/25.
//

import UIKit
import CometChatSDK
import CometChatUIKitSwift

/// A view controller that displays a chat interface using CometChat components
class MessagesVC: UIViewController {
    
    // MARK: - Properties
    
    /// The user entity for one-on-one chats
    var user: User?
    
    /// The group entity for group chats
    var group: Group?
    
    // MARK: - UI Components
    
    /// Header view displaying user/group information
    private lazy var headerView: CometChatMessageHeader = {
        let view = CometChatMessageHeader()
        view.translatesAutoresizingMaskIntoConstraints = false
        // Configure for the appropriate conversation type
        if let user = user {
            view.set(user: user)
        } else if let group = group {
            view.set(group: group)
        }
        view.set(controller: self)
        return view
    }()
    
    /// Message input composer view
    private lazy var composerView: CometChatMessageComposer = {
        let composer = CometChatMessageComposer()
        composer.translatesAutoresizingMaskIntoConstraints = false
        // Configure for the appropriate conversation type
        if let user = user {
            composer.set(user: user)
        } else if let group = group {
            composer.set(group: group)
        }
        composer.set(controller: self)
        return composer
    }()
    
    /// List view displaying chat messages
    private lazy var messageListView: CometChatMessageList = {
        let listView = CometChatMessageList()
        listView.translatesAutoresizingMaskIntoConstraints = false
        // Configure for the appropriate conversation type
        if let user = user {
            listView.set(user: user)
        } else if let group = group {
            listView.set(group: group)
        }
        listView.set(controller: self)
        return listView
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Private Methods
    
    /// Configure basic view properties
    private func configureView() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    /// Set up view hierarchy and constraints
    private func setupLayout() {
        // Add subviews to the view hierarchy
        [headerView, messageListView, composerView].forEach { view.addSubview($0) }
        
        // Set up constraints
        NSLayoutConstraint.activate([
            // Header view constraints
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            // Message list view constraints
            messageListView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            messageListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageListView.bottomAnchor.constraint(equalTo: composerView.topAnchor),
            
            // Composer view constraints
            composerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            composerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            composerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
