//
//  MenuActionView.swift
//  CommandsTest
//
//  Created by Joseph Wardell on 1/3/22.
//

import SwiftUI

fileprivate struct MenuActionView: View {
    
    let publisher: PassthroughSubjectContainer<Void, Never>
    let action: ()->()
    
    @EnvironmentObject var windowResolver: WindowResolver
    @EnvironmentObject var menuDispatcher: MenuDispatcher

    var body: some View {
        EmptyView()
            .onReceive(menuDispatcher.getMenuAction(for: publisher, using: windowResolver), perform: action)
//            .onDisappear {
//                menuDispatcher.forget(windowResolver)
//            }
    }
}

// MARK: -

extension View {
    public func onMenuAction(_ publisher:  PassthroughSubjectContainer<Void, Never>, _ action: @escaping ()->()) -> some View {
        self
            .background(MenuActionView(publisher: publisher, action: action))
    }
}
