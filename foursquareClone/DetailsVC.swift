import UIKit
import MapKit
import FirebaseFirestore
import SDWebImage


class DetailsVC: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    var chosenLongitude = Double()
    var chosenLatitude = Double()
    var chosenPlaceID = ""
    let ImageView : UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
       
        return image
    }()
    
    let NameLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    let TypeLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    
    let CommentLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
        
    }()
    
    let MapView : MKMapView = {
       let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupUI()
        getdata()
        view.backgroundColor = .systemBackground
        MapView.delegate = self
    }
    func getdata(){
        let firestore = Firestore.firestore()
        firestore.collection("Places").document(chosenPlaceID).getDocument() { (snapshot , error) in
            if let error = error {
                self.makeAlert(message: error.localizedDescription, title: "Error")
            }else{
                if let snapshot = snapshot , snapshot.exists{
                    let data = snapshot.data()
                    
                    self.NameLabel.text = data?["name"] as? String
                    self.TypeLabel.text = data?["type"] as? String
                    self.CommentLabel.text = data?["comment"] as? String
                    
                    if let lat = data?["latitude"] as? String {
                        self.chosenLatitude = Double(lat) ?? 0.0
                    }
                    if let long = data?["longitude"] as? String {
                        self.chosenLongitude = Double(long) ?? 0.0
                    }
                    
                    if let imageUrl = data?["imageUrl"] as? String{
                        
                        self.ImageView.sd_setImage(with: URL(string: imageUrl))
                    }else {
                        print("Error")
                    }
                    // map Pinning
                    let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                    let region = MKCoordinateRegion(center: location, span: span)
                    self.MapView.setRegion(region, animated: true)
                    
                    
                    let annation = MKPointAnnotation()
                    annation.coordinate = location
                    annation.title = self.NameLabel.text
                    annation.subtitle = self.TypeLabel.text
                    self.MapView.addAnnotation(annation)
                    
                    
                }
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {return nil}
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            // Bilgi butonuna basınca navigasyon açılması için
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        }
        else{
            pinView?.annotation = annotation
        }
        return pinView
    }
    // Navigasyonu Açma (Harita butonuna tıklanınca)
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if self.chosenLongitude != 0.0 && self.chosenLatitude != 0.0 {
                let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                
                CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                    if let placemark = placemarks?.first {
                        let mkPlaceMark = MKPlacemark(placemark: placemark)
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.NameLabel.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    
    
    func SetupUI(){
        
        view.addSubview(ImageView)
        view.addSubview(NameLabel)
        view.addSubview(TypeLabel)
        view.addSubview(CommentLabel)
        view.addSubview(MapView)
        MapView.delegate = self
        NSLayoutConstraint.activate([ImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:10 ),
                                     ImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     ImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
                                     ImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
                                    
                                     NameLabel.topAnchor.constraint(equalTo: ImageView.bottomAnchor, constant: 10),
                                     NameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     NameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor ),
                                     NameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     
                                     TypeLabel.topAnchor.constraint(equalTo: NameLabel.bottomAnchor, constant: 10),
                                     TypeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     TypeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     TypeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     
                                     CommentLabel.topAnchor.constraint(equalTo: TypeLabel.bottomAnchor, constant: 10),
                                     CommentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     CommentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     CommentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     
                                     MapView.topAnchor.constraint(equalTo: CommentLabel.bottomAnchor, constant: 10),
                                     MapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                                     MapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     MapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40),
                                     MapView.widthAnchor.constraint(equalTo: view.widthAnchor)
                                    ])
    }
    func makeAlert(message:String,title:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }

}
