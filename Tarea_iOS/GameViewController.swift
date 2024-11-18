
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
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        attempts += 1
        let cell:UICollectionViewCell = collectionView.cellForItem(at: indexPath)! as! CollectionViewCell
        if bIsPlaying {
            CheckPressedImage(index: indexPath.row, cell: cell)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell:UICollectionViewCell = collectionView.cellForItem(at: indexPath)! as! CollectionViewCell
        if cell.contentView.backgroundColor != UIColor.green {
            cell.contentView.backgroundColor = UIColor.clear
        }
    }
    
    func Start() {
        LoadLocalData()
        DisplayUserName()
        DisplayUseScore()
        imagesArray.shuffle()
    }
    
    func CheckPressedImage(index: Int, cell: UICollectionViewCell) {
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    //self.performSegue(withIdentifier: "ToScoreView", sender: nil)
                    self.DisplayUserInfoAlert()
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
    
    func DisplayUserInfoAlert() {
        let alert = UIAlertController(title: "\(currentUser!.name)", message: "Puntuación: \(currentUser!.currentScore)\nDificultad: \(currentUser!.difficulty)\nPuntuación Máxima: \(currentUser?.maxScore)", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
            self.performSegue(withIdentifier: "ToScoreView", sender: nil)
        }))

        self.present(alert, animated: true, completion: nil)
    }
}
