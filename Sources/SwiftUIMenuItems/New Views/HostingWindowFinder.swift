//
//  HostingWindowFinder.swift
//  CommandsTest
//
//  Created by Joseph Wardell on 12/30/21.
//

import SwiftUI

struct HostingWindowFinder: NSViewRepresentable {
    var callback: (NSWindow?) -> ()

    
    func makeNSView(context: Context) -> some NSView {
        let view = NSView()
        DispatchQueue.main.async { [weak view] in
            self.callback(view?.window)
        }
        return view
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {}
}

extension View {
    func withHostingWindow(_ callback: @escaping (NSWindow?) -> Void) -> some View {
        self.background(HostingWindowFinder(callback: callback))
    }
}

