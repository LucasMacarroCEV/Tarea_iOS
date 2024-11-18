
import UIKit

class ScoreViewController: UIViewController, UITableViewDataSource {
        
    var users: [User] = []
    var apikey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFoYXZydmtobGJtc2xqZ21ia25yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA3MjY5MTgsImV4cCI6MjAxNjMwMjkxOH0.Ta-_lXGGwSiUGh0VC8tAFcFQqsqAvB8vvXJjubeQkx8"

    @IBOutlet weak var changeUserBTN: UIButton!
    @IBOutlet weak var restartBTN: UIButton!
    @IBOutlet weak var loadingAI: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Start()
        ManageApiData()
    }
    
    func Start() {
        LoadLocalData()
        loadingAI.startAnimating()
        changeUserBTN.isEnabled = false
        restartBTN.isEnabled = false
        tableView.isHidden = true
    }
    func Loaded() {
        loadingAI.stopAnimating()
        tableView.isHidden = false
        changeUserBTN.isEnabled = true
        restartBTN.isEnabled = true
    }
    func Error() {
        loadingAI.stopAnimating()
        tableView.isHidden = true
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
    
    func SetUsers() {
        GetApiData {[self] result in
            switch result {
            case .success(let data):
                do {
                    let usersResponse = try JSONDecoder().decode([UserResponse].self, from: data)
                    for x in usersResponse {
                        users.append(User(name: x.name, maxScore: x.score))
                    }
                    UpdateUsersTable()
                }
                catch let errorJson {
                    Error()
                    print(errorJson)
                }
            case .failure(let error):
                Error()
                print(error.localizedDescription)
            }
        }
    }
    func UpdateUsersTable() {
        DispatchQueue.main.async {
            self.users = self.users.sorted{$0.maxScore > $1.maxScore}
            self.tableView.reloadData()
            self.Loaded()
        }
    }
    func ManageApiData() {
        GetApiData {[self] result in
            switch result {
            case .success(let data):
                do {
                    let usersResponse = try JSONDecoder().decode([UserResponse].self, from: data)
                    for x in usersResponse {
                        users.append(User(name: x.name, maxScore: x.score))
                    }
                    if CheckExistingUser(usersArray: users) {
                        let existingUserIndex = GetExistingUserIndex(usersArray: users)
                        if users[existingUserIndex].maxScore < currentUser!.maxScore {
                            PatchApiData(name: currentUser!.name, score: currentUser!.maxScore) {[self] result in
                                switch result {
                                case .success(let data):
                                    print("El ususario existe en la base de datos")
                                    SetUsers()
                                case .failure(let error):
                                    Error()
                                    print(error.localizedDescription)
                                }
                            }
                        }
                        else {
                            UpdateUsersTable()
                        }
                    }
                    else {
                        PostApiData(name: currentUser!.name, score: currentUser!.maxScore) {[self] result in
                            switch result {
                            case .success(let data):
                                print("El usuario ha sido añadido a la base de datos")
                                SetUsers()
                            case .failure(let error):
                                Error()
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
                catch let errorJson {
                    Error()
                    print(errorJson)
                }
            case .failure(let error):
                Error()
                print(error.localizedDescription)
            }
        }
    }
    
    func GetApiData(completion: @escaping (Result<Data, Error>) -> Void) {
        users.removeAll()
        if let url = URL(string: "https://qhavrvkhlbmsljgmbknr.supabase.co/rest/v1/scores?select=*") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue(apikey, forHTTPHeaderField: "apikey")
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                if let error = error {completion(.failure(error)); return}
                guard let httpResponse = response, let data = data else {completion(.failure(error!)); return}
                completion(.success(data))
            }.resume()
        }
    }
    func PostApiData(name:String, score:Int, completion: @escaping (Result<Data, Error>) -> Void) {
        let parameters: [String: Any] = ["name": name, "score": score]
        let parametersJSON = try? JSONSerialization.data(withJSONObject: parameters)
        
        if let url = URL(string: "https://qhavrvkhlbmsljgmbknr.supabase.co/rest/v1/scores") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(apikey, forHTTPHeaderField: "apikey")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = parametersJSON
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                if let error = error {completion(.failure(error)); return}
                guard let data = data else {completion(.failure(error!)); return}
                completion(.success(data))
            }.resume()
        }
    }
    func PatchApiData(name: String, score: Int, completion: @escaping (Result<Data, Error>) -> Void) {
        let parameters: [String: Any] = ["score": score]
        let parametersJSON = try? JSONSerialization.data(withJSONObject: parameters)
        
        if let url = URL(string: "https://qhavrvkhlbmsljgmbknr.supabase.co/rest/v1/scores?name=eq."+name) {
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue(apikey, forHTTPHeaderField: "apikey")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = parametersJSON
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                if let error = error {completion(.failure(error)); return}
                guard let data = data else {completion(.failure(error!)); return}
                completion(.success(data))
            }.resume()
        }
    }
}
