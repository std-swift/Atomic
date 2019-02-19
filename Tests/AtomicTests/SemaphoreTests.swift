//
//  SemaphoreTests.swift
//  AtomicTests
//

import XCTest
import Atomic
import Dispatch

final class SemaphoreTests: XCTestCase {
	private let queue = DispatchQueue(label: "semaphore queue",
	                                  attributes: .concurrent)
	
	func testLocking() {
		var value = 0
		let valueSem = Semaphore(value: 1)
		let doneSem = Semaphore(value: 0)
		
		valueSem.lock()
		queue.async {
			value = 1
			valueSem.lock()
			value = 2
			valueSem.unlock()
			doneSem.unlock()
		}
		XCTAssertFalse(doneSem.tryLock(timeout: .seconds(1)), "Should not be able to lock doneSem yet")
		XCTAssertEqual(value, 1)
		valueSem.unlock()
		
		doneSem.lock()
		XCTAssertEqual(value, 2)
	}
	
	func testWith() {
		var value = 0
		let valueSem = Semaphore(value: 1)
		let doneSem = Semaphore(value: 0)
		
		valueSem.with {
			queue.async {
				value = 1
				valueSem.with {
					value = 2
				}
				doneSem.unlock()
			}
			XCTAssertFalse(doneSem.tryLock(timeout: .seconds(1)), "Should not be able to lock doneSem yet")
			XCTAssertEqual(value, 1)
		}
		
		doneSem.lock()
		XCTAssertEqual(value, 2)
	}
}
