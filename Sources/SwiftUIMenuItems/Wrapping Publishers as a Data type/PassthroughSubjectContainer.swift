//
//  PassthroughSubjectContainer.swift
//  CommandsTest
//
//  Created by Joseph Wardell on 12/29/21.
//

import Foundation
import Combine

public struct PassthroughSubjectContainer<Output, Failure: Error> {
    
    let id = UUID()
    let passthroughSubject: PassthroughSubject<Output, Failure>
    
    public init(_ passthroughSubject: PassthroughSubject<Output, Failure>) {
        self.passthroughSubject = passthroughSubject
    }
    
    public init() {
        self.init(PassthroughSubject<Output, Failure>())
    }
}

// MARK: - PassthroughSubjectContainer: Equatable

extension PassthroughSubjectContainer: Equatable {
 
    public static func == (lhs: PassthroughSubjectContainer<Output, Failure>, rhs: PassthroughSubjectContainer<Output, Failure>) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - PassthroughSubjectContainer: Hashable

extension PassthroughSubjectContainer: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
