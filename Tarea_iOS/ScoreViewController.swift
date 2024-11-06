
import UIKit

class ScoreViewController: UIViewController, UITableViewDataSource {
    
    var users: [User] = []
    
    override func viewDidLoad() {
        GetApiScores()
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")
        cell?.textLabel?.text = users[indexPath.row].name
        return cell!
    }
    
    func GetApiScores() {
        if let url = URL(string: "https://qhavrvkhlbmsljgmbknr.supabase.co/rest/v1/scores?select=*") {
            var request = URLRequest(url: url)
            request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFoYXZydmtobGJtc2xqZ21ia25yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA        3MjY5MTgsImV4cCI6MjAxNjMwMjkxOH0.Ta-_lXGGwSiUGh0VC8tAFcFQqsqAvB8vvXJjubeQkx8", forHTTPHeaderField: "Acces-Key")
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                guard let data = data else {return}
                do {
                    let postData = try JSONDecoder().decode([User].self, from: data)
                }
                catch {
                    let error = error
                    print(error.localizedDescription)
                }
            }.resume()
        }
    }
}
