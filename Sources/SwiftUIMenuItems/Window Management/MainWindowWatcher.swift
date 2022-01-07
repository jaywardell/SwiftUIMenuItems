//
//  MainWindowWatcher.swift
//  CommandsTest
//
//  Created by Joseph Wardell on 12/30/21.
//

import SwiftUI
import Combine


public final class MainWindowWatcher: ObservableObject {
    
    @Published var hasMainWindow = false
        
    private var bag = Set<AnyCancellable>()
    
    static let TimesToUpdate = [
        NSWindow.didBecomeMainNotification,
        NSWindow.didResignMainNotification,
        NSApplication.didFinishRestoringWindowsNotification,
        NSApplication.didFinishLaunchingNotification,
        NSApplication.didBecomeActiveNotification
    ]
    
    static let shared = MainWindowWatcher()
    
    private init() {
        Self.TimesToUpdate.forEach {
            NotificationCenter.default.publisher(for: $0).sink(receiveValue: update)
            .store(in: &bag)
        }
        
        NotificationCenter.default.publisher(for: NSWindow.didBecomeMainNotification).sink(receiveValue: updateMainWindow(notification:))
            .store(in: &bag)
    }
    
    private func update(_ unused: Notification) {
        self.hasMainWindow = nil != NSApp?.mainWindow
    }
    
    private func updateMainWindow(notification: Notification) {
        if notification.name == NSWindow.didBecomeMainNotification {
            if let window = notification.object as? NSWindow  {
                windowBecameMain.send(window.windowNumber)
            }
        }
    }
    
    private let windowBecameMain = CurrentValueSubject<Int?, Never>(nil)
    
    /// create and return a publisher that is triggered whenever
    /// the app sends a NSWindow.didBecomeMainNotification for the window represented by windowResolver
    ///  (or also if the app's current main window IS the one represented by windowResolver when this method is first called.
    func windowBecameMain(_ resolver: WindowResolver) -> AnyPublisher<Void, Never> {
        windowBecameMain
            .removeDuplicates()
            .filter {
                resolver.windowNumber == $0
            }
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    func menuAction<Output>(for subject: PassthroughSubjectContainer<Output, Never>,
                            using resolver: WindowResolver) -> AnyPublisher<Output, Never> {
        subject
            .passthroughSubject
            .filter { _ in
                resolver.isIMainWindow()
            }
            .eraseToAnyPublisher()
    }
    
    func menuAction<Output: Equatable>(for subject: CurrentValueSubjectContainer<Output, Never>,
                            using resolver: WindowResolver) -> AnyPublisher<Output, Never> {
        
        // for whatever reason, removeDupliactes() doesn't really work here,
        // so we have to create a sort of poor-man's removeDuplicates() to avoid infinite loops
        var out = subject.subject.value
        return subject
            .subject
            .removeDuplicates()
            .filter { _ in
                resolver.isIMainWindow()
            }
            .filter{
                $0 != out
            }
            .map { (inpiut: Output) -> Output in
                out = inpiut
                return out
            }
            .eraseToAnyPublisher()
    }

}
