import UIKit

class AddPlaceVC: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    let placeNameTextField : UITextField = {
      let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "Place Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let placeTypeTextField : UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "Place Type"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let placeComment : UITextField = {
      let comment = UITextField()
        comment.placeholder = "Comment"
        comment.borderStyle = .roundedRect
        comment.translatesAutoresizingMaskIntoConstraints = false
        return comment
    }()
    
    let Imageview : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Image")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let nextButton : UIButton = {
       let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .lightGray
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "ADD PLACE"
        view.backgroundColor = .systemBackground
        SetupUI()
        nextButton.addTarget(self, action: #selector(toMap), for: .touchUpInside)
        Imageview.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(gesture))
        Imageview.addGestureRecognizer(gesture)
    }
    

    func SetupUI(){
        view.addSubview(placeNameTextField)
        view.addSubview(placeTypeTextField)
        view.addSubview(placeComment)
        view.addSubview(Imageview)
        view.addSubview(nextButton)
        
        
        
        NSLayoutConstraint.activate([placeNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
                                     placeNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     placeNameTextField.heightAnchor.constraint(equalToConstant: 40),
                                     placeNameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
                                    
                                     placeTypeTextField.topAnchor.constraint(equalTo: placeNameTextField.bottomAnchor, constant: 15),
                                     placeTypeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     placeTypeTextField.heightAnchor.constraint(equalToConstant: 40),
                                     placeTypeTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
                                     
                                     placeComment.topAnchor.constraint(equalTo: placeTypeTextField.bottomAnchor, constant: 15),
                                     placeComment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     placeComment.heightAnchor.constraint(equalToConstant: 40),
                                     placeComment.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
                                     
                                     Imageview.topAnchor.constraint(equalTo: placeComment.bottomAnchor, constant: 15),
                                     Imageview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     Imageview.heightAnchor.constraint(equalToConstant: 250),
                                     Imageview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
                                     
                                     nextButton.topAnchor.constraint(equalTo: Imageview.bottomAnchor, constant: 20),
                                     nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     nextButton.heightAnchor.constraint(equalToConstant: 50),
                                     nextButton.widthAnchor.constraint(equalToConstant: 120),
                                     
                                
                                     
                                    
                                    ])
    }
    
    
@objc func toMap(){
    
    if self.placeNameTextField.text !=  "" && self.placeComment.text != ""  && self.placeTypeTextField.text !=  "" {
        if let chosenImage = self.Imageview.image {
            let placeModel = PlaceModel.sharedInstance
            placeModel.placeName = self.placeNameTextField.text!
            placeModel.placeType = self.placeTypeTextField.text!
            placeModel.placeComment = self.placeComment.text!
            placeModel.placeImage = chosenImage
        }
        let mapVC = MapVC()
        navigationController?.pushViewController(mapVC, animated: true)
        
    }else{
        let alert = UIAlertController(title: "Error", message: "Empty Input ?", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    
    
        
    }
    
    @objc func gesture(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedimage = info[.originalImage] as? UIImage {
            Imageview.image = selectedimage
            dismiss(animated: true)
        }
    }
}
