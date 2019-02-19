//
//  Atomic.swift
//  Atomic
//

import Time

public class Atomic<Element> {
	private var value: Element
	private var lock: Lockable
	
	public init(_ value: Element, _ lock: Lockable = Semaphore(value: 1)) {
		self.value = value
		self.lock = lock
	}
	
	public func set(_ value: Element) {
		self.lock.with(.write) { self.value = value }
	}
	
	public func get() -> Element {
		return self.lock.with(.read) { return self.value }
	}
	
	public func replace(_ value: Element) -> Element {
		return self.lock.with(.write) {
			let oldValue = self.value
			self.value = value
			return oldValue
		}
	}
	
	public func withLock<T>(_ closure: (inout Element) throws -> T) rethrows -> T {
		return try self.lock.with(.write) {
			return try closure(&self.value)
		}
	}
	
	func tryWithLock<T>(_ closure: (inout Element) throws -> T) rethrows -> TimeoutResult<T> {
		return try self.lock.tryWith(.write) {
			return try closure(&self.value)
		}
	}
	
	func tryWithLock<T>(timeout: Timeout,
	                    _ closure: (inout Element) throws -> T) rethrows -> TimeoutResult<T> {
		return try self.lock.tryWith(.write, timeout: timeout) {
			return try closure(&self.value)
		}
	}
	
	func tryWithLock<T>(deadline: Deadline,
	                    _ closure: (inout Element) throws -> T) rethrows -> TimeoutResult<T> {
		return try self.lock.tryWith(.write, deadline: deadline) {
			return try closure(&self.value)
		}
	}
}

extension Atomic {
	@inlinable
	public static func &= <T>(lhs: Atomic<T>, rhs: T) {
		lhs.set(rhs)
	}
	
	@inlinable
	public static func &= <T>(lhs: inout T, rhs: Atomic<T>) {
		lhs = rhs.get()
	}
}
