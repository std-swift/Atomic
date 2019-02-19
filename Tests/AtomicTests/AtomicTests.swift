//
//  AtomicTests.swift
//  AtomicTests
//

import XCTest
import Atomic
import Dispatch

final class AtomicTests: XCTestCase {
	private let queue = DispatchQueue(label: "semaphore queue",
	                                  attributes: .concurrent)
	
	func testAtomicWrite() {
		let atomic = Atomic<Int>(0)
		for _ in 0..<1_000 {
			queue.async {
				atomic.withLock { $0 += 1 }
			}
		}
		queue.sync(flags: .barrier) {}
		XCTAssertEqual(atomic.get(), 1_000)
	}
}
