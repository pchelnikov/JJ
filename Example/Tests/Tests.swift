import UIKit
import XCTest
import JJ

import Foundation

class Tests: XCTestCase {
    
    func testObject() {
        
        let j = ["firstName": "Yury", "lastName": "Korolev"]
        
        let o = try! jj(j).obj()
        
        XCTAssertEqual("[\"lastName\": \"Korolev\", \"firstName\": \"Yury\"]", o.raw.debugDescription)
        XCTAssertEqual("{\n  \"firstName\": \"Yury\",\n  \"lastName\": \"Korolev\"\n}", o.debugDescription)
        XCTAssertEqual("{\n  \"firstName\": \"Yury\",\n  \"lastName\": \"Korolev\"\n}", o.prettyPrint())
        XCTAssertEqual("{\n  \"firstName\": \"Yury\",\n  \"lastName\": \"Korolev\"\n}", o.prettyPrint(space: "", spacer: "  "))
        
        let json = [
            "firstName": "Yury" as AnyObject,
            "lastName": "Korolev" as AnyObject,
            "trueFlag": true as AnyObject,
            "falseFlag": false as AnyObject,
            "intValue" : 13 as AnyObject,
            "doubleValue" : 12.1 as AnyObject,
            "date" : "2016-06-10T00:00:00.000Z",
            "url" : "http://anjlab.com",
            "zone" : "Europe/Moscow",
            "arr" : [1, 2, 3] ,
            "obj" : ["value" : 1]
            ] as [String: Any]
        
        let obj = try! jj(json).obj()
        
        XCTAssertEqual("Yury",    try! obj["firstName"].string())
        XCTAssertEqual("Korolev", try! obj["lastName"].string())
        XCTAssertEqual(nil, try? obj["unknownKey"].string())
        XCTAssertEqual("Korolev", obj["lastName"].toString())
        XCTAssertEqual("Test", obj["unknownKey"].toString("Test"))
        XCTAssertEqual("Korolev", obj["lastName"].asString)
        XCTAssertEqual(true, try! obj["trueFlag"].bool())
        XCTAssertEqual(false, try! obj["falseFlag"].bool())
        XCTAssertEqual(true, obj["trueFlag"].toBool())
        XCTAssertEqual(false, obj["falseFlag"].toBool())
        XCTAssertEqual(true, obj["trueFlag"].asBool)
        XCTAssertEqual(false, obj["falseFlag"].asBool)
        XCTAssertEqual(false, obj["unknown"].toBool())
        XCTAssertEqual(13, try! obj["intValue"].int())
        XCTAssertEqual(13, obj["intValue"].toInt())
        XCTAssertEqual(13, obj["intValue"].asInt)
        XCTAssertEqual(11, obj["integerValue"].toInt(11))
        XCTAssertEqual(nil, obj["integerValue"].asInt)
        XCTAssertEqual(13, try! obj["intValue"].uInt())
        XCTAssertEqual(13, obj["intValue"].toUInt())
        XCTAssertEqual(11, obj["unknownKey"].toUInt(UInt(11)))
        XCTAssertEqual(0, obj["unknownKey"].toUInt())
        XCTAssertEqual(13, obj["intValue"].asUInt)
        XCTAssertEqual(12.1, try! obj["doubleValue"].double())
        XCTAssertEqual(12.1, obj["doubleValue"].toDouble())
        XCTAssertEqual(11.1, obj["unknownKey"].toFloat(Float(11.1)))
        XCTAssertEqual(0, obj["unknownKey"].toFloat())
        XCTAssertEqual(12.1, obj["doubleValue"].asDouble)
        XCTAssertEqual(12.1, obj["doubleValue"].toDouble())
        XCTAssertEqual(12.1, obj["doubleValue"].toDouble(11.1))
        XCTAssertEqual(12.1, obj["doubleValue"].asDouble)
        XCTAssertEqual(nil, obj["unknownKey"].asDouble)
        XCTAssertEqual(11.1, obj["unknownKey"].toDouble(11.1))
        XCTAssertEqual(12.1, try! obj["doubleValue"].number())
        XCTAssertEqual(12.1, obj["doubleValue"].toNumber())
        XCTAssertEqual(11.1, obj["unknownKey"].toNumber(11.1))
        XCTAssertEqual(12.1, obj["doubleValue"].asNumber)
        XCTAssertEqual(nil, try? obj["unknownKey"].date())
        XCTAssertEqual(String.asRFC3339Date("2016-06-10T00:00:00.000Z")(), try! obj["date"].date())
        XCTAssertEqual(String.asRFC3339Date("2016-06-10T00:00:00.000Z")(), obj["date"].asDate)
        XCTAssertEqual("2016-06-10T00:00:00.000Z", String.asRFC3339Date("2016-06-10T00:00:00.000Z")()?.toRFC3339String())
        XCTAssertEqual(URL(string: "http://anjlab.com"), try! obj["url"].url())
        XCTAssertEqual(nil, try? obj["unknownKey"].url())
        XCTAssertEqual(URL(string: "http://anjlab.com"), obj["url"].toURL())
        XCTAssertEqual(URL(string: "/")!, obj["unknownKey"].toURL(URL(string: "/")!))
        XCTAssertEqual(URL(string: "http://anjlab.com"), obj["url"].asURL)
        XCTAssertEqual(nil, obj["unknownKey"].asURL)
        XCTAssertEqual(TimeZone(identifier: "Europe/Moscow"), obj["zone"].asTimeZone)
        XCTAssertEqual(nil, obj["unknownKey"].asTimeZone)
        XCTAssertEqual(true, obj["obj"].toObj().exists)
        XCTAssertEqual("[\"value\": 1]", try! obj["obj"].obj().raw.debugDescription)
        XCTAssertEqual(nil, try? obj["unknownKey"].obj().raw.debugDescription)
        XCTAssertEqual("Optional([\"value\": 1])", obj["obj"].toObj().raw.debugDescription)
        XCTAssertEqual("<root>.obj", obj["obj"].toObj().path)
        XCTAssertEqual(true, obj["arr"].toArr().exists)
        XCTAssertEqual("[1, 2, 3]", obj["arr"].toArr().raw?.debugDescription)
        XCTAssertEqual("<root>.arr", obj["arr"].toArr().path)
        XCTAssertEqual(11, obj.count)
        XCTAssertEqual(true, obj.exists)
        XCTAssertEqual("<root>", obj.path)
        XCTAssertEqual("<root>.url", obj["url"].path)
        XCTAssertEqual(json["firstName"].debugDescription, obj["firstName"].raw.debugDescription)
        XCTAssertEqual("\"Yury\"", obj["firstName"].debugDescription)
        XCTAssertEqual("\"Yury\"", obj["firstName"].prettyPrint())
        XCTAssertEqual("\"Yury\"", obj["firstName"].prettyPrint(space: "", spacer: "  "))
    }
    
