//
//  Button+Combine.swift
//  CommandsTest
//
//  Created by Joseph Wardell on 12/30/21.
//

import SwiftUI

extension Button {
    
    public init(_ publisher: PassthroughSubjectContainer<Void, Never>,
                role: ButtonRole? = nil,
                @ViewBuilder label: () -> Label) {
        self.init(role: role,
                  action: { publisher.passthroughSubject.send() },
                  label: label)
    }
    
    
    public init<Output>(
        _ publisher: PassthroughSubjectContainer<Output, Never>,
        role: ButtonRole? = nil,
        value: @escaping ()->Output,
                @ViewBuilder label: () -> Label
    ) {
        self.init(role: role,
                  action: {
            publisher.passthroughSubject.send(value())
        },
             label: label)
    }
    
    public init<Output>(
        _ publisher: PassthroughSubjectContainer<Output, Never>,
        _ output: Output,
        role: ButtonRole? = nil,
       @ViewBuilder label: () -> Label) {
           self.init(publisher, role: role, value: { output }, label: label)
    }
}

// MARK: - Label == Image

extension Button where Label == Image {
    public init(systemImageName: String,
                role: ButtonRole? = nil,
                _ publisher: PassthroughSubjectContainer<Void, Never>) {
        self.init(role: role,
                  action: { publisher.passthroughSubject.send() }) {
            Image(systemName: systemImageName)
        }
    }
    
    public init<Output>(
        systemImageName: String,
        role: ButtonRole? = nil,
        _ publisher: PassthroughSubjectContainer<Output, Never>,
        value: @escaping ()->Output) {
            self.init(publisher, role: role, value: value) {
                Image(systemName: systemImageName)
            }
    }

    public init<Output>(
        systemImageName: String,
        role: ButtonRole? = nil,
        _ publisher: PassthroughSubjectContainer<Output, Never>,
        _ output: Output) {
            self.init(systemImageName: systemImageName, role: role, publisher, value: { output })
    }

}

// MARK: - Label == Text
extension Button where Label == Text {

    public init(_ titleKey: LocalizedStringKey,
                role: ButtonRole? = nil,
                _ publisher: PassthroughSubjectContainer<Void, Never>) {
        self.init(titleKey, role: role, action: {
            publisher.passthroughSubject.send()
        })
    }
    
    public init<Output>(_ titleKey: LocalizedStringKey,
                role: ButtonRole? = nil,
                _ publisher: PassthroughSubjectContainer<Output, Never>,
                value: @escaping ()->Output) {
        self.init(titleKey, role: role, action: {
            publisher.passthroughSubject.send(value())
        })
    }

    public init<Output>(_ titleKey: LocalizedStringKey,
                        role: ButtonRole? = nil,
        _ publisher: PassthroughSubjectContainer<Output, Never>,
        _ output: Output) {
            self.init(titleKey, publisher, value: { output })
    }
}

// MARK: - Label == TupleView<(Text, Image)>

extension Button where Label == TupleView<(Text, Image)> {
    
    /// makes a button that appears as icon and text label in the menu
    public init(
        _ titleKey: LocalizedStringKey,
        systemImageName: String,
        _ publisher: PassthroughSubjectContainer<Void, Never>,
        role: ButtonRole? = nil) {
            self.init(publisher, role: role) {
                Text(titleKey)
                Image(systemName: systemImageName)
            }
        }

    /// makes a button that appears as icon and text label in the menu
    public init<Output>(
        _ titleKey: LocalizedStringKey,
        systemImageName: String,
        _ publisher: PassthroughSubjectContainer<Output, Never>,
        value: @escaping ()->Output,
        role: ButtonRole? = nil) {
            self.init(publisher, role: role, value: value) {
                Text(titleKey)
                Image(systemName: systemImageName)
            }
        }

    /// makes a button that appears as icon and text label in the menu
    public init<Output>(
        _ titleKey: LocalizedStringKey,
        systemImageName: String,
        _ publisher: PassthroughSubjectContainer<Output, Never>,
        output: Output,
        role: ButtonRole? = nil) {
            self.init(titleKey, systemImageName: systemImageName, publisher, value: { output }, role: role)
        }
}
