//
//  SonosInteractorTests.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 20/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
@testable import RxSonosLib

class SonosInteractorTests: XCTestCase {
    
    func testItCanProvideGroupsInteractor() {
        XCTAssertTrue(type(of: SonosInteractor.provideGroupsInteractor()) == GetGroupsInteractor.self)
    }
    
}