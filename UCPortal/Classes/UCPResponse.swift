//
//  UCPResponse.swift
//  Pods
//
//  Created by Nicolás Gebauer on 26-12-16.
//
//

import Foundation

public struct UCPResponse {
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    public let data: Data?
    public let response: HTTPURLResponse?
    public let error: Error?
    
    // MARK: - Init
    
    public init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response as? HTTPURLResponse
        self.error = error
    }
    
    // MARK: - Functions
    
}
