//
//  SceneDelegate.swift
//  ChitChat
//
//  Created by Devashish Ghanshani on 15/05/25.
//

import UIKit
import CometChatUIKitSwift
import CometChatSDK

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let appID = "275534e43b994425"
    let region = "in"
    let authKey = "714bd551e086a044b65f78e9030d06cdc69a4974"

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let uikitSettings = UIKitSettings()
            .set(appID: appID)
            .set(region: region)
            .set(authKey: authKey)
            .subscribePresenceForAllUsers()
            .build()

        CometChatUIKit.init(uiKitSettings: uikitSettings) { result in
            switch result {
            case .success:
                print("CometChat Initialized Successfully")
                DispatchQueue.main.async {
                    self.window = UIWindow(windowScene: windowScene)
                    
                    self.configureAppAppearance()
                    
                    let landingVC = LandingVC()
                    let navigationController = UINavigationController(rootViewController: landingVC)
                    self.window?.rootViewController = navigationController
                    self.window?.makeKeyAndVisible()
                }
            case .failure(let error):
                print("CometChat Initialization Failed: \(error.localizedDescription)")
            }
        }
    }
    
    func configureAppAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .systemBlue
        
        UITabBar.appearance().tintColor = .systemBlue
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called when the scene is being released by the system.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called when the scene moves from the background to the foreground.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called when the scene moves from the foreground to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
