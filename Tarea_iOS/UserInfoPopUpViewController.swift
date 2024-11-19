
import UIKit

class UserInfoPopUpViewController: UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var scoreL: UILabel!
    @IBOutlet weak var difficultyL: UILabel!
    @IBOutlet weak var maxScoreL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        popUpView.layer.cornerRadius = 15
        popUpView.layer.borderWidth = 3
        SetPopUpValues()
    }
    
    func SetPopUpValues() {
        nameL.text = currentUser!.name
        scoreL.text = String(currentUser!.currentScore)
        maxScoreL.text = String(currentUser!.maxScore)
        difficultyL.text = String(currentUser!.difficulty)
    }
    static func ShowPopup(parentVC: UIViewController){
        if let popUpViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserInfoPopupViewController") as? UserInfoPopUpViewController {
            popUpViewController.modalPresentationStyle = .custom
            popUpViewController.modalTransitionStyle = .crossDissolve
            parentVC.present(popUpViewController, animated: true)
        }
    }
}
