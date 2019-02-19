//
//  Lockable.swift
//  Atomic
//

import Time

public protocol _Lockable {
	func unlock(_ intent: LockingIntent)
	
	func lock(_ intent: LockingIntent)
	func tryLock(_ intent: LockingIntent,
	             deadline: Deadline) -> Bool
}

extension _Lockable {
	@inlinable
	public func tryLock(_ intent: LockingIntent) -> Bool {
		return self.tryLock(intent, deadline: .now())
	}
	
	@inlinable
	public func tryLock(_ intent: LockingIntent,
	                    timeout: Timeout) -> Bool {
		return self.tryLock(intent, deadline: .now() + timeout)
	}
}

public protocol Lockable: _Lockable {}

extension Lockable {
	/// Blocks until the lock can be aquired
	@inlinable
	public func with<T>(_ intent: LockingIntent,
	                    _ closure: () throws -> T) rethrows -> T {
		self.lock(intent)
		defer { self.unlock(intent) }
		return try closure()
	}
	
	/// Does not block
	@inlinable
	public func tryWith<T>(_ intent: LockingIntent,
	                       _ closure: () throws -> T) rethrows -> TimeoutResult<T> {
		if self.tryLock(intent) {
			defer { self.unlock(intent) }
			return .success(try closure())
		}
		return .timedOut
	}
	
	/// Blocks until the lock can be aquired or until `timeout` has passed
	@inlinable
	public func tryWith<T>(_ intent: LockingIntent,
	                       timeout: Timeout,
	                       _ closure: () throws -> T) rethrows -> TimeoutResult<T> {
		if self.tryLock(intent, deadline: .now() + timeout) {
			defer { self.unlock(intent) }
			return .success(try closure())
		}
		return .timedOut
	}
	
	/// Blocks until the lock can be aquired or until `deadline` has passed
	@inlinable
	public func tryWith<T>(_ intent: LockingIntent,
	                       deadline: Deadline,
	                       _ closure: () throws -> T) rethrows -> TimeoutResult<T> {
		if self.tryLock(intent, deadline: deadline) {
			defer { self.unlock(intent) }
			return .success(try closure())
		}
		return .timedOut
	}
}
