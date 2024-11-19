
import UIKit

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userNameL: UILabel!
    @IBOutlet weak var userScoreL: UILabel!
    
    var attempts: Int = 0
    var bIsPlaying: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Start()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesNamesArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //Método que crea las cells del collectionView
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.layer.borderWidth = 3
        cell.layer.cornerRadius = 15
        cell.imageView.image = imagesArray[indexPath.row].image
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width-65)/3
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { //Método que gestiona la cell pulsada por el usuario
        attempts += 1
        let cell:UICollectionViewCell = collectionView.cellForItem(at: indexPath)! as! CollectionViewCell
        if bIsPlaying {
            CheckPressedImage(index: indexPath.row, cell: cell)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) { //Método que elimina el color de fondo de la cell deseleccionada
        let cell:UICollectionViewCell = collectionView.cellForItem(at: indexPath)! as! CollectionViewCell
        if cell.contentView.backgroundColor != UIColor.green {
            cell.contentView.backgroundColor = UIColor.clear
        }
    }
    
    func Start() { //Método que define el estado inicial del VC
        LoadLocalData()
        DisplayUserName()
        DisplayUseScore()
        imagesArray.shuffle()
    }
    
    func CheckPressedImage(index: Int, cell: UICollectionViewCell) { //Método que gestiona el acierto o fallo, la puntuación y el fin del juego
        var puntuation = 5
        
        if Image.CompareImages(image1: imagesArray[index], image2: usedImagesArray[0]) {
            usedImagesArray.remove(at: 0)
            cell.contentView.backgroundColor = UIColor.green
            switch (attempts) {
            case 1:
                puntuation = 7
                break
            case 2:
                puntuation = 5
                break
            case 3:
                puntuation = 3
                break
            case 4:
                puntuation = 2
                break
            case 5:
                puntuation = 1
                break
            default:
                puntuation = 0
                break
            }
            attempts = 0
            SetUserScore(puntuation: puntuation)
            if usedImagesArray.isEmpty {
                bIsPlaying = false
                SetUserMaxScore()
                SaveLocalData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UserInfoPopUpViewController.ShowPopup(parentVC: self)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.75) {
                    self.performSegue(withIdentifier: "ToScoreView", sender: nil)
                }
            }
        }
        else {
            if cell.contentView.backgroundColor != UIColor.green {
                cell.contentView.backgroundColor = UIColor.red
            }
        }
    }
    
    func DisplayUserName() {
        userNameL.text = currentUser?.name
    }
    func DisplayUseScore() {
        userScoreL.text = String(currentUser!.currentScore)
    }
    func SetUserScore(puntuation: Int) {
        currentUser!.currentScore += puntuation
        DisplayUseScore()
    }
    func SetUserMaxScore() {
        if currentUser!.currentScore > currentUser!.maxScore {
            currentUser!.maxScore = currentUser!.currentScore
        }
    }
    
    func DisplayUserInfoAlert() { //Método que genera un alertDialog con las estadísticas del ususraio actual (TEST)
        let alert = UIAlertController(title: "\(currentUser!.name)", message: "Puntuación: \(currentUser!.currentScore)\nDificultad: \(currentUser!.difficulty)\nPuntuación Máxima: \(currentUser!.maxScore)", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
            self.performSegue(withIdentifier: "ToScoreView", sender: nil)
        }))

        self.present(alert, animated: true, completion: nil)
    }
}
