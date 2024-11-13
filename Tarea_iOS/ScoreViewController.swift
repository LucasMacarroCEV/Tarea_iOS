
import UIKit

class ScoreViewController: UIViewController, UITableViewDataSource {
    
    var users: [User] = []

    @IBOutlet weak var changeUserBTN: UIButton!
    @IBOutlet weak var restartBTN: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Start()
        GetApiScores()
    }
    
    func Start() {
        LoadLocalData()
        changeUserBTN.isEnabled = false
        restartBTN.isEnabled = false
    }
    func Loaded() {
        changeUserBTN.isEnabled = true
        restartBTN.isEnabled = true
    }
    func Error() {
        changeUserBTN.isEnabled = false
        restartBTN.isEnabled = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! TableViewCell
        cell.TCNameL.text = users[indexPath.row].name
        cell.TCScoreL.text = String(describing: users[indexPath.row].maxScore)
        return cell
    }
    
    @IBAction func RestartGame(_ sender: UIButton) {
        User.ResetStats()
        performSegue(withIdentifier: "BackToImagesView", sender: nil)
    }
    
    @IBAction func ChangeUser(_ sender: UIButton) {
        performSegue(withIdentifier: "BackToMainView", sender: nil)
    }
    
    func ManageApiData() {
        GetApiScores()
        for x in users {
            print("Nombre:", x.name, "\nPuntuacion max:", x.maxScore, "\n")
        }
        if CheckExistingUser(usersArray: users) {
            let existingUserIndex = GetExistingUserIndex(usersArray: users)
            if users[existingUserIndex].maxScore < currentUser!.maxScore {
                print("El ususario existe en la base de datos")
                //PatchApiScores()
            }
        }
        else {
            PostApiScores(name: currentUser!.name, score: currentUser!.maxScore)
            print("El usuario ha sido añadido a la base de datos")
        }
        GetApiScores()
        for x in users {
            print("Nombre:", x.name, "\nPuntuacion max:", x.maxScore, "\n")
        }
        users = users.sorted{$0.maxScore > $1.maxScore}
        tableView.reloadData()
        Loaded()
    }
    func GetApiScores() {
        users.removeAll()
        if let url = URL(string: "https://qhavrvkhlbmsljgmbknr.supabase.co/rest/v1/scores?select=*") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFoYXZydmtobGJtc2xqZ21ia25yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA3MjY5MTgsImV4cCI6MjAxNjMwMjkxOH0.Ta-_lXGGwSiUGh0VC8tAFcFQqsqAvB8vvXJjubeQkx8", forHTTPHeaderField: "apikey")
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                guard let data = data else {return}
                do {
                    let usersResponse = try JSONDecoder().decode([UserResponse].self, from: data)
                    for x in usersResponse {
                        self.users.append(User(name: x.name, maxScore: x.score))
                    }
                    DispatchQueue.main.async {
                        self.ManageApiData()
                    }
                }
                catch let errorJson {
                    self.Error()
                    print(errorJson)
                }
            }.resume()
        }
        
    }
    func PostApiScores(name:String, score:Int) {
        let parameters: [String: Any] = ["name": name, "score": score]
        let parametersJSON = try? JSONSerialization.data(withJSONObject: parameters)
        
        if let url = URL(string: "https://qhavrvkhlbmsljgmbknr.supabase.co/rest/v1/scores") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFoYXZydmtobGJtc2xqZ21ia25yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA3MjY5MTgsImV4cCI6MjAxNjMwMjkxOH0.Ta-_lXGGwSiUGh0VC8tAFcFQqsqAvB8vvXJjubeQkx8", forHTTPHeaderField: "apikey")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = parametersJSON
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                guard let data = data, error == nil else {
                    self.Error()
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
            }.resume()
        }

        
//        let parameters: [String : Any] = ["name" : name, "score" : score]
//        
//        if let url = URL(string: "https://qhavrvkhlbmsljgmbknr.supabase.co/rest/v1/scores") {
//            var request = URLRequest(url: url)
//            do {
//                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
//            } catch let error {
//                Error()
//                print(error.localizedDescription)
//            }
//            request.httpMethod = "POST"
//            request.setValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFoYXZydmtobGJtc2xqZ21ia25yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA3MjY5MTgsImV4cCI6MjAxNjMwMjkxOH0.Ta-_lXGGwSiUGh0VC8tAFcFQqsqAvB8vvXJjubeQkx8", forHTTPHeaderField: "apikey")
//            let task = URLSession.shared.dataTask(with: request) {[self] (data, response, error) in
//                guard error == nil else {Error(); return}
//                guard let data = data else {return}
//                do {
//                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
//                        Error()
//                        return
//                    }
//                    print(json)
//                } catch let error {
//                    Error()
//                    print(error.localizedDescription)
//                }
//            }.resume()
//        }
    }
    func PatchApiScores() {
        
    }
}
