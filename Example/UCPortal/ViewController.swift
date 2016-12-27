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
    
    var username: String { return fieldUser.text ?? noData }
    var password: String { return fieldPassword.text ?? noData }
    var hasData: Bool { return username != noData && password != noData }
    var status: String {
        get { return fieldStatus.text ?? "" }
        set { DispatchQueue.main.async { self.fieldStatus.text = newValue } }
    }
    var macs: String {
        get { return fieldMacs.text ?? "" }
        set { DispatchQueue.main.async { self.fieldMacs.text = newValue } }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var fieldUser: UITextField!
    @IBOutlet weak var fieldPassword: UITextField!
    @IBOutlet weak var fieldStatus: UILabel!
    @IBOutlet weak var fieldMacs: UITextView!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Actions
    
    @IBAction func login(_ sender: AnyObject) {
        let session = UCPSession(username: username, password: password)
        status = "Login..."
        session.login({
            self.status = "Login success"
            self.loadMacs()
            }, failure: { error in
                self.status = error?.error ?? "LOGIN_ERROR"
        })
    }
    
    // MARK: - Functions
    
    func loadMacs() {
        macs = "Loading macs..."
        UCPNetwork(url: UCPURL.macRegistryPrepare, method: .post) { response in
            let html = UCPUtils.string(response) ?? "NONE"
            guard html.contains("Registro WIFI") else { return self.loadMacs() }
            UCPNetwork(url: UCPURL.macRegistryGet, method: .post) { response in
                self.macs = UCPUtils.string(response) ?? "NONE"
            }
        }
    }
    
}
