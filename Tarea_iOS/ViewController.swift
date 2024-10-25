
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var playBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Start()
    }
    
    @IBAction func PressBTN(_ sender: UIButton) {
        
    }
    
    @IBAction func OnTextChanged(_ sender: Any) {
        ValidateName()
    }
    
    func Start() {
        playBTN.setTitle("JUGAR", for: .normal)
        nameTF.text = ""
        playBTN.isEnabled = false
    }
    func Writting() {
        playBTN.setTitle("JUGAR", for: .normal)
        playBTN.isEnabled = true
    }
    func Error() {
        playBTN.setTitle("ERROR", for: .normal)
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
}

