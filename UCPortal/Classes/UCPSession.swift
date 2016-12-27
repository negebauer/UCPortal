//
//  UCPSession.swift
//  Pods
//
//  Created by Nicolás Gebauer on 25-12-16.
//
//

import Foundation
import Kanna

private let loginFailed = [
    "The credentials you provided cannot be determined to be authentic",
    "No se puede determinar que las credenciales proporcionadas"
]

/// UCPortal Session
public class UCPSession {
    
    public enum LoginError: Error {
        case badCredentials
        case network(UCPResponse)
        
        public var error: String {
            switch self {
            case .badCredentials:
                return "Credenciales incorrectas"
            case .network(let response):
                return "Red: \(response.error?.localizedDescription ?? "NONE")"
            }
        }
    }
    
    // MARK: - Constants
    
    private let username: String
    private let password: String
    
    // MARK: - Variables
    
    public var cookies: [HTTPCookie] = []
    
    // MARK: - Init
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    // MARK: - Login
    
    public func login(_ success: (() -> Void)? = nil, failure: ((_ error: LoginError?) -> Void)? = nil) {
        UCPNetwork(url: UCPURL.loginCas) { response in
            guard response.error == nil,
                let html = UCPUtils.string(response.data),
                let doc = Kanna.HTML(html: html, encoding: UCPUtils.utf8),
                let form = doc.at_css("#fm1") else { return self.failedRequest(.network(response), failure) }
            let params: [String: String] = [
                "username": self.username,
                "password": self.password,
                "lt": form.at_css("input[name='lt']")?["value"] ?? "",
                "execution": form.at_css("input[name='execution']")?["value"] ?? "",
                "_eventId": form.at_css("input[name='_eventId']")?["value"] ?? "",
                ]
            UCPNetwork(url: UCPURL.loginCas, method: .post, body: params) { response in
                guard response.error == nil else { return self.failedRequest(.network(response), failure) }
                let html = UCPUtils.string(response.data) ?? loginFailed[0]
                for failedMessage in loginFailed {
                    guard !html.contains(failedMessage) else { return self.failedRequest(.badCredentials, failure) }
                }
                success?()
            }
        }
    }
    
    public func logout(success: (() -> Void)? = nil, failure: ((_ error: Error?) -> Void)? = nil) {
        UCPNetwork(url: UCPURL.logoutCas) { response in
            guard response.error == nil else { return self.failedRequest(.network(response), failure) }
            success?()
        }
    }
    
    // MARK: - Functions
    
    private func failedRequest(_ error: LoginError?, _ failure: ((_ error: LoginError?) -> Void)?) {
        failure?(error)
    }
    
}
