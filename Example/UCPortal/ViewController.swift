//
//  ViewController.swift
//  UCPortal
//
//  Created by negebauer on 12/25/2016.
//  Copyright (c) 2016 negebauer. All rights reserved.
//

import UIKit
import UCPortal

class ViewController: UIViewController {
    
    // MARK: - Constants
    
    let noData = "NONE"
    
    // MARK: - Variables
    
    var username: String {
        return fieldUser.text ?? noData
    }
    var password: String {
        return fieldPassword.text ?? noData
    }
    var status: String {
        get { return fieldStatus.text ?? "" }
        set { fieldStatus.text = newValue }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var fieldUser: UITextField!
    @IBOutlet weak var fieldPassword: UITextField!
    @IBOutlet weak var fieldStatus: UILabel!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Actions
    
    @IBAction func login(_ sender: AnyObject) {
        return
        let session = UCPSession(username: username, password: password)
        session.login({
            session.testLogin()
            }, failure: { error in
                print("Failed login")
                print(error)
        })
    }
    
    // MARK: - Functions
    
    func hasData() -> Bool {
        return username != noData && password != noData
    }
    
}
