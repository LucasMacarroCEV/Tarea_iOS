
import UIKit

var imagesNamesArray: [String] = [
    "bird",
    "crocodile",
    "dog",
    "giraffe",
    "lion",
    "shark",
    "whale"
]
var usedImagesArray: [UIImage] = []

class ImagesViewController: UIViewController {
    
    @IBOutlet weak var ImagesIV: UIImageView!
    @IBOutlet weak var CountL: UILabel!
    
    var numImages: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeImage()
    }
    
    func Start(){
        usedImagesArray.removeAll()
    }
    
    func SelectRandomImage() -> UIImage{
        var currentImage: UIImage
        
        while true {
            let randomInt = Int.random(in: 0..<imagesNamesArray.count)
            currentImage = UIImage(named: imagesNamesArray[randomInt])!
            
            if !usedImagesArray.contains(currentImage){
                usedImagesArray.append(currentImage)
                return currentImage
            }
        }
    }
    func ChangeImage() {
        self.numImages = 0
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) {(timer) in
            self.numImages += 1
            if self.numImages <= currentUser!.difficulty {
                self.ImagesIV.image = self.SelectRandomImage()
                self.CountL.text = String(self.numImages)
            }
            else {
                timer.invalidate()
                self.ImagesIV.image = nil
                self.CountL.text = ""
                self.PerformSegue()
            }
        }
    }
    
    func PerformSegue() {
        performSegue(withIdentifier: "ToGameView", sender: nil)
    }
}
