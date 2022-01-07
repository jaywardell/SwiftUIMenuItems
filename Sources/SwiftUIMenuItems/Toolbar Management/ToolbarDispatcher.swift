//
//  ToolbarDispatcher.swift
//  CommandsTest
//
//  Created by Joseph Wardell on 12/30/21.
//

import Combine

final class ToolbarDispatcher: ObservableObject {
    
    static var shared = ToolbarDispatcher()
    private init() {}

    public func getToolbarAction(for publisher: PassthroughSubjectContainer<WindowResolver, Never>,
    using resolver: WindowResolver) -> AnyPublisher<Void, Never> {

        return publisher
            .passthroughSubject
            .filter { $0 == resolver }
            .map { _ in  }
            .eraseToAnyPublisher()
    }
    
}
