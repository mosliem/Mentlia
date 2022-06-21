

import UIKit

class JournalHomeVC: UIViewController {
    
    let journalsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { (section, _) -> NSCollectionLayoutSection? in
        return JournalHomeVC.createSectionLayout(section: section)
    }))
    
    private let noJournalsLabel: UILabel = {
        let label = UILabel()
        label.text = "There is no journals yet!"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    var addButton: UIButton!
    var journalHomePresenter: JournalsHomePresenter!
    let refreshControl = UIRefreshControl()

  
    override func viewDidLoad() {
        
        super.viewDidLoad()

        journalHomePresenter = JournalsHomePresenter(view: self)
        journalHomePresenter.viewDidLoad()
        renderView()
         
    }
    
    func renderView(){
        
        setupNavBar()
        renderCollectionView()
        setupCollectionView()
        renderAddButton()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true

        journalHomePresenter.fetchAllJournals()

    }
    
    
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(180))
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(180)), subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        return section
        
    }
    private func setupNavBar(){
        
        self.navigationItem.title = "My Journal Entries"
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white ,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30 , weight: .bold)
        ]
    }
    
    private func setupCollectionView(){
        
        journalsCollectionView.delegate = self
        journalsCollectionView.dataSource = self
        journalsCollectionView.register(JournalHomeCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
         
        // adding refresh controll
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        journalsCollectionView.addSubview(refreshControl)
        
    }
    
    // refresh action
    @objc func refresh(_ sender: AnyObject) {
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            
            self.journalHomePresenter.fetchAllJournals()
            self.refreshControl.endRefreshing()
        
        }
        
    }
    
    private func renderCollectionView(){
        view.addSubview(journalsCollectionView)
        journalsCollectionView.frame = view.bounds
        journalsCollectionView.backgroundColor = UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)
    }
    
    func viewNoJournalLabel(){
        noJournalsLabel.frame = CGRect(x: view.center.x - (view.width - 50 )/2, y: view.center.y - 120, width: view.width - 50, height: 80)
        noJournalsLabel.isHidden = false
        view.addSubview(noJournalsLabel)
    }
    
    func hideNoJournalLabel(){
        noJournalsLabel.isHidden = true
    }
    
    func reloadData(){
        
        journalsCollectionView.reloadData()
    
    }
    

    private func renderAddButton(){
        
        let tintColor = UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)

        addButton = UIButton()
        
        addButton.layer.cornerRadius = 30
        addButton.clipsToBounds = true
        
        addButton.frame = CGRect(x: view.right - 75 , y: (tabBarController?.tabBar.top)! - 70, width: 60, height: 60)
        view.addSubview(addButton)
        
        let audioJournal = UIAction(
            title: "Audio journal",
            image: UIImage(named: "radio")?.withTintColor(tintColor)) { (action) in
            
            self.journalHomePresenter.didSelectAudioJournal()
        }
        
        let textImage = UIImage(systemName:"book")?.withTintColor(tintColor, renderingMode: .alwaysOriginal)
        
        let textJournal = UIAction(
            title: "Text journal",
            image: textImage ) { (action) in
            self.journalHomePresenter.didSelectTextJounral()
        }
        
        let menu = UIMenu(title: "", image: nil, options: .displayInline, children: [textJournal,audioJournal])
        addButton.menu = menu
        addButton.showsMenuAsPrimaryAction = true
        
    }
    
    // functions to change the color of add button due to journals count.
    /// make the button visible at all status
    
    //when the count of journal is more than 3
    func setPurpleAddButton(){
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .semibold, scale: .medium)
        let addButtomImage =  UIImage(systemName: "plus", withConfiguration: imageConfig)
        addButton.setImage(addButtomImage, for: .normal)
        addButton.tintColor = .white
        addButton.backgroundColor = UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)
    }
    
    //when the count of journal is less than 3
    func setWhiteAddButton(){
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .semibold, scale: .medium)
        let addButtomImage =  UIImage(systemName: "plus", withConfiguration: imageConfig)
        addButton.setImage(addButtomImage, for: .normal)
        addButton.tintColor = UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)
        addButton.backgroundColor = .white
    }
    
    
    
    func moveToAudioRecordingVC(){
        
        let vc = AudioJournalRecordingVC()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveToAudioPlayerVC(journal: JournalHomeModel){
      
        let vc = AudioJournalPlayerVC()
        vc.modalPresentationStyle = .fullScreen
        vc.audioJournal = journal
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func moveToTextJounalView(){
        
        let vc = TextJournalEditVC()
        vc.modalPresentationStyle = .fullScreen
        vc.navigationController?.navigationBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)

    }
    
    func moveToTextViewerVC(journal: JournalHomeModel){
        
        let vc = TextJournalViewerVC()
        vc.modalPresentationStyle = .fullScreen
        vc.textJournal = journal
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
