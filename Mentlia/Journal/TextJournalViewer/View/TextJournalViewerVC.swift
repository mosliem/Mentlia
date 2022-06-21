
import UIKit

class TextJournalViewerVC: UIViewController {
    
    //MARK:- View Variables
    
    private var titleTextField: UITextField = {
        
        let textField = UITextField()
        textField.font = .boldSystemFont(ofSize: 22)
        textField.textColor = .white
        textField.backgroundColor = .clear
        textField.layer.cornerRadius = 15
        textField.clipsToBounds = true
        textField.isEnabled = false
        textField.setLeftPaddingPoints(7)
        textField.setRightPaddingPoints(7)
        return textField
        
    }()
    
    private var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    var jounralTextView: UITextView = {
        
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.isEditable = false
        textView.font = .boldSystemFont(ofSize: 17)
        textView.textColor = .white
        textView.backgroundColor = .darkGray
        textView.layer.cornerRadius = 20
        textView.clipsToBounds = false
        textView.setPadding(7)
        textView.layer.shadowOpacity = 0.3
        textView.layer.shadowRadius = 3
        textView.layer.shadowColor = UIColor.darkGray.cgColor
        return textView
        
    }()
    
    var editButton: UIButton = {
        
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 7
        button.clipsToBounds = true
        return button
        
    }()
    
    var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        return button
    }()
    
    var presenter: TextJournalViewerPresenter!
    var textJournal: JournalHomeModel!
    
    //MARK:- Life cycle Functions
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        presenter = TextJournalViewerPresenter(view: self, journal: textJournal)
        presenter.viewDidLoad()
        renderView()
        
    }
    
    
    private func renderView(){
        
        view.backgroundColor = UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)
        self.navigationController?.navigationBar.isHidden = true
        
        renderTitleView()
        renderBackButton()
        renderJournalTextView()
        renderEditButton()
        renderDeleteButton()
        
    }
}

//MARK:- Nav bar view and its actions

extension TextJournalViewerVC{
    
    private func renderBackButton(){
        
        backButton.frame = CGRect(x: 10, y: 55, width: 40, height: 20)
        
        let image = UIImage(named: "right-arrow")?.withRenderingMode(.alwaysTemplate)
        backButton.imageView?.tintColor = .white
        backButton.setImage(image, for: .normal)
        
        
        let title = backButton.getTitlAttributedString(text: "Back", textSize: 15 ,textWeight: .bold, color: .white)
        backButton.setAttributedTitle(title, for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        
        backButton.semanticContentAttribute = .forceLeftToRight
        backButton.centerTextAndImage(spacing: 25)
        
        backButton.addTarget(self, action: #selector(didPressBack), for: .touchUpInside)
        view.addSubview(backButton)
        
    }
    
    @objc func didPressBack(){
        
        navigationController?.popViewController(animated: true)
    }
    
    private func renderEditButton(){
        
        editButton.frame = CGRect(x: view.width - 75 , y: backButton.top - 5, width: 60, height: 30)
        let tintColor = UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)
        
        let title = editButton.getTitlAttributedString(text: "Edit", textSize: 15 ,textWeight: .bold, color: tintColor)
        editButton.setAttributedTitle(title, for: .normal)
    
        editButton.addTarget( self, action: #selector(didTapEditButton), for: .touchUpInside)
        view.addSubview(editButton)
        
    }
    
    @objc func didTapEditButton(){
        
        editButton.showSizingAnimation {
            self.presenter.pressEditButton()
        }
    }
    
}

//MARK:- Journal Details View
extension TextJournalViewerVC {
    
    private func renderTitleView(){
        
        titleTextField.frame = CGRect(x: 15, y: backButton.bottom + 90 , width: view.width - 30, height: 60)
        view.addSubview(titleTextField)
        
    }
    
    private  func renderJournalTextView(){
        
        jounralTextView.frame = CGRect(x: 12, y: titleTextField.bottom + 15, width: view.width - 24, height: view.bottom - (titleTextField.height + 15) - 200)
        view.addSubview(jounralTextView)
    }
    
    func popVC(){
        navigationController?.popViewController(animated: true)
    }
    
    func moveToEditView(){
        
        let vc = TextJournalEditVC()
        vc.editedJournal = textJournal
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

// setting the data
extension TextJournalViewerVC{
    
    func setJournalTitleAndBody(title: String, body: String){
        
        titleTextField.text = title
        jounralTextView.text = body
        
    }
    
}

//MARK:- Delete view and actions

extension TextJournalViewerVC{
    
    private func renderDeleteButton(){
        
        deleteButton.frame = CGRect(x: view.center.x - 70, y: jounralTextView.bottom + 12, width: 140, height: 50)
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        
        let title = deleteButton.getTitlAttributedString(text: "delete", textSize: 17, textWeight: .bold, color: .white)
        deleteButton.setAttributedTitle(title, for: .normal)
        
        view.addSubview(deleteButton)
        
    }
    
    @objc func didTapDelete(){
        deleteButton.showSizingAnimation {
            self.presenter.deleteTextJournal()
        }
    }
}
