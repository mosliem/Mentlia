
import UIKit

class AddJournalDetailsVC: UIViewController {
    
    var detailsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    var viewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Journal Details"
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    var noteLabel: UILabel = {
        let label = UILabel()
        label.text = "Notes"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    var titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 15)
        textField.layer.cornerRadius = 7
        textField.layer.borderWidth = 0.3
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.setRightPaddingPoints(7)
        textField.setLeftPaddingPoints(7)
        return textField
    }()
    
    var noteTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 15)
        textView.layer.cornerRadius = 7
        textView.layer.borderWidth = 0.3
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.setPadding(7)
        return textView
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.layer.cornerRadius = 20
        let title = button.getTitlAttributedString(text: "cancel", textSize: 17, textWeight: .bold, color: .white)
        button.setAttributedTitle(title, for: .normal)
        return button
    }()
    
    var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        let title = button.getTitlAttributedString(text: "save", textSize: 17, textWeight: .bold, color: .white)
        button.setAttributedTitle(title, for: .normal)
        return button
    }()
    
    
    private var presenter: AddDetailsPresenter!
    weak var saveDelegate: AddJournalDetailProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.definesPresentationContext = true
    
        presenter = AddDetailsPresenter(view: self)
        
        noteTextView.delegate = self
        titleTextField.delegate = self
        
        renderView()
    }
    
    private func renderView(){
        
        renderContainerView()
        renderTitelArea()
        renderNoteArea()
        renderCancelButton()
        renderSaveButton()
        
    }
    
    @objc func didPressSaveButton(){
        presenter.pressSave()
    }
    
    @objc func didPressCancelButton(){
        presenter.pressCancel()
    }
    
    func dismissViewWithCancel(){
        cancelButton.showSizingAnimation {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func getTitleText() -> String? {
        return titleTextField.text
    }
    
    func dismissViewWithSave(){
        saveButton.showSizingAnimation {
            self.saveDelegate?.didSaveJournalDetails(title: self.titleTextField.text!, note: self.noteTextView.text)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}



