
import UIKit

class ScoreViewController: UIViewController, UITableViewDataSource {
    
    var users: [User] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        GetApiScores()
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! TableViewCell
        cell.TCNameL.text = users[indexPath.row].name
        cell.TCScoreL.text = String(describing: users[indexPath.row].maxScore!)
        return cell
    }
    
    func GetApiScores() {
        if let url = URL(string: "https://qhavrvkhlbmsljgmbknr.supabase.co/rest/v1/scores?select=*&apikey=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFoYXZydmtobGJtc2xqZ21ia25yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA3MjY5MTgsImV4cCI6MjAxNjMwMjkxOH0.Ta-_lXGGwSiUGh0VC8tAFcFQqsqAvB8vvXJjubeQkx8") {
            var request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { [self]
                (data, response, error) in
                guard let data = data else {return}
                do {
                    let usersResponse = try JSONDecoder().decode([UserResponse].self, from: data)
                    print(usersResponse)
                    for x in usersResponse {
                        self.users.append(User(name: x.name, maxScore: x.score))
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                catch let errorJson {
                    print(errorJson)
                }
            }.resume()
        }
    }
}
