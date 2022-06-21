
import UIKit

class TextJournalEditVC: UIViewController {
    
    //MARK:- View Variables
    
    private var titleTextField: UITextField = {
        
        let textField = UITextField()
        textField.font = .boldSystemFont(ofSize: 22)
        textField.textColor = .black
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "Title", attributes:
                [
                    NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 22) ,
                    NSAttributedString.Key.foregroundColor : UIColor.lightGray
                ]
        )
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
        textView.font = .boldSystemFont(ofSize: 17)
        textView.text = "Write your jounal"
        textView.textColor = .lightGray
        return textView
        
    }()
    
    var saveButton: UIButton = {
        
        let button = UIButton()
        button.backgroundColor = UIColor(
            displayP3Red: 0.62,
            green: 0.61,
            blue: 0.82,
            alpha: 1.0
        )
        
        button.alpha = 0.4
        button.layer.cornerRadius = 7
        button.clipsToBounds = true
        return button
        
    }()
    
    var undoButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName:"arrowshape.turn.up.left.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    var redoButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName:"arrowshape.turn.up.right.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    var lastEditLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    var optionsView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    //MARK:- Variables
    
    var presenter: TextJournalEditPresenter!
    var editedJournal: JournalHomeModel? = nil
    
    //MARK:- Life cycle Functions
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = TextJournalEditPresenter(view: self)
        presenter.viewDidLoad()
        presenter.setEditedJournal(journal: editedJournal)
        renderView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
        
    }
    
    private func renderView(){
        
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        
        renderTitleView()
        renderBackButton()
        renderJournalTextView()
        renderSaveButton()
        renderOptionsView()
        
    }
    
}

//MARK:- Nav bar view and its actions

extension TextJournalEditVC{
    
    private func renderBackButton(){
        
        backButton.frame = CGRect(x: 10, y: 55, width: 40, height: 20)
        let tintColor = UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)
        
        let image = UIImage(named: "right-arrow")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        backButton.tintColor = tintColor
        
        let title = backButton.getTitlAttributedString(text: "Back ", textSize: 15 ,textWeight: .bold, color: tintColor)
        backButton.setAttributedTitle(title, for: .normal)
        
        backButton.semanticContentAttribute = .forceLeftToRight
        backButton.centerTextAndImage(spacing: 25)
        
        backButton.addTarget(self, action: #selector(didPressBack), for: .touchUpInside)
        view.addSubview(backButton)
        
    }
    
    @objc func didPressBack(){
        
        presenter.backWithoutSaving(title: titleTextField.text, body: jounralTextView.text, lastEdit: lastEditLabel.text)
        
    }
    
    private func renderSaveButton(){
        
        saveButton.frame = CGRect(x: view.width - 75 , y: backButton.top - 5, width: 60, height: 30)
        
        let title = saveButton.getTitlAttributedString(text: "Save", textSize: 15 ,textWeight: .bold, color: .white)
        saveButton.setAttributedTitle(title, for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        
        saveButton.addTarget( self, action: #selector(didTapSaveButton), for: .touchUpInside)
        view.addSubview(saveButton)
        
    }
    
    @objc func didTapSaveButton(){
        
        saveButton.showSizingAnimation {
            
            self.presenter.vaildateTitleAndBody(title: self.titleTextField.text , body: self.jounralTextView.text, lastEdit: self.lastEditLabel.text!)
            
        }
        
    }
    
}


//MARK:- Journal Details View

extension TextJournalEditVC {
    
    private func renderTitleView(){
        
        titleTextField.frame = CGRect(x: 15, y: backButton.bottom + 90 , width: view.width, height: 60)
        view.addSubview(titleTextField)
        
    }
    
    private func renderJournalTextView(){
        
        jounralTextView.delegate = self
        
        jounralTextView.frame = CGRect(x: 12, y: titleTextField.bottom + 15, width: view.width - 30, height: view.height - (titleTextField.height + 15))
        view.addSubview(jounralTextView)
        
    }
    
    func popVC(){
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    
}

//MARK:- Undo and Redo view and actions

extension TextJournalEditVC{
    
    private func renderOptionsView(){
        
        optionsView.frame = CGRect(x: 0, y: view.bottom - 60, width: view.width, height: 60)
        optionsView.backgroundColor = UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)
        view.addSubview(optionsView)
        
        undoButton.frame = CGRect(x: (optionsView.width / 2) - 85 , y: (optionsView.height / 2) - 15, width: 20, height: 20)
        undoButton.addTarget(self, action: #selector(didTapUndo), for: .touchUpInside)
        optionsView.addSubview(undoButton)
        
        redoButton.frame = CGRect(x:  (optionsView.width / 2) + 65 , y:  (optionsView.height / 2) - 15 , width: 20, height: 20)
        redoButton.addTarget(self, action: #selector(didTapRedo), for: .touchUpInside)
        optionsView.addSubview(redoButton)
        
        lastEditLabel.frame = CGRect(x: undoButton.right + 7, y: redoButton.top, width: redoButton.left - undoButton.right - 14, height: 20)
        optionsView.addSubview(lastEditLabel)
    }
    
    @objc func didTapUndo(){
        
        presenter.undoTextView()
        presenter.getLastEditTime()
    }
    
    @objc func didTapRedo(){
        
        presenter.redoTextView()
        presenter.getLastEditTime()
        
    }
    
    func enableDisableUIControl() {
        
        self.undoButton.isEnabled = presenter.undoManager.canUndo
        self.redoButton.isEnabled = presenter.undoManager.canRedo
        
    }
    
    func updateTextViewtText(newText: String){
        jounralTextView.text = newText
    }
    
    func updateLastEditLabel(time: String){
        lastEditLabel.text = time
    }
}

//MARK:- setting Edited journal data
// in case if a saved journal is being edited again

extension TextJournalEditVC {
    
    func setEditedJournalData(title: String , body: String, lastEdit: String){
        
        self.titleTextField.text = title
        self.jounralTextView.text = body
        self.jounralTextView.textColor = .black
        self.lastEditLabel.text = lastEdit
        
    }
}
