//
//  MemoryLeakTracking.swift
//  PokemonTests
//
//  Created by Nicolle on 30/03/24.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instances: AnyObject..., file: StaticString = #filePath, line: UInt = #line) {
        instances.forEach { instance in
            addTeardownBlock { [weak instance] in
                XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
            }
        }
    }
}
