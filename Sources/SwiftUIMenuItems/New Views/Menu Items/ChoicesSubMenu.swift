//
//  ChoicesSubMenu.swift
//  CommandsTest
//
//  Created by Joseph Wardell on 1/6/22.
//

import SwiftUI

public struct ChoicesSubMenu<Choices: RandomAccessCollection> where Choices.Element: Hashable, Choices.Element: CustomStringConvertible {
    
    let title: LocalizedStringKey
    let subject: CurrentValueSubjectContainer<Choices.Element, Never>
    
    let choices: Choices
    @State private var choice: Choices.Element
    
    @StateObject var dispatcher = MenuDispatcher.shared
    
    let descriptionForElement: (Choices.Element)->String
    
    init(title: LocalizedStringKey, choices: Choices, subject: CurrentValueSubjectContainer<Choices.Element, Never>, descriptionForElement: @escaping (Choices.Element)->String) {
        self.title = title
        self.subject = subject
        self.choices = choices
        self.descriptionForElement = descriptionForElement
        self._choice = State(initialValue: subject.subject.value)
    }
}

// MARK: - ChoicesSubMenu where Choices.Element: CustomStringConvertible
public extension ChoicesSubMenu where Choices.Element: CustomStringConvertible {
    init(title: LocalizedStringKey, choices: Choices, subject: CurrentValueSubjectContainer<Choices.Element, Never>) {
        self.init(title: title, choices: choices, subject: subject, descriptionForElement: { $0.description })
    }
}

// MARK: - ChoicesMenuItem: View

extension ChoicesSubMenu: View {

    public var body: some View {
        Picker(selection: $choice, label: Text(title)) {
            ForEach(choices, id: \.self) {
                Text(descriptionForElement($0)).tag($0)
            }
        }
        .onChange(of: choice) { newValue in
            subject.subject.send(newValue)
        }
        .onReceive(subject.subject, perform: {
            choice = $0
        })
        .disabled(!dispatcher.menuIsEnabled(for: subject))
    }
}

