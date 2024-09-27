<p align="center">
 <a href="https://github.com/adelinofaria/networking/actions/workflows/tests.yml">
   <img src="https://github.com/adelinofaria/networking/actions/workflows/tests.yml/badge.svg?branch=main" alt="GitHub Action Status">
 </a>
  <a href="https://raw.githubusercontent.com/adelinofaria/networking/main/LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-lightgrey.svg?maxAge=2592000" alt="MIT license">
  </a>
</p>

<p align="center">
  <a href="Platforms">
    <img src="https://img.shields.io/badge/platforms-iOS%20%7C%20macOS-333333.svg" alt="Supported Platforms: iOS, macOS" />
  </a>
  <a href="https://github.com/apple/swift">
    <img src="https://img.shields.io/badge/Swift-6.0-orange.svg" alt="Swift 6.0 supported">
  </a>
  <a href="https://swift.org/package-manager/">
    <img src="https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square" alt="Swift Package Manager compatible">
  </a>
</p>

# Networking

_Unopinated networking framework with readability, easy of use, adaptability and leverage of swift's latest technologies._

## Features

- [x] Modular networking
- [x] Authentication support without coupling
- [x] Support for iOS and macOS
-
- [ ] Add sophisticated and extensive examples into Sources/Examples
- [ ] Support for Linux
- [ ] Support for watchOS
- [ ] Support for Windows
- [ ] Support for tvOS & visionOS

## Usage

Here's a few very simple usages of the framework to get you started.

### Simple GET request with a expected Model

```swift
let url = URL(string: "https://host.domain/path")!
let networking = Networking()

let result: Model = try await networking.request(.get(url: url))
```

### Simple POST request with Model with empty response

```swift
let url = URL(string: "https://host.domain/path")!
let networking = Networking()
let model = Model()

let _: None = try await networking.request(.post(url: url, body: model))
```

## Release Notes

See [CHANGELOG.md](https://github.com/adelinofaria/networking/blob/master/CHANGELOG.md) for a list of changes.

## License

Networking is available under the MIT license. See the [LICENSE](https://github.com/adelinofaria/networking/blob/master/LICENSE) file for more info.
