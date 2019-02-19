//
//  SignedInteger.swift
//  Atomic
//

extension Atomic where Element: SignedInteger {
	@inlinable
	public func negate() {
		self.withLock { $0.negate() }
	}
}
