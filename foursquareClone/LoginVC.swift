
import UIKit

class LoginVC: UIViewController {
    
    private let appNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Foursquare Clone"
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let emailText: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "email:"
        tf.layer.cornerRadius = 8
        tf.layer.borderWidth = 2
        tf.clipsToBounds = true
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0)
        return tf
    }()
    
    private let passwordText: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "password:"
        tf.layer.cornerRadius = 8
        tf.layer.borderWidth = 2
        tf.clipsToBounds = true
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0)
        return tf
    }()
    
    private let signInButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign In", for: UIControl.State.normal)
        button.tintColor = .white
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: UIControl.State.normal)
        //button.tintColor = .white
        button.setTitleColor(.white, for: UIControl.State.normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 8
        return button
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        
    }
    
    
    
    
    
    
    
    
    
    
    
    func setupUI( ){
        
        view.addSubview(appNameLabel)
        view.addSubview(emailText)
        view.addSubview(passwordText)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: UIControl.Event.touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: UIControl.Event.touchUpInside)
        
        NSLayoutConstraint.activate([
            
            appNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            appNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            appNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            emailText.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 175),
            emailText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailText.heightAnchor.constraint(equalToConstant: 44),
            
            passwordText.topAnchor.constraint(equalTo: emailText.bottomAnchor, constant: 20),
            passwordText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordText.heightAnchor.constraint(equalToConstant: 44),
            
            signInButton.topAnchor.constraint(equalTo: passwordText.bottomAnchor, constant: 25),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            signInButton.widthAnchor.constraint(equalToConstant: 80),
            
            signUpButton.topAnchor.constraint(equalTo: passwordText.bottomAnchor, constant: 25),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            signUpButton.widthAnchor.constraint(equalToConstant: 80)
            
            
            
        ])
    }
    
    @objc func signInButtonTapped( ){
        
        
    }
    
    @objc func signUpButtonTapped( ){
        
    }
    


}

