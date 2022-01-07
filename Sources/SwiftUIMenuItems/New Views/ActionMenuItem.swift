//
//  SimpleActionMenuItem.swift
//  CommandsTest
//
//  Created by Joseph Wardell on 12/30/21.
//

import SwiftUI

/// use as a convenience init for menu items that use PassthroughSubjectContainer
public struct ActionMenuItem {
    
    @StateObject var dispatcher = MenuDispatcher.shared
    
    let title: LocalizedStringKey
    let publisher: PassthroughSubjectContainer<Void, Never>
}

// MARK: - ActionMenuItem: View

extension ActionMenuItem: View {
    public var body: some View {
        Button(title, publisher)
        .disabled(!dispatcher.menuIsEnabled(for: publisher))
    }
}

