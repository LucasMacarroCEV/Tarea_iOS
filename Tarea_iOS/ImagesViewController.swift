
import UIKit

class ImagesViewController: UIViewController {
    
    @IBOutlet weak var ImagesIV: UIImageView!
    @IBOutlet weak var CountL: UILabel!
    
    var imagesArray: [UIImage] = [
        UIImage(named: "bird")!,
        UIImage(named: "crocodile")!,
        UIImage(named: "dog")!,
        UIImage(named: "giraffe")!,
        UIImage(named: "lion")!,
        UIImage(named: "shark")!,
        UIImage(named: "whale")!
    ]
    var usedImagesArray: [UIImage] = []
    
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
            let randomInt = Int.random(in: 0..<imagesArray.count)
            currentImage = imagesArray[randomInt]
            
            if !usedImagesArray.contains(currentImage){
                usedImagesArray.append(currentImage)
                return currentImage
            }
        }
    }
    func ChangeImage() {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) {(timer) in
            self.ImagesIV.image = self.SelectRandomImage()
            
            self.numImages += 1
            self.CountL.text = String(self.numImages)
            
            if self.numImages == 3 {
                timer.invalidate()
            }
        }
    }
}
