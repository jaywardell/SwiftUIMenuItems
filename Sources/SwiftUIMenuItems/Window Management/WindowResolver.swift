//
//  WindowResolver.swift
//  CommandsTest
//
//  Created by Joseph Wardell on 12/30/21.
//

import AppKit

public final class WindowResolver: ObservableObject  {
    
    let id = UUID()
    
    @Published var mainWindowNumber: Int?
    
    var windowNumber: Int?
    
    func isIMainWindow() -> Bool {
        guard let appMainWindowNumber = NSApp.mainWindow?.windowNumber,
              let windowNumber = self.windowNumber else { return false }
        return appMainWindowNumber == windowNumber
    }
}

extension WindowResolver: Equatable {
    public static func == (lhs: WindowResolver, rhs: WindowResolver) -> Bool {
        lhs.id == rhs.id
    }
}

extension WindowResolver: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
