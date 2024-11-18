
import Foundation

var currentUser: User? = nil

class User: Codable {
    var name: String = "Guest"
    var currentScore: Int = 0
    var maxScore: Int = 0
    var difficulty: Int = 3

    init(){
        
    }
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, maxScore: Int) {
        self.name = name
        self.maxScore = maxScore
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
    
    static func ResetStats() {
        currentUser!.currentScore = 0
        currentUser!.maxScore = 0
    }
}

var localUsers: [User] = []
func CheckExistingUser(usersArray:[User]) -> Bool {
    if let sameUser = usersArray.filter({$0.name.lowercased() == currentUser?.name.lowercased()}).first {
        currentUser!.name = sameUser.name
        return true
    }
    else {return false}
}
func GetExistingUserIndex(usersArray:[User]) -> Int {
    return usersArray.firstIndex(where: {$0.name.lowercased() == currentUser?.name.lowercased()})!
}
func DeleteLocalData() { //--> BORRAR
    UserDefaults.standard.removeObject(forKey: "users")
}
func SaveLocalData() {
    if CheckExistingUser(usersArray: localUsers) {
        let existingUserIndex = GetExistingUserIndex(usersArray: localUsers)
        if localUsers[existingUserIndex].maxScore < currentUser!.maxScore {
            localUsers[existingUserIndex].maxScore = currentUser!.maxScore
        }
    }
    else {
        localUsers.append(currentUser!)
    }
    let encoder = JSONEncoder()
    if let data = try? encoder.encode(localUsers) {
        UserDefaults.standard.set(data, forKey: "users")
    }
}
func LoadLocalData() {
    if UserDefaults.standard.object(forKey: "users") != nil {
        let data = UserDefaults.standard.object(forKey: "users") as! Data
        let decoder = JSONDecoder()
        if let users:[User] = try? decoder.decode([User].self, from: data) {
            localUsers = users
            if CheckExistingUser(usersArray: localUsers) {
                let existingUserIndex = GetExistingUserIndex(usersArray: localUsers)
                if localUsers[existingUserIndex].maxScore > currentUser!.maxScore {
                    currentUser!.maxScore = localUsers[existingUserIndex].maxScore
                }
            }
        }
    }
}
