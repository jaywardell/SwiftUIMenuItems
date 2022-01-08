//
//  ChoiceMenuItem.swift
//  
//
//  Created by Joseph Wardell on 1/7/22.
//

import SwiftUI

public struct ChoiceMenuItem<Choice: PickerChoice> {
    
    let title: LocalizedStringKey
    let publisher: CurrentValueSubjectContainer<Choice, Never>

    let value: Choice
    @State private var isOn: Bool

    @StateObject var dispatcher = MenuDispatcher.shared

    public init(title: LocalizedStringKey,
                subject: CurrentValueSubjectContainer<Choice, Never>, value: Choice) {
        self.title = title
        self.publisher = subject
        self.value = value
        self._isOn = State(initialValue: value == subject.subject.value)
    }
}

// MARK: - ChoiceMenuItem: View

extension ChoiceMenuItem: View {
    public var body: some View {
        Toggle(title, isOn: $isOn)
            .onChange(of: isOn) {
                if $0 == true {
                    publisher.subject.send(value)
                }
            }
            .onReceive(publisher.subject) {
                isOn = ($0 == value)
            }
            .disabled(!dispatcher.menuIsEnabled(for: publisher))
    }
}

