//
//  MenuDispatcher.swift
//  CommandsTest
//
//  Created by Joseph Wardell on 12/29/21.
//

import Foundation
import Combine

final class MenuDispatcher: ObservableObject {
    
    static var shared = MenuDispatcher()
    
    private var bag = Set<AnyCancellable>()
    private init() {
        MainWindowWatcher.shared.objectWillChange.sink { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self?.objectWillChange.send()
            }
        }
        .store(in: &bag)
    }
            
    private var subjects = [WindowResolver: [Any]]()
    
    func getMenuAction<Output>(for publisher: PassthroughSubjectContainer<Output, Never>,
    using resolver: WindowResolver) -> AnyPublisher<Output, Never> {
        
        var subjectsForWindow = subjects[resolver] ?? []
        if let existing = subjectsForWindow.first(where: {
            ($0 as? PassthroughSubjectContainer<Output, Never>) == publisher
        }) as? PassthroughSubjectContainer<Output, Never> {
            return MainWindowWatcher.shared
                .menuAction(for: existing, using: resolver)
                .eraseToAnyPublisher()
        }
        
        subjectsForWindow.append(publisher)
        subjects[resolver] = subjectsForWindow
        
        return MainWindowWatcher.shared
            .menuAction(for: publisher, using: resolver)
            .eraseToAnyPublisher()
    }
    
    func getMenuAction<Output: Equatable>(for publisher: CurrentValueSubjectContainer<Output, Never>,
    using resolver: WindowResolver) -> AnyPublisher<Output, Never> {
        
        var subjectsForWindow = subjects[resolver] ?? []
        if let existing = subjectsForWindow.first(where: {
            ($0 as? CurrentValueSubjectContainer<Output, Never>) == publisher
        }) as? CurrentValueSubjectContainer<Output, Never> {
            return MainWindowWatcher.shared
                .menuAction(for: existing, using: resolver)
                .eraseToAnyPublisher()
        }
        
        subjectsForWindow.append(publisher)
        subjects[resolver] = subjectsForWindow
        
        return MainWindowWatcher.shared
            .menuAction(for: publisher, using: resolver)
            .eraseToAnyPublisher()
    }

    func forget(_ resolver: WindowResolver) {
        subjects[resolver] = nil
    }
    
    func menuIsEnabled<Output>(for publisher: PassthroughSubjectContainer<Output, Never>) -> Bool {
        
        guard let resolver = subjects.keys.first(where: { $0.isIMainWindow() }) else { return false }
        
        let subjectsForWindow = subjects[resolver] ?? []
        guard subjectsForWindow.count > 0 else { return false }
        guard nil != subjectsForWindow.first(where: {
            ($0 as? PassthroughSubjectContainer<Output, Never>) == publisher
        }) as? PassthroughSubjectContainer<Output, Never> else { return false }

        return true
    }

    func menuIsEnabled<Output>(for publisher: CurrentValueSubjectContainer<Output, Never>) -> Bool {
        
        guard let resolver = subjects.keys.first(where: { $0.isIMainWindow() }) else { return false }
        
        let subjectsForWindow = subjects[resolver] ?? []
        guard subjectsForWindow.count > 0 else { return false }
        guard nil != subjectsForWindow.first(where: {
            ($0 as? CurrentValueSubjectContainer<Output, Never>) == publisher
        }) as? CurrentValueSubjectContainer<Output, Never> else { return false }

        return true
    }
}
