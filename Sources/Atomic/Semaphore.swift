//
//  Semaphore.swift
//  Atomic
//

import Dispatch
import Time

public class Semaphore: Lockable {
	private let sem: DispatchSemaphore
	
	public init(value: Int) {
		self.sem = DispatchSemaphore(value: value)
	}
	
	public func unlock(_ intent: LockingIntent) {
		self.sem.signal()
	}
	
	public func lock(_ intent: LockingIntent) {
		self.sem.wait()
	}
	
	public func tryLock(_ intent: LockingIntent, deadline: Deadline) -> Bool {
		switch self.sem.wait(timeout: deadline.dispatchTime) {
			case .success:  return true
			case .timedOut: return false
		}
	}
}

/// Intentless calls
extension Semaphore {
	@inlinable
	public func unlock() {
		self.unlock(.write)
	}
	
	@inlinable
	public func lock() {
		self.lock(.write)
	}
	
	@inlinable
	public func tryLock(deadline: Deadline) -> Bool {
		return self.tryLock(.write, deadline: deadline)
	}
	
	@inlinable
	public func tryLock() -> Bool {
		return self.tryLock(.write, deadline: .now())
	}
	
	@inlinable
	public func tryLock(timeout: Timeout) -> Bool {
		return self.tryLock(.write, deadline: .now() + timeout)
	}
	
	@inlinable
	public func with<T>(_ closure: () throws -> T) rethrows -> T {
		return try self.with(.write, closure)
	}
	
	@inlinable
	public func tryWith<T>(_ closure: () throws -> T) rethrows -> TimeoutResult<T> {
		return try self.tryWith(.write, closure)
	}
	
	@inlinable
	public func tryWith<T>(timeout: Timeout,
	                       _ closure: () throws -> T) rethrows -> TimeoutResult<T> {
		return try self.tryWith(.write, timeout: timeout, closure)
	}
	
	@inlinable
	public func tryWith<T>(deadline: Deadline,
	                       _ closure: () throws -> T) rethrows -> TimeoutResult<T> {
		return try self.tryWith(.write, deadline: deadline, closure)
	}
}
