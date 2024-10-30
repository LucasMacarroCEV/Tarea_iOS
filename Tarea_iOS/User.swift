
import Foundation

var currentUser: User? = nil

class User {
    var name: String = "Guest"
    var currentScore: Int?
    var maxScore: Int?
    
    init(){
        
    }
    
    init(name: String) {
        self.name = name
    }
    
    static private func CheckSpecialChars(text: String) -> Bool{
        var error = false
        for char in text {
            if char.isSymbol || char.isPunctuation || char.isMathSymbol || char.isCurrencySymbol {error = true}
        }
        return error
    }
    
    static func ValidateName(name: String) -> Bool {
        if name.isEmpty {return false}
        else if name.count > 10 {return false}
        else if !name.first!.isLetter {return false}
        else if CheckSpecialChars(text: name) {return false}
        else {return true}
    }
}
