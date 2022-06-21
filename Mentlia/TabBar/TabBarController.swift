
import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        roundTabBar()
        setupTabBar()
        tabBar.setTransparentTabbar()

        tabBar.items!.first?.titlePositionAdjustment = UIOffset(horizontal: 20, vertical: 0.0)
        tabBar.items!.last?.titlePositionAdjustment = UIOffset(horizontal: -15, vertical: 0.0)


    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true

    }
    
    
    private func roundTabBar(){
        
        let layer = CAShapeLayer()

        layer.path = UIBezierPath(roundedRect: CGRect(x: 30, y: self.tabBar.bounds.minY + 2, width: self.tabBar.bounds.width - 60, height: self.tabBar.bounds.height+10), cornerRadius: (self.tabBar.frame.width/2)).cgPath
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.7
        layer.borderWidth = 1.0
        layer.opacity = 1.0
        layer.isHidden = false
        layer.masksToBounds = false
        layer.fillColor = UIColor.white.cgColor

        tabBar.clipsToBounds = true
        self.tabBar.layer.insertSublayer(layer, at: 0)
        tabBar.tintColor = UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)

        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font: UIFont(name: "CircularStd-Black", size: 14)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
       
    }
    
    
    func setupTabBar() {
        
        let mainStorybaord = UIStoryboard(name: "Main", bundle: nil)
        let authStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        
        let journalHomeVC = JournalHomeVC()
        let dashboardVC = mainStorybaord.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
        let profileVC = authStoryboard.instantiateViewController(withIdentifier:"ProfileVC") as! ProfileVC
        
        let journalNav = UINavigationController(rootViewController: journalHomeVC)
        let dashboardNav = UINavigationController(rootViewController: dashboardVC)
        let profileNav = UINavigationController(rootViewController: profileVC)

        journalNav.navigationBar.prefersLargeTitles = true
        dashboardNav.navigationBar.isHidden = true

        journalNav.tabBarItem = UITabBarItem(title: "Journals", image: UIImage(systemName: "books.vertical"), tag: 1)
        dashboardNav.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "waveform.path.ecg.rectangle"), tag: 1)
        profileNav.tabBarItem = UITabBarItem(title:"Profile", image: UIImage(systemName:"person.crop.circle"),tag: 1)
        
        setViewControllers([dashboardNav,journalNav,profileNav], animated: false)
    }
    

}
