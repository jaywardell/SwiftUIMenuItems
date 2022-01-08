//
//  SimpleToggleMenuItem.swift
//  CommandsTest
//
//  Created by Joseph Wardell on 1/2/22.
//

import SwiftUI

public struct ToggleMenuItem {
    
    let title: LocalizedStringKey
    let publisher: CurrentValueSubjectContainer<Bool, Never>

    @State private var value: Bool

    @StateObject var dispatcher = MenuDispatcher.shared

    public init(title: LocalizedStringKey,
         subject: CurrentValueSubjectContainer<Bool, Never>) {
        self.title = title
        self.publisher = subject
        self._value = State(initialValue: subject.subject.value)
    }
}

// MARK: - ToggleMenuItem: View

extension ToggleMenuItem: View {
    
    public var body: some View {
        // NOTE: this code does produce a log message:
        //  onChange(of: Bool) action tried to update multiple times per frame
        // It seems benign, so I won't worry about it
        return Toggle(title, isOn: $value)
            .onChange(of: value) { newValue in
                publisher.subject.send(newValue)
            }
            .onReceive(publisher.subject) {
                guard value != $0 else { return }
                value = $0
            }
            .disabled(!dispatcher.menuIsEnabled(for: publisher))

    }
}
