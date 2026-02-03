import UIKit
import FirebaseFirestore
import FirebaseAuth
class PlacesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let tabelView = UITableView()
    var PlaceNames = [String]()
    var placeID = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupUI()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Places"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOut))
        
    }
    
    func SetupUI() {
        getDatafromFirestore()
        view.addSubview(tabelView)
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.translatesAutoresizingMaskIntoConstraints = false
        tabelView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        NSLayoutConstraint.activate([tabelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     tabelView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     tabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     tabelView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }
    
    func getDatafromFirestore(){
        let firestore = Firestore.firestore()
        
        firestore.collection("Places").order(by: "date").addSnapshotListener{ (snapshot, error ) in
            if let error = error {
                self.makeAlert(message: error.localizedDescription, title: "Error")
            }else{
                if let snapshot = snapshot , !snapshot.isEmpty{
                    self.PlaceNames.removeAll()
                    self.placeID.removeAll()
                    
                    for document in snapshot.documents{
                        if let name = document["name"] as? String{
                            self.PlaceNames.append(name)
                            self.placeID.append(document.documentID)
                        }
                            
                    }
                    self.tabelView.reloadData()
                }
            }
        }
    }
    
    @objc func logOut(){
        do {
            try Auth.auth().signOut()
            let signUPVC = SignUpVC()
               let signUpnav = UINavigationController(rootViewController: signUPVC)
            
               guard let window = view.window else {return}
               window.rootViewController = signUpnav
               UIView.transition(with: window, duration: 0.3, options: .curveEaseOut, animations: nil, completion: nil)
               
        } catch  {
            print(error.localizedDescription)
            
        }
    }
    
    @objc func addButtonClicked(){
        let Addplace = AddPlaceVC()
        // push yapıyoruz geri dönülebilir
        
        navigationController?.pushViewController(Addplace, animated: true)
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlaceNames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = PlaceNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailsVC()
        detailVC.chosenPlaceID = placeID[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func makeAlert(message:String,title:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}

