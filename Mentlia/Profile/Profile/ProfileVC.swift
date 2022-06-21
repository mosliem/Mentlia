

import UIKit
import FirebaseFirestore
import SDWebImage
import FirebaseAuth

class ProfileVC: UIViewController {
    
    let dataBase = Firestore.firestore()
    var profilePresenter: ProfilePresenter!
    @IBOutlet weak var profilepPctureImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var logOutIcon: UIImageView!
    
    @IBOutlet weak var arrow1ImageView: UIImageView!
    @IBOutlet weak var arrow3ImageView: UIImageView!
    
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profilePresenter = ProfilePresenter(View: self)

        circleImageView(image: profilepPctureImageView)
        setupIcons()
        profilepPctureImageView.image = UIImage(named: "defaultProfilePicture")
        self.userNameLabel.font = UIFont(name: "CircularStd-Black", size: 20)
        setButtons()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        profilePresenter.getUserFullName()
        profilePresenter.getProfileImage()


    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setButtons(){
        setButton(button: editProfileButton)
        setButton(button: logOutButton)
    }
    
    
    func setButton(button: UIButton){
        button.backgroundColor = .clear
        button.layer.cornerRadius = 12
        button.setTitleColor(UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0), for: .normal)        
    }
    
    func setupIcons(){
        setIcon(icon: profileIcon, imageName: "user")
        setIcon(icon: logOutIcon, imageName: "log out")
        setIcon(icon: arrow1ImageView, imageName: "arrow")
        setIcon(icon: arrow3ImageView, imageName: "arrow")
        
    }
    
    
    func loadImage(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.profilepPctureImageView.image = image
                    }
                }
            }
        }
    }
    
    
    
    func setIcon(icon: UIImageView, imageName: String){
        icon.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)
        
    }
    
    func setRounded() {
        profilepPctureImageView.clipsToBounds = true
        profilepPctureImageView.layer.cornerRadius = 35
        profilepPctureImageView.tintColor = .systemBlue
    }
    
    func circleImageView(image: UIImageView){
        image.contentMode = UIView.ContentMode.scaleAspectFill
        image.layer.cornerRadius = image.bounds.width / 2
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        
    }
    
    func goToSignIn(){
        let lginVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(lginVC, animated: true)
    }
    
    func pushEditProfileVC(){
        let editProfileVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    
    @IBAction func editProfileButtonPressed(_ sender: UIButton) {
        pushEditProfileVC()
    }
    
    @IBAction func reportsButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        profilePresenter.signOut()
        
    }
    
    func popToRootVC(){
        let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let navigationController = UINavigationController(rootViewController: login)
        self.view.window?.rootViewController = navigationController
        
    }
    
}

