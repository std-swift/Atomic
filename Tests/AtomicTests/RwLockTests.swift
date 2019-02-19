//
//  RwLockTests.swift
//  AtomicTests
//

import XCTest
import Atomic

final class RwLockTests: XCTestCase {
	private let queue = DispatchQueue(label: "semaphore queue",
	                                  attributes: .concurrent)
	
	func testMultipleReaders() {
		var value = 0
		var reached = false
		let lock = RwLock()
		let stepSem = Semaphore(value: 0)
		let writeSem = Semaphore(value: 1)
		let doneSem = Semaphore(value: 0)
		
		for _ in 0..<10 {
			queue.async {
				lock.with(.read) {
					writeSem.with { value += 1 }
					stepSem.lock()
					writeSem.with { value -= 1 }
					stepSem.unlock()
				}
			}
		}
		queue.async {
			lock.with(.write) {
				reached = true
				doneSem.unlock()
			}
		}
		XCTAssertFalse(doneSem.tryLock(timeout: .seconds(10)), "Should not be able to lock doneSem yet")
		XCTAssertEqual(value, 10)
		XCTAssertFalse(reached)
		
		stepSem.unlock()
		doneSem.lock()
		XCTAssertEqual(value, 0)
		XCTAssertTrue(reached)
	}
	
	func testMultipleWriters() {
		var value = 0
		var reached = false
		let lock = RwLock()
		let stepSem = Semaphore(value: 0)
		let writeSem = Semaphore(value: 1)
		let doneSem = Semaphore(value: 0)
		
		for _ in 0..<10 {
			queue.async {
				lock.with(.write) {
					writeSem.with { value += 1 }
					stepSem.lock()
					writeSem.with {
						value -= 1
						if value == 0 && reached { doneSem.unlock() }
					}
					stepSem.unlock()
				}
			}
		}
		queue.async {
			lock.with(.read) {
				reached = true
				if value == 0 { doneSem.unlock() }
			}
		}
		XCTAssertFalse(doneSem.tryLock(timeout: .seconds(1)), "Should not be able to lock doneSem yet")
		XCTAssertEqual(value, 1)
		XCTAssertFalse(reached)
		
		stepSem.unlock()
		doneSem.lock()
		XCTAssertEqual(value, 0)
		XCTAssertTrue(reached)
	}
}
