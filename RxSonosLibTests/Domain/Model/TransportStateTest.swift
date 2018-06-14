//
//  TransportStateTest.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 27/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import XCTest
@testable import RxSonosLib

class TransportStateTest: XCTestCase {
    
    func testItCanParsUnknownString() {
        XCTAssertEqual(TransportState.map(string: "randomstring"), TransportState.stopped)
    }
    
    func testItCanParsePlayingString() {
        XCTAssertEqual(TransportState.map(string: "PLAYING"), TransportState.playing)
    }
    
    func testItCanParsePausedString() {
        XCTAssertEqual(TransportState.map(string: "PAUSED_PLAYBACK"), TransportState.paused)
    }
    
    func testItCanParseStoppedString() {
        XCTAssertEqual(TransportState.map(string: "STOPPED"), TransportState.stopped)
    }
    
    func testItCanParseTransitioningString() {
        XCTAssertEqual(TransportState.map(string: "TRANSITIONING"), TransportState.transitioning)
    }
    
    func testItCanCreateActionStateForPlaying() {
        XCTAssertEqual(TransportState.playing.reverseState(), TransportState.stopped)
    }
    
    func testItCanCreateActionStateForPause() {
        XCTAssertEqual(TransportState.paused.reverseState(), TransportState.playing)
    }
    
    func testItCanCreateActionStateForStopped() {
        XCTAssertEqual(TransportState.stopped.reverseState(), TransportState.playing)
    }
    
    func testItCanCreateActionStateForTransitioning() {
        XCTAssertEqual(TransportState.transitioning.reverseState(), TransportState.transitioning)
    }
}
