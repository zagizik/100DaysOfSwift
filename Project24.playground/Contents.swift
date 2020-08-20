import UIKit

var pre = "pet"
var str = "car"
var one = "1"
var lns = " some long string for testing purposes"

extension String {
    
    func withPrefix(with: String) -> String {
        return self + with
    }
    
    func isNumeric() -> Bool {
        for letter in self {
            if Double(String(letter)) != nil {
                return true
            }
        }
        return false
    }
    
    func lineBracker() -> String {
        var strn = ""
        for letter in self {
            if String(letter) == " " {
                strn.append("/")
            } else { strn.append(letter) }
        }
        print(self)
        return strn
    }
}
Double(one)
Double(str)
str.withPrefix(with: pre)
one.isNumeric()
str.isNumeric()
lns.lineBracker()

