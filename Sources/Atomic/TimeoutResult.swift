//
//  TimeoutResult.swift
//  Atomic
//

public enum TimeoutResult<T> {
	case success(T)
	case timedOut
}
