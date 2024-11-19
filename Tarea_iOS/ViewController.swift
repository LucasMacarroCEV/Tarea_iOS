
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var difficultyL: UILabel!
    @IBOutlet weak var difficultyST: UIStepper!
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
    
    @IBAction func OnDifficultyChanged(_ sender: UIStepper) {
        DisplayDifficulty(value: sender.value)
    }
    
    func DisplayDifficulty(value: Double) {
        difficultyL.text = "\(Int(value))"
    }
    
    func Start() {
        //DeleteLocalData() //-->BORRAR
        playBTN.setImage(UIImage(named: "playicon2_back"), for: .normal)
        playBTN.isEnabled = false
        difficultyST.maximumValue = Double(imagesNamesArray.count)
        difficultyST.minimumValue = 2
        difficultyST.value = 3
        //DisplayDifficulty(value: difficultyST.value)
    }
    func Writting() {
        playBTN.setImage(UIImage(named: "playicon2_back"), for: .normal)
        playBTN.isEnabled = true
    }
    func Error() {
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
        currentUser = User(name: name, difficulty: Int(difficultyST.value))
        print(currentUser!.name + " - " + String(currentUser!.difficulty))
        performSegue(withIdentifier: "ToImagesView", sender: nil)
        //Start()
    }
}

