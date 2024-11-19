
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
    
    //Conjuento de métodos que definen los estados del ViewController
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
    
    func ValidateName() -> Bool { //Método que valida el nombre introducido
        let name = nameTF.text!
        let isValid = User.ValidateName(name: name)
        if name.isEmpty {Start()}
        else if !isValid {Error()}
        else {Writting()}
        
        return isValid
    }
    
    func CreateUser(name: String) { //Método que crea y asigna el usuario actual y realiza un segue al siguiente VC
        currentUser = User(name: name, difficulty: Int(difficultyST.value))
        print(currentUser!.name + " - " + String(currentUser!.difficulty))
        performSegue(withIdentifier: "ToImagesView", sender: nil)
        //Start()
    }
}

