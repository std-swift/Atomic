//
//  Bool.swift
//  Atomic
//

extension Atomic where Element == Bool {
	@inlinable
	public func toggle() {
		self.withLock { $0.toggle() }
	}
}
