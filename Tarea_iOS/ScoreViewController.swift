
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
    
    //Conjunto de métodos que gestionan los estados del VC
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //Método que crea las cells del tableView de usuarios
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! TableViewCell
        cell.TCNameL.text = users[indexPath.row].name
        cell.TCScoreL.text = String(describing: users[indexPath.row].maxScore)
        return cell
    }
    
    @IBAction func RestartGame(_ sender: UIButton) { //Método que reinicia el juego manteniendo el usuario al pulsar un botón
        User.ResetStats()
        performSegue(withIdentifier: "BackToImagesView", sender: nil)
    }
    
    @IBAction func ChangeUser(_ sender: UIButton) { //Método que reinicia el juego cambiando el usuario al pulsar un botón
        performSegue(withIdentifier: "BackToMainView", sender: nil)
    }
    
    func SetUsers() { //Método que realiza una petición GET a la API y inicaliza el array de users
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
    func UpdateUsersTable() { //Método que actualiza el tableView
        DispatchQueue.main.async {
            self.users = self.users.sorted{$0.maxScore > $1.maxScore}
            self.tableView.reloadData()
            self.Loaded()
        }
    }
    func ManageApiData() { //Método que gestiona las peticiones a la API, comprueba si el ususario existe, y en caso afirmativo, si su puntuaciónMax actual es mayor
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
    
    func GetApiData(completion: @escaping (Result<Data, Error>) -> Void) { //Petición GET con completion
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
    func PostApiData(name:String, score:Int, completion: @escaping (Result<Data, Error>) -> Void) { //Petición POST con completion
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
    func PatchApiData(name: String, score: Int, completion: @escaping (Result<Data, Error>) -> Void) { //Petición PATCH con completion
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
