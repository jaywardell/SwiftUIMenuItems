//
//  HostingWindow.swift
//  CommandsTest
//
//  Created by Joseph Wardell on 12/28/21.
//

import SwiftUI

public struct MenuHost<Content: View>: View {
    
    let content: ()->Content
    
    @StateObject private var windowResolver = WindowResolver()
    
    public init(_ content: @escaping ()->Content) {
        self.content = content
    }
    
    public var body: some View {
        content()
            .withHostingWindow {
                windowResolver.windowNumber = $0?.windowNumber
            }
            .onDisappear {
                MenuDispatcher.shared.forget(windowResolver)
            }
            .environmentObject(windowResolver)
            .environmentObject(MenuDispatcher.shared)
            .environmentObject(ToolbarDispatcher.shared)
    }
}





