//
//  AppDelegate.swift
//  FirebaseDebuggingApp
//
//  Created by jose.valente on 12/08/25.
//

import UIKit
import FirebaseCore
import FirebasePerformance

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Performance.sharedInstance().isInstrumentationEnabled = false
        Performance.sharedInstance().isDataCollectionEnabled = false
        LaunchMetrics.shared.install()
        NSLog("[PerfRepro] didFinishLaunching — appState=\(application.applicationState.rawValue) launchOptions=\(String(describing: launchOptions?.keys))")
        if application.applicationState == .background {
            NSLog("[PerfRepro] Process started in BACKGROUND (BG fetch / silent push). Deferring Perf enablement.")
        }
        return true
    }
    
    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NSLog("[PerfRepro] performFetchWithCompletionHandler invoked")
        LaunchMetrics.shared.noteBackgroundFetch()
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            completionHandler(.noData)
        }
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
