# JJ

[![CI Status](http://img.shields.io/travis/anjlab/JJ.svg?style=flat)](https://travis-ci.org/anjlab/JJ)
[![Version](https://img.shields.io/cocoapods/v/JJ.svg?style=flat)](http://cocoapods.org/pods/JJ)
[![License](https://img.shields.io/cocoapods/l/JJ.svg?style=flat)](http://cocoapods.org/pods/JJ)
[![Platform](https://img.shields.io/cocoapods/p/JJ.svg?style=flat)](http://cocoapods.org/pods/JJ)

Super simple json parser for Swift

### Requirements
- iOS 10.0+ / Mac OS X 10.12+ / tvOS 10.0+ / watchOS 3.0+
- Xcode 8.0
- Swift 3.0

No dependences. You can copy JJ.swift into your project if you want.

### Installation

JJ is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JJ"
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### JSON Example
```swift
import UIKit

struct Branch {
    let branch: String
}

struct MyRepository {
    let name: String
    let desc: String
    let stargazersCount: Int
    let language: String?
    let sometimesMissingKey: String?

    let defaultBranch: Branch

    init(anyObject: AnyObject?) throws {
        let obj = try jj(anyObject).obj()
        self.name = obj["name"].toString()
        self.desc = obj["description"].toString()
        self.stargazersCount = obj["stargazersCount"].toInt()
        self.language = obj["language"].asString
        self.sometimesMissingKey = obj["sometimesMissingKey"].asString

        self.defaultBranch = Branch(branch: obj["branch"].toString())
    }
}


let json = [
    "name" : "JJ",
    "description" : "Super simple json parser for Swift",
    "stargazersCount" : 999999,
    "language" : "RU",
    "sometimesMissingKey" : NSNull(),
    "branch" : "master"
]

do {
    let r = try MyRepository(anyObject: json)
} catch {
    debugPrint(error)
}
```
### NSCoder Example
```swift
class RepositoryAuthor: NSObject, NSCoding {
    var name: String!
    var headquarters: String!

    init(name: String, headquarters: String) {
        super.init()
        self.name = name
        self.headquarters = headquarters
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let dec = jj(decoder: aDecoder)

        do {
            let name = try dec["name"].string()
            let headquarters = try dec["headquarters"].string()

            self.init(name: name, headquarters: headquarters)
        } catch {
            debugPrint(error)
            return nil
        }
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.headquarters, forKey: "headquarters")
    }
}

let data = NSMutableData()
let coder = NSKeyedArchiver(forWritingWith: data)
let enc = jj(encoder: coder)

enc.put("Yury", at: "name")
enc.put("AnjLab", at: "headquarters")
coder.finishEncoding()

let decoder = NSKeyedUnarchiver(forReadingWith: data as Data)
let author = RepositoryAuthor(coder: decoder)
```
### Features
- Informative errors
- Decoding depends on inferred type
- Leverages Swift 3's error handling
- Support classes conforming ```NSCoding```

### Parsing Types
- ```Bool```
- ```Int``` & ```UInt```
- ```Float```
- ```Double```
- ```Number```
- ```String```
- ```Date```
- ```URL```
- ```TimeZone```
- [```AnyObject```]
- [```String``` : ```AnyObject```]

### Errors
```JJError``` conforming ```ErrorProtocol``` and there are currently two error-structs conforming to it
- ```WrongType``` throws when it is impossible to convert the element
- ```NotFound``` throws if the element is missing
```swift
let arr = ["element"]

do {
    let _ = try jj(arr).obj()
} catch {
    print(error)
}

//  JJError.WrongType: Can't convert Optional(<_TtCs21_SwiftDeferredNSArray 0x7fa3be4acb40>(
//  element
//  )
//  ) at path: '<root>' to type '[String: AnyObject]'
```
### Handling Errors
Expressions like ```.<Type>()``` will throw directly, and catch-statements can be used to create the most complex error handling behaviours. This also means that ```try?``` can be used to return nil if anything goes wrong instead of throwing.

For required values is most useful methods ```.to<Type>(defaultValue)```. If the value is missing or does not match its type, will be used the default value.

For optional values there's methods ```.as<Type>```.

| Method | Examples | Null Behaviour | Missing Key Behaviour | Type Mismatch Behaviour |
| --- | :---: | :---: | :---: | :---: |
| `.<Type>()` | `.int()` | `throws` | `throws` | `throws` |
| `.to<Type>(defaultValue)` | `.toString()` or `.toString("Default")` | `defaultValue` | `defaultValue` | `defaultValue` |
| `.as<Type>` | `.asObj` | `nil` | `nil` | `nil` |
| `.decode()` | `.decode() as Number` | `throws` | `throws` | `throws` |
| `.decodeAs()` | `.decodeAs()` | `nil` | `nil` | `nil` |

### Author

Yury Korolev, yury.korolev@gmail.com

### License

JJ is available under the MIT license. See the LICENSE file for more info.
