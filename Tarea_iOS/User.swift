
import Foundation

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
        for char in text {
            if !char.isLetter || !char.isNumber {return false}
        }
        return true
    }
    
    static func ValidateName(name: String) -> Bool {
        if name.isEmpty {return false}
        else if name.count > 10 {return false}
        else if !name.first!.isLetter {return false}
        else if !CheckSpecialChars(text: name) {return false}
        else {return true}
    }
}
