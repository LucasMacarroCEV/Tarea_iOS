
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var playBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Start()
    }
    
    @IBAction func PressBTN(_ sender: UIButton) {
        if ValidateName() {CreateUser(name: nameTF.text!)}
    }
    
    @IBAction func OnTextChanged(_ sender: Any) {
        ValidateName()
    }
    
    func Start() {
        //playBTN.setTitle("JUGAR", for: .normal)
        playBTN.setImage(UIImage(named: "playicon2_back"), for: .normal)
        nameTF.text = ""
        playBTN.isEnabled = false
    }
    func Writting() {
        //playBTN.setTitle("JUGAR", for: .normal)
        playBTN.setImage(UIImage(named: "playicon2_back"), for: .normal)
        playBTN.isEnabled = true
    }
    func Error() {
        //playBTN.setTitle("ERROR", for: .normal)
        playBTN.setImage(UIImage(named: "erroricon_back"), for: .normal)
        playBTN.isEnabled = false
    }
    
    func ValidateName() -> Bool {
        let name = nameTF.text!
        let isValid = User.ValidateName(name: name)
        if name.isEmpty {Start()}
        else if !isValid {Error()}
        else {Writting()}
        
        return isValid
    }
    
    func CreateUser(name: String) {
        currentUser = User(name: name)
        performSegue(withIdentifier: "ToImagesView", sender: nil)
        Start()
    }
}

