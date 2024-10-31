
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
var imagesArray: [Image] = []
var usedImagesArray: [Image] = []

class ImagesViewController: UIViewController {
    
    @IBOutlet weak var ImagesIV: UIImageView!
    @IBOutlet weak var CountL: UILabel!
    
    var numImages: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetImagesArray()
        ChangeImage()
    }
    
    func SetImagesArray() {
        for i in 0..<imagesNamesArray.count {
            imagesArray.append(Image(name: imagesNamesArray[i], image: UIImage(named: imagesNamesArray[i])!))
        }
    }
    
    func Start(){
        usedImagesArray.removeAll()
    }
    
    func SelectRandomImage() -> UIImage{
        var currentImage: Image
        
        while true {
            let randomInt = Int.random(in: 0..<imagesNamesArray.count)
            currentImage = imagesArray[randomInt]
            
            if !Image.CheckImageArray(imagesArray: usedImagesArray, image: currentImage){
                usedImagesArray.append(currentImage)
                return currentImage.image
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
