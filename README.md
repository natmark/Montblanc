![Header](https://github.com/natmark/Montblanc/blob/master/Resources/Header.png?raw=true)

<p align="center">
    <a href="https://travis-ci.com/natmark/Montblanc">
        <img src="https://travis-ci.com/natmark/Montblanc.svg?token=nzmukddH8XeX8xpNA4qP&branch=master"
             alt="Build Status">
    </a>
    <a href="https://cocoapods.org/pods/Montblanc">
        <img src="https://img.shields.io/cocoapods/v/Montblanc.svg?style=flat"
             alt="Pods Version">
    </a>
    <a href="https://github.com/natmark/Montblanc/">
        <img src="https://img.shields.io/cocoapods/p/Montblanc.svg?style=flat"
             alt="Platforms">
    </a>
    <a href="https://github.com/Carthage/Carthage">
        <img src="https://img.shields.io/badge/Carthage-compatible-brightgreen.svg?style=flat"
             alt="Carthage Compatible">
    </a>
</p>

# Montblanc
Montblanc is a wrapper for CoreML Model Compiler. Montblanc written in Swift🐧 and support iOS & OSX.

## Requirements
- Swift 4.1 or later

## Usage
- Fetch `.mlmodel` from remote & compile
```Swift
import Montblanc

let url = URL(string: "https://docs-assets.developer.apple.com/coreml/models/MobileNet.mlmodel")!

Montblanc.request(url) { result in
    switch result {
    case .success(let model):
       // return compiled CoreML model
    case .failure(let error):
        Swift.print(error)
    }
}
```

- Compile local `.mlmodel` file

```Swift
import Montblanc

let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendPathComponent("your_file.mlmodel", isDirectory: false)

Montblanc.compile(path) { result in
    switch result {
    case .success(let model):
       // return compiled CoreML model
    case .failure(let error):
        Swift.print(error)
    }
}

```
## Installation
### [CocoaPods](https://cocoapods.org/pods/Montblanc)
Add the following to your `Podfile`:
```
  pod "Montblanc"
```

### [Carthage](https://github.com/Carthage/Carthage)
Add the following to your `Cartfile`:
```
  github "natmark/Montblanc"
```

## License
Montblanc is available under the MIT license. See the LICENSE file for more info.
