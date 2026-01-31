import UIKit
import MapKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        SetupUI()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButton))
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocations(gestureRecognizer: )))
        recognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(recognizer)
        
    }
    @objc func chooseLocations(gestureRecognizer : UIGestureRecognizer){
        if gestureRecognizer.state == .began {
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates  = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annatotion = MKPointAnnotation()
            annatotion.title = PlaceModel.sharedInstance.placeName
            annatotion.subtitle = PlaceModel.sharedInstance.placeType
            annatotion.coordinate = coordinates
            
            
            self.mapView.addAnnotation(annatotion)
            
            PlaceModel.sharedInstance.chosenLatitude = String(coordinates.latitude)
            PlaceModel.sharedInstance.chosenLongitude = String(coordinates.longitude)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    func SetupUI(){
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([mapView.topAnchor.constraint(equalTo: view.topAnchor),
                                     mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
    }
    
    
    @objc func saveButton(){
        // save Image to Storage
        let placeModel = PlaceModel.sharedInstance
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        
        if let data = placeModel.placeImage.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data, metadata: nil){metadata,error in
                if let error = error {
                    self.makeAlert(message: error.localizedDescription, title: "ERROR")
                }else{
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            // Have the Url Save datas to FireStore
                            let imageUrl = url?.absoluteString
                            
                            let firestore = Firestore.firestore()
                                                        let fireStorePLace = [
                                "name" : placeModel.placeName ,
                                "type" : placeModel.placeType ,
                                "comment" : placeModel.placeComment ,
                                "imageUrl" : imageUrl! ,
                                "latitude" : placeModel.chosenLatitude ,
                                "longitude" : placeModel.chosenLongitude ,
                                "email" : Auth.auth().currentUser!.email!,
                                "date" : FieldValue.serverTimestamp()
                            ] as [String:Any]
                            
                            firestore.collection("Places").addDocument(data: fireStorePLace){error in
                                if let error = error {
                                    self.makeAlert(message: error.localizedDescription, title: "Error")
                                }
                                else {
                                    // succesfull
                                    self.navigationController?.popToRootViewController(animated: true)
                                }}
                            
                            
                        }
                    }
                }
            }
        }
        
    }
    
    
    func makeAlert(message:String , title:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
