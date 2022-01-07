//
//  SimpleChoiceMenuItem.swift
//  CommandsTest
//
//  Created by Joseph Wardell on 12/31/21.
//

import SwiftUI
import Combine

public protocol PickerChoice: CaseIterable, Hashable, CustomStringConvertible {}

// MARK: -

/// use as a convenience init for menu items that use PassthroughSubjectContainer of a CaseIterable
public struct ChoiceSubmenu<Choice: PickerChoice> where Choice.AllCases: RandomAccessCollection {
    
    let title: LocalizedStringKey
    let publisher: CurrentValueSubjectContainer<Choice, Never>
    
    @State private var choice: Choice

    @StateObject var dispatcher = MenuDispatcher.shared

    public init(title: LocalizedStringKey,
         subject: CurrentValueSubjectContainer<Choice, Never>) {
        self.title = title
        self.publisher = subject
        self._choice = State(initialValue: subject.subject.value)
    }
}

// MARK: - ChoiceMenuItem: View

extension ChoiceSubmenu: View {
    public var body: some View {
        Picker(selection: $choice, label: Text(title)) {
            ForEach(Choice.allCases, id: \.self) {
                Text($0.description).tag($0)
            }
        }
        .onChange(of: choice) { newValue in
            publisher.subject.send(newValue)
        }
        .onReceive(publisher.subject, perform: {
            choice = $0
        })
        .disabled(!dispatcher.menuIsEnabled(for: publisher))
    }
}

