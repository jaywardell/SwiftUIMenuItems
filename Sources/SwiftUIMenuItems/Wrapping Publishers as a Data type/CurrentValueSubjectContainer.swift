//
//  CurrentValueSubjectContainer.swift
//  CommandsTest
//
//  Created by Joseph Wardell on 12/31/21.
//

import Foundation
import Combine

public final class CurrentValueSubjectContainer<Output: Equatable, Failure: Error>: ObservableObject {
    
    let id = UUID()
    let subject: CurrentValueSubject<Output, Failure>
        
    init(_ subject: CurrentValueSubject<Output, Failure>) {
        self.subject = subject
    }
    
    convenience init(_ startingValue: Output) {
        self.init(CurrentValueSubject<Output, Failure>(startingValue))
    }
    
    /// sends the value newValue to the container's subject on the next pass through the run loop.
    /// This allows the value of the subject to match the value passed in.
    /// Use this, for instance, when a window becomes main, to make sure that the value in a menu matches the value in the content view.
    func update(to newValue: Output) {
        guard newValue != subject.value else { return }
        
        DispatchQueue.main.async {
            self.subject.send(newValue)
        }
    }
}

// MARK: - CurrentValueSubjectContainer: Equatable

extension CurrentValueSubjectContainer: Equatable {
 
    public static func == (lhs: CurrentValueSubjectContainer<Output, Failure>, rhs: CurrentValueSubjectContainer<Output, Failure>) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - CurrentValueSubjectContainer: Hashable

extension CurrentValueSubjectContainer: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
