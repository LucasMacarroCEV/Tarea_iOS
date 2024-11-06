
import UIKit

var testArray: [User] = []

class ScoreViewController: UIViewController, UITableViewDataSource {
    
    override func viewDidLoad() {
        testArray.append(User(name: "Manue"))
        testArray.append(User(name: "Pedro"))
        testArray.append(User(name: "Jose Migue"))
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")
        cell?.textLabel?.text = testArray[indexPath.row].name
        return cell!
    }
    
    func GetApiScores() {
        if let url = URL(string: "https://qhavrvkhlbmsljgmbknr.supabase.co/rest/v1/scores?select=*") {
            var request = URLRequest(url: url)
            request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFoYXZydmtobGJtc2xqZ21ia25yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA                 3MjY5MTgsImV4cCI6MjAxNjMwMjkxOH0.Ta-_lXGGwSiUGh0VC8tAFcFQqsqAvB8vvXJjubeQkx8", forHTTPHeaderField: "TRN-Api-Key")
            request.httpMethod = "GET"
            let dataTask = URLSession.shared.dataTask(with: request) {
                (data: Data?, response: URLResponse?, error: Error?) in
                if error == nil {
                    print("Ke wapo lo he pillao to")
                } else {
                    print(error!)
                }
            }
            dataTask.resume()
        }
    }
}