    func testArray() {
        let j = [1, "Nice"] as [Any]
        
        let a = try! jj(j).arr()
        
        XCTAssertEqual(j.debugDescription, a.raw.debugDescription)
        XCTAssertEqual("[\n  1,\n  \"Nice\"\n]", a.debugDescription)
        
        let json = [1 as AnyObject, "Nice" as AnyObject, 5.5 as AnyObject, NSNull(), "http://anjlab.com" as AnyObject] as [AnyObject]
        
        let arr = try! jj(json).arr()
        
        XCTAssertEqual(1, try! arr[0].int())
        XCTAssertEqual("Nice", try! arr[1].string())
        XCTAssertEqual(5.5, try! arr[2].double())
        XCTAssertEqual(true, arr[3].isNull)
        XCTAssertEqual(URL(string: "http://anjlab.com"), try! arr[4].url())
        XCTAssertEqual(5, arr.count)
        XCTAssertEqual(true, arr.exists)
        XCTAssertEqual(true, arr[1].exists)
        XCTAssertEqual("<root>", arr.path)
        XCTAssertEqual(JJVal(1, path: "<root>.1").debugDescription, arr.at(0).debugDescription)
        XCTAssertEqual("[\n  1,\n  \"Nice\",\n  5.5,\n  null,\n  \"http://anjlab.com\"\n]", arr.prettyPrint())
        XCTAssertEqual("[\n  1,\n  \"Nice\",\n  5.5,\n  null,\n  \"http://anjlab.com\"\n]", arr.prettyPrint(space: "", spacer: "  "))
    }
    
