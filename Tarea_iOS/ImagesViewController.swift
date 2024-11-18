
import UIKit

var imagesNamesArray: [String] = [
    "bird",
    "crocodile",
    "dog",
    "giraffe",
    "lion",
    "shark",
    "whale",
    "snake",
    "owl",
    "cow",
    "monkey",
    "raccoon"
]
var imagesArray: [Image] = []
var usedImagesArray: [Image] = []

class ImagesViewController: UIViewController {
    
    @IBOutlet weak var ImagesIV: UIImageView!
    @IBOutlet weak var CountL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Start()
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
        imagesArray.removeAll()
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
        var numImages: Int = 0
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) {(timer) in
            numImages += 1
            if numImages <= currentUser!.difficulty {
                self.ImagesIV.image = self.SelectRandomImage()
                self.CountL.text = String(numImages)
            }
            else {
                timer.invalidate()
                self.ImagesIV.image = nil
                self.CountL.text = ""
                self.performSegue(withIdentifier: "ToGameView", sender: nil)
            }
        }
    }
}
