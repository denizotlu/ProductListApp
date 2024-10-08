//
//  SceneDelegate.swift
//  ProductListApp
//
//  Created by Deniz Otlu on 9.09.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let viewController = ViewController()
      //  let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = UINavigationController(rootViewController: ViewController())

       // window.rootViewController = viewController
        self.window = window
        window.makeKeyAndVisible()
        
      

        
    }

  

}