    func testDecEnc() {
        let data = NSMutableData()
        let coder = NSKeyedArchiver(forWritingWith: data)
        
        let enc = jj(encoder: coder)
        
        enc.put("Title", at: "title")
        enc.put("Nice", at: "text")
        enc.put(["key" : "value"], at: "obj")
        enc.put(String.asRFC3339Date("2016-06-10T00:00:00.000Z")(), at: "date")
        enc.put(false, at: "boolValue")
        enc.put(13, at: "number")
        enc.put(Double(1.1), at: "double")
        enc.put(Float(10), at: "float")
        enc.put(Optional<Float>.none, at: "optionalFloat")
        
        coder.finishEncoding()
        
        let decoder = NSKeyedUnarchiver(forReadingWith: data as Data)
        
        let dec = jj(decoder: decoder)
        
        XCTAssertEqual("Nice", try! dec["text"].string())
        XCTAssertEqual(nil, dec["unknownKey"].asString)
        XCTAssertEqual(13, try! dec["number"].int())
        XCTAssertEqual(10, try! dec["float"].float())
        XCTAssertEqual(1.1, try! dec["double"].double())
        XCTAssertEqual(nil, dec["optionalFloat"].asFloat)
        XCTAssertEqual(nil, dec["unknownKey"].asInt)
        XCTAssertEqual(nil, dec["unknownKey"].asDate)
        XCTAssertEqual(nil, dec["unknownKey"].asURL)
        XCTAssertEqual(String.asRFC3339Date("2016-06-10T00:00:00.000Z")(), try! dec["date"].date())
        XCTAssertEqual(String.asRFC3339Date("2016-06-10T00:00:00.000Z")(), dec["date"].asDate)
        XCTAssertEqual(nil, dec["unknownKey"].asTimeZone)
        XCTAssertEqual(false, try! dec["boolValue"].bool())
        XCTAssertEqual(false, dec["boolValue"].toBool())
        XCTAssertEqual(decoder, dec["boolValue"].decoder)
        XCTAssertEqual("boolValue", dec["boolValue"].key)
        XCTAssertEqual("Title", try! dec["title"].decode() as NSString)
        // TODO: fix
//        let res: [String: String] = dec["obj"].decodeAs() as [String: String]
//        XCTAssertEqual(["key" : "value"],  res)

        //Errors
        
        do {
            let _ = try dec["unknownKey"].date()
            XCTFail()
        } catch {
            let err = "\(error)"
            XCTAssertEqual("JJError.WrongType: Can\'t convert nil at path: \'unknownKey\' to type \'NSDate\'", err)
        }
        
        do {
            let _ = try dec["unknownKey"].string()
            XCTFail()
        } catch {
            let err = "\(error)"
            XCTAssertEqual("JJError.WrongType: Can\'t convert nil at path: \'unknownKey\' to type \'String\'", err)
        }
        
        do {
            let _ = try dec["unknownKey"].decode() as NSNumber
            XCTFail()
        } catch {
            let err = "\(error)"
            XCTAssertEqual("JJError.WrongType: Can\'t convert nil at path: \'unknownKey\' to type \'T\'", err)
        }
    }
    
    func testErrors() {
        let json = ["firstName": "Yury", "lastName": "Korolev"]
        let obj = try! jj(json).obj()
        
        XCTAssertEqual(false, obj["unknownKey"].exists)
        
        do {
            let _ = try obj["unknownKey"].string()
            XCTFail()
        } catch {
            let err = "\(error)"
            XCTAssertEqual("JJError.WrongType: Can't convert nil at path: '<root>.unknownKey' to type 'String'", err)
        }
        
        do {
            let _ = try obj["unknownKey"].date()
            XCTFail()
        } catch {
            let err = "\(error)"
            XCTAssertEqual("JJError.WrongType: Can't convert nil at path: '<root>.unknownKey' to type 'NSDate'", err)
        }
        
        do {
            let _ = try obj["unknownKey"].url()
            XCTFail()
        } catch {
            let err = "\(error)"
            XCTAssertEqual("JJError.WrongType: Can't convert nil at path: '<root>.unknownKey' to type 'NSURL'", err)
        }
        
        do {
            let _ = try obj["nested"]["unknown"][0].url()
            XCTFail()
        } catch {
            let err = "\(error)"
            XCTAssertEqual("JJError.WrongType: Can't convert nil at path: '<root>.nested<nil>.unknown<nil>[0]' to type 'NSURL'", err)
        }
        
        do {
            let _ = try jj(json).arr()
            XCTFail()
        } catch {
            let err = "\(error)"
            XCTAssertEqual("JJError.WrongType: Can't convert Optional([\"lastName\": \"Korolev\", \"firstName\": \"Yury\"]) at path: '<root>' to type '[Any]'", err)
        }
        
        do {
            let _ = try obj["unknownKey"].bool()
            XCTFail()
        } catch {
            let err = "\(error)"
            XCTAssertEqual("JJError.WrongType: Can't convert nil at path: '<root>.unknownKey' to type 'Bool'", err)
        }
        
        do {
            let _ = try obj["unknownKey"].int()
            XCTFail()
        } catch {
            let err = "\(error)"
            XCTAssertEqual("JJError.WrongType: Can't convert nil at path: '<root>.unknownKey' to type 'Int'", err)
        }
        
        do {
            let _ = try obj["unknownKey"].uInt()
            XCTFail()
        } catch {
            let err = "\(error)"
            XCTAssertEqual("JJError.WrongType: Can't convert nil at path: '<root>.unknownKey' to type 'UInt'", err)
        }
        
        do {
            let _ = try obj["unknownKey"].float()
            XCTFail()
        } catch {
            let err = "\(error)"
            XCTAssertEqual("JJError.WrongType: Can't convert nil at path: '<root>.unknownKey' to type 'Float'", err)
        }
        
        do {
            let _ = try obj["unknownKey"].double()
            XCTFail()
        } catch {
            let err = "\(error)"
            XCTAssertEqual("JJError.WrongType: Can't convert nil at path: '<root>.unknownKey' to type 'Double'", err)
        }
        
        do {
            let _ = try obj["unknownKey"].number()
            XCTFail()
        } catch {
            let err = "\(error)"
            XCTAssertEqual("JJError.WrongType: Can't convert nil at path: '<root>.unknownKey' to type 'NSNumber'", err)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
