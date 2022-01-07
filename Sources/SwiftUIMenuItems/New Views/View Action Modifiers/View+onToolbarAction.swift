//
//  ToolbarActionView.swift
//  CommandsTest
//
//  Created by Joseph Wardell on 1/3/22.
//

import SwiftUI

fileprivate struct ToolbarActionView: View {
    
    let publisher: PassthroughSubjectContainer<WindowResolver, Never>
    let action: ()->()
    
    @EnvironmentObject var windowResolver: WindowResolver
    @EnvironmentObject var toolbarDispatcher: ToolbarDispatcher

    var body: some View {
        EmptyView()
            .onReceive(toolbarDispatcher.getToolbarAction(for: publisher, using: windowResolver), perform: action)
    }
}

extension View {
    public func onToolbarAction(_ publisher:  PassthroughSubjectContainer<WindowResolver, Never>, _ action: @escaping ()->()) -> some View {
        self
            .background(ToolbarActionView(publisher: publisher, action: action))
    }
}
