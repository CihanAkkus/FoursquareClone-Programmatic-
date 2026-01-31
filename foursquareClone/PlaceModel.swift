

import Foundation
import UIKit
class PlaceModel {
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeComment = ""
    var placeImage = UIImage()
    var chosenLongitude = ""
    var chosenLatitude = ""
    
    private init(){}
}
