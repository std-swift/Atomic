//
//  RwLock.swift
//  Atomic
//

import Time

public class RwLock: Lockable {
	private var readers = 0
	private var rSem = Semaphore(value: 1)
	private var gSem = Semaphore(value: 1)
	
	public init() {}
	
	public func unlock(_ intent: LockingIntent) {
		switch intent {
			case .read:
				self.rSem.with(.read) {
					self.readers -= 1
					if self.readers == 0 { self.gSem.unlock(.read) }
				}
			case .write:
				self.gSem.unlock(.write)
		}
	}
	
	public func lock(_ intent: LockingIntent) {
		switch intent {
			case .read:
				self.rSem.with(.read) {
					self.readers += 1
					if self.readers == 1 { self.gSem.lock(.read) }
				}
			case .write:
				self.gSem.lock(.write)
		}
	}
	
	public func tryLock(_ intent: LockingIntent, deadline: Deadline) -> Bool {
		switch intent {
			case .read:
				let result = self.rSem.tryWith(.read, deadline: deadline) { () -> Bool in
					self.readers += 1
					if self.readers == 1 {
						if !self.gSem.tryLock(.read, deadline: deadline) {
							self.readers -= 1
							return false
						}
					}
					return true
				}
				switch result {
					case .timedOut:       return false
					case .success(true):  return true
					case .success(false): return false
				}
			case .write:
				return self.gSem.tryLock(.write, deadline: deadline)
		}
	}
}
