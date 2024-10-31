
import UIKit

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userNameL: UILabel!
    @IBOutlet weak var userScoreL: UILabel!
    
    var attempts: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Start()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesNamesArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 15
        cell.imageView.image = UIImage(named: imagesNamesArray[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width-65)/2
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        attempts += 1
        print("Cell \(indexPath.row + 1) clicked. Animal: \(imagesArray[indexPath.row].name). Attempt: \(attempts)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        checkPressedImage(image: cell.imageView.image!)
    }
    
    func Start() {
        displayUserName()
        displayUseScore()
    }
    
    func checkPressedImage(image: UIImage) {
        var puntuation: Int = 5
    }
    
    func displayUserName() {
        userNameL.text = currentUser?.name
    }
    func displayUseScore() {
        userScoreL.text = String(currentUser!.currentScore)
    }
    func setUserScore(puntuation: Int) {
        currentUser!.currentScore += puntuation
        displayUseScore()
    }
}
