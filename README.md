# Atomic

[![](https://img.shields.io/badge/Swift-5.0-orange.svg)][1]
[![](https://img.shields.io/badge/os-macOS%20|%20Linux-lightgray.svg)][1]
[![](https://travis-ci.com/std-swift/Atomic.svg?branch=master)][2]
[![](https://codecov.io/gh/std-swift/Atomic/branch/master/graph/badge.svg)][3]
[![](https://codebeat.co/badges/cff77ca7-89cf-4a04-afa7-e659e7a636f3)][4]

[1]: https://swift.org/download/#releases
[2]: https://travis-ci.com/std-swift/Atomic
[3]: https://codecov.io/gh/std-swift/Atomic
[4]: https://codebeat.co/projects/github-com-std-swift-atomic-master

Provides locks and `Atomic<T>`

## Importing

```Swift
import Atomic
```

```Swift
platforms: [
	.macOS(.v10_12)
],
dependencies: [
	.package(url: "https://github.com/std-swift/Atomic.git",
	         from: "1.0.0")
],
targets: [
	.target(
		name: "",
		dependencies: [
			"Atomic"
		]),
]
```

## Using

### `Lockable`

Provides functions to perform on locks (`lock`, `unlock`, `with`)

`Semaphore` and `RwLock` implement `Lockable`

### `Atomic<T>`

Controlls access to a value using a lock. `&=` can be used as shorthand for `get` and `set`.

`Atomic<Bool>` has `.toggle()`

`Atomic<T: SignedInteger>` has `.negate()`
