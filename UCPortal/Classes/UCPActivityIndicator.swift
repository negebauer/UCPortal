//
//  UCPActivityIndicator.swift
//  Pods
//
//  Created by Nicolás Gebauer on 25-12-16.
//
//

#if os(iOS)
    import UIKit
#endif

internal class UCPActivityIndicator {
    
    // MARK: - Constants
    
    static let shared = UCPActivityIndicator()
    
    #if os(iOS)
    let application = UIApplication.shared
    #endif
    
    // MARK: - Variables
    
    var taskCount = 0
    
    #if os(iOS)
    var networkActivityIndicatorVisible: Bool {
        get {
            return application.isNetworkActivityIndicatorVisible
        } set (visible) {
            application.isNetworkActivityIndicatorVisible = visible
        }
    }
    #endif
    
    #if !os(iOS)
    var networkActivityIndicatorVisible = false
    #endif
    
    // MARK: - Init
    
    // MARK: - Functions
    
    func startTask() {
        taskCount += 1
        updateIndicator()
    }
    
    func endTask() {
        guard taskCount > 0 else {
            return print("WARNING: Ending a network task when there a no tasks")
        }
        taskCount -= 1
        updateIndicator()
    }
    
    func updateIndicator() {
        if taskCount > 0 {
            if !networkActivityIndicatorVisible {
                networkActivityIndicatorVisible = !networkActivityIndicatorVisible
            }
        } else if taskCount == 0 {
            if networkActivityIndicatorVisible {
                networkActivityIndicatorVisible = !networkActivityIndicatorVisible
            }
        }
    }
    
}
