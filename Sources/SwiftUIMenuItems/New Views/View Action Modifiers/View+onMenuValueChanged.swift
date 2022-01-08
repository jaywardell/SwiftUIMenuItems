//
//  MenuValueView.swift
//  CommandsTest
//
//  Created by Joseph Wardell on 1/3/22.
//

import SwiftUI

struct MenuValueView<Value: Equatable>: View {

    @Binding var value: Value
    
    let subject: CurrentValueSubjectContainer<Value, Never>
    let action: (Value)->()
    
    @EnvironmentObject var windowResolver: WindowResolver
    @EnvironmentObject var menuDispatcher: MenuDispatcher

    var body: some View {
        EmptyView()
            .onReceive(MainWindowWatcher.shared.windowBecameMain(windowResolver)) {
                subject.update(to: value)
            }
            .onReceive(menuDispatcher.getMenuAction(for: subject, using: windowResolver)) {
                guard $0 != value else { return }
                value = $0
                action($0)
            }
//            .onDisappear {
//                menuDispatcher.forget(windowResolver)
//            }

    }
}

// MARK: -

extension View {
    public func onMenuValueChanged<Value: Equatable>(_ binding: Binding<Value>, _ subject:  CurrentValueSubjectContainer<Value, Never>, _ action: @escaping (Value)->()) -> some View {
        self
            .background(MenuValueView(value: binding, subject: subject, action: action))
    }
}
