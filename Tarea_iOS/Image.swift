
import Foundation
import UIKit

class Image {
    var name: String
    var image: UIImage
    
    init(name: String, image: UIImage){
        self.name = name
        self.image = image
    }
    
    static func CompareImages(image1: Image, image2: Image) -> Bool{
        if image1.name == image2.name {return true} else {return false}
    }
    
    static func CheckImageArray(imagesArray: Array<Image>, image: Image) -> Bool{
        var result: Bool = false
        for i in 0..<imagesArray.count {
            if CompareImages(image1: image, image2: imagesArray[i]) {
                result = true
                break
            }
        }
        return result
    }
}
