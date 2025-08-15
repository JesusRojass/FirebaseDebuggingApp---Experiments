//
//  SceneDelegate.swift
//  FirebaseDebuggingApp
//
//  Created by jose.valente on 12/08/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(rootViewController: ViewController())
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        NSLog("[PerfRepro] sceneDidBecomeActive")
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        NSLog("[PerfRepro] sceneWillResignActive")
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        NSLog("[PerfRepro] sceneDidEnterBackground")
    }
}
