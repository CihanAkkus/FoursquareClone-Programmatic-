//
//  PlacesVC.swift
//  foursquareClone
//
//  Created by Cihan on 31.01.2026.
//

import UIKit
import FirebaseAuth

class PlacesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutButtonTapped))
    
        
    }
    
    @objc func addButtonTapped( ){
        
        let destinationVC = AddPlaceVC()
        
        navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    
    @objc func logoutButtonTapped( ){
        
        do{
            try Auth.auth().signOut()
            
            let loginVC = SignUpVC()
            
            if let windowsScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let delegate = windowsScene.delegate as? SceneDelegate,
               let window = delegate.window{
                
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
                    window.rootViewController = loginVC
                }
                
            }
            
        }catch{
            print(error.localizedDescription)
        }
        
        
    }
    


}
