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
    "No se puede determinar que las credenciales proporcionadas sean auténticas"
]

/// UCPortal Session
public class UCPSession {
    
    // MARK: - Constants
    
    fileprivate let username: String
    fileprivate let password: String
    
    // MARK: - Variables
    
    var cookies: [HTTPCookie] = []
    
    // MARK: - Init
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    // MARK: - Login
    
    open func login(_ success: (() -> Void)? = nil, failure: ((_ error: Error?) -> Void)? = nil) {
        let login: () -> Void = {
            UCPNetwork(url: UCPURL.loginCas) { (data, response, error) in
                guard error == nil,
                    let html = UCPUtils.string(data),
                    let doc = Kanna.HTML(html: html, encoding: UCPUtils.utf8),
                    let form = doc.at_css("#fm1") else { return self.failedRequest(error, failure) }
                self.addCookies(response!)
                let params: [String: Any] = [
                    "username": self.username,
                    "password": self.password,
                    "lt": form.at_css("input[name='lt']")?["value"] ?? "",
                    "execution": form.at_css("input[name='execution']")?["value"] ?? "",
                    "_eventId": form.at_css("input[name='_eventId']")?["value"] ?? "",
                    ]
                UCPNetwork(url: UCPURL.loginCas, method: .POST, headers: self.headers(), body: params) { (data, response, error) in
                    guard error == nil else { return self.failedRequest(error, failure) }
                    self.addCookies(response!)
                    let html = UCPUtils.string(data) ?? loginFailed[0]
                    for failedMessage in loginFailed {
                        guard !html.contains(failedMessage) else { return self.failedRequest(error, failure) }
                    }
                    success?()
                }
            }
        }
//        logout(success: login, failure: { error in
//            failure?(error)
//        })
        login()
    }
    
    open func logout(success: (() -> Void)? = nil, failure: ((_ error: Error?) -> Void)? = nil) {
        UCPNetwork(url: UCPURL.logoutCas, method: .POST, headers: headers()) { (_, _, error) in
            guard error == nil else { return self.failedRequest(error, failure) }
            success?()
        }
    }
    
    // MARK: - Cookies
    
    public func addCookies(_ response: HTTPURLResponse, domain: String? = nil) {
        print("\nAdd cookies")
        for key in response.allHeaderFields.keys {
            print(key)
            print(response.allHeaderFields[key])
        }
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: response.allHeaderFields as! [String: String],
                                         for: URL(string: UCPURL.domain)!)
        self.cookies.append(contentsOf: cookies)
    }
    
    open func headers() -> [String: String] {
        return HTTPCookie.requestHeaderFields(with: cookies)
    }
    
    // MARK: - Functions
    
    private func failedRequest(_ error: Error?, _ failure: ((_ error: Error?) -> Void)?) {
        failure?(error)
    }
    
    open func testLogin() {
        UCPNetwork(url: "https://portal.uc.cl/", headers: headers()) { (data, response, error) in
            let string = UCPUtils.string(data) ?? ""
            print(string)
        }
    }
    
}


//Alamofire.request(.POST, URL.login, parameters: params, encoding: .URL)
//    .response { (request, response, data, error) in
//        ActivityIndicator.instance.endTask()
//        guard error == nil else {
//            self.errorLogin(error: error)
//            return
//        }
//        let html = self.stringFromData(data)
//        for errorMessage in ResponseContent.loginFailed {
//            if html.containsString(errorMessage) {
//                self.errorLogin("Revisa que ingresaste bien tus credenciales uc e intenta de nuevo")
//                return
//            }
//        }
//        let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(response!.allHeaderFields as! [String: String], forURL: NSURL(string: URL.domain)!)
//        self.cookies.appendContentsOf(cookies)
//        callback?()
//}
