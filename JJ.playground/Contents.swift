import Foundation
/*:
# JJ

Super simple json parser for Swift

### Requirements

Do depencies. You can copy JJ.swift into your project if you want.

### Installation

JJ is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```pod "JJ"```

### Example
*/
struct Branch {
    let branch: String
}

struct Repository {
    let name: String
    let description: String
    let stargazersCount: Int
    let language: String?
    let sometimesMissingKey: String?

    let owner: NSData
    let defaultBranch: Branch

    init(anyObject: AnyObject?) throws {
        let obj = try jj(anyObject).obj()
        self.name = obj["name"].toString()
        self.description = obj["description"].toString()
        self.stargazersCount = obj["stargazersCount"].toInt()
        self.language = obj["language"].asString
        self.sometimesMissingKey = obj["sometimesMissingKey"].asString

        let user = try obj["owner"].obj()
        let name = try user.at("name").string()
        let headquarters = try user.at("headquarters").string()

        let data = NSMutableData()
        let coder = NSKeyedArchiver(forWritingWithMutableData: data)
        let enc = jj(encoder: coder)
        enc.put(name, at: "name")
        enc.put(headquarters, at: "headquarters")
        coder.finishEncoding()

        self.owner = data
        self.defaultBranch = Branch(branch: obj["branch"].toString())
    }

    func printFullName() {
        let decoder = NSKeyedUnarchiver(forReadingWithData: self.owner)
        let dec = jj(decoder: decoder)
        let ownerName = dec["name"].asString
        print("\(ownerName)/\(name)")
    }
}


let json = [
    "name" : "JJ",
    "description" : "Super simple json parser for Swift",
    "stargazersCount" : 999999,
    "language" : "RU",
    "sometimesMissingKey" : NSNull(),
    "owner" : [
        "name" : "Yury",
        "headquarters" : "AnjLab"
    ],
    "branch" : "master"
]

do {
    let repository = try Repository(anyObject: json)
    repository.printFullName()
} catch {
    debugPrint(error)
}
/*:

### Features
- Informative errors
- Decoding depends on inferred type
- Leverages Swift 2's error handling
- Support classes conforming ```NSCoding```

### Parsing Types
- `Bool`
- `Int` & `UInt`
- `Float`
- `Double`
- `NSNumber`
- `String`
- `NSDate`
- `NSURL`
- `NSTimeZone`
- [`AnyObject`]
- [`String` : `AnyObject`]

### Errors
`JJError` conforming `ErrorType` and there are currently two error-structs conforming to it
- `WrongType` throws when it is impossible to convert the element
- `NotFound` throws if the element is missing
*/
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
/*:
### Handling Errors
Expressions like `.<Type>()` will throw directly, and catch-statements can be used to create the most complex error handling behaviours. This also means that `try?` can be used to return nil if anything goes wrong instead of throwing.

For required values is most useful methods `.to<Type>(defaultValue)`. If the value is missing or does not match its type, will be used the default value.

For optional values there's methods `.as<Type>`.
### Requirements
- iOS 8.0+ / Mac OS X 10.10+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 7.3
- Swift 2.2

### Author

Yury Korolev, yury.korolev@gmail.com

### License

JJ is available under the MIT license. See the LICENSE file for more info.
*/