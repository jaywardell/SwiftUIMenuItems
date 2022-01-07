//
//  HostingWindow.swift
//  CommandsTest
//
//  Created by Joseph Wardell on 12/28/21.
//

import SwiftUI

public struct HostingWindow<Content: View>: View {
    
    let content: ()->Content
    
    @StateObject private var mainWindowResolver = WindowResolver()
    
    public init(_ content: @escaping ()->Content) {
        self.content = content
    }
    
    public var body: some View {
        content()
            .withHostingWindow {
                mainWindowResolver.windowNumber = $0?.windowNumber
            }
            .environmentObject(mainWindowResolver)
            .environmentObject(MenuDispatcher.shared)
            .environmentObject(ToolbarDispatcher.shared)
    }
}





