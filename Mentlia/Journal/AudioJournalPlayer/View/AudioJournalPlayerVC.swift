//  Created by mohamedSliem on 4/19/22.

import UIKit

class AudioJournalPlayerVC: UIViewController {
    
    var audioJournal: JournalHomeModel!
    var presenter: AudioJournalPlayerPresenter!
    
    var playPauseButton = UIButton()
    
    var audioSlider : UISlider!
    
    var noteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "Note"
        return label
    }()
    
    var noteTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = .boldSystemFont(ofSize: 15)
        textView.layer.cornerRadius = 7
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.isEditable = false
        textView.isSelectable = false
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.font = .boldSystemFont(ofSize: 15)
        textView.setPadding(7)
        return textView
    }()
    
    var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 14)
        label.text = "00:00"
        return label
    }()
    
    var durationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = AudioJournalPlayerPresenter(audioJournal: audioJournal, view: self)
        presenter.viewDidLoad()
        renderView()
        
    }
    
    func renderView(){
        
        title = presenter.getJournalTitle()
        self.view.backgroundColor = UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)

        navigationController?.navigationBar.tintColor = .white
        
        renderNoteView()
        renderPlayerSlider()
        renderPlayPauseButton()
        renderCurrentTimeView()
        renderDeleteButton()
        
    }
    
    func popVCBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK:- PLayPauseButton
//PLayPauseButton view and actions
extension AudioJournalPlayerVC {
    func renderPlayPauseButton(){
        
        
        let frame = CGRect(x: view.width/2 - 35, y: audioSlider.bottom + 20, width: 70, height: 70)
        playPauseButton = UIButton(frame: frame)
        playPauseButton.backgroundColor = .white
        playPauseButton.tintColor = UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)
        playPauseButton.layer.cornerRadius = 35
        playPauseButton.clipsToBounds = true
        
        // add default image and target
        let image = UIImage().setImageSymbolConfiguration(imageName: "play.fill", points: 20, weight: .medium, scale: .medium)
        playPauseButton.setImage(image, for: .normal)
        playPauseButton.addTarget(self, action: #selector(playPauseButtonPressed), for: .touchUpInside)
        view.addSubview(playPauseButton)
        
    }
    
    @objc func playPauseButtonPressed(){
        presenter.tapPlayPauseButton()
    }
    
    func changePlayPauseButtonState(isSelected: Bool){
        
        if isSelected{
            
            let image = UIImage().setImageSymbolConfiguration(imageName: "pause.fill", points: 20, weight: .medium, scale: .medium)
            playPauseButton.setImage(image, for: .selected)
            playPauseButton.isSelected = true
        }
        else{
            
            let image = UIImage().setImageSymbolConfiguration(imageName: "play.fill", points: 20, weight: .medium, scale: .medium)
            playPauseButton.setImage(image, for: .normal)
            playPauseButton.isSelected = false
        }
    }
}

//MARK:- Note View
//Note view
extension AudioJournalPlayerVC{
    
    func renderNoteView(){
        noteLabel.frame = CGRect(x: 20, y: 160 , width: 70, height: 30)
        view.addSubview(noteLabel)
        
        noteTextView.frame = CGRect(x: 15, y: noteLabel.bottom + 5 , width: view.width - 30, height: 80)
        noteTextView.text = presenter.getNoteData()
        noteTextView.adjustTextViewHeight()
        view.addSubview(noteTextView)
    }
    
}

//MARK:- Player Slider
//Slider view and Functions
extension AudioJournalPlayerVC{
    
    func renderPlayerSlider(){
        
        audioSlider = UISlider(frame: CGRect(x: 20, y: view.center.y, width: view.width - 40, height: 10))
        
        audioSlider.tintColor = .white
        audioSlider.maximumTrackTintColor = .lightGray
        
        // customize thumb image
        let image = UIImage().setImageSymbolConfiguration(imageName: "circle.fill", points: 15, weight: .medium, scale: .medium)
        audioSlider.setThumbImage(image, for: .normal)
        audioSlider.minimumValue = 0.0
        view.addSubview(audioSlider)
        
        audioSlider.addTarget(self, action: #selector(didSlideSlider), for: .touchDragInside)
        setSliderMaxValue()
    }
    
    func setSliderMaxValue(){
        audioSlider.maximumValue = presenter.getAudioDuration()!
    }
    
    func changeSliderValue(value: Float){
        
        audioSlider.value = value
        
    }
    
    @objc func didSlideSlider(){
        
        presenter.changeSliderValue(value: audioSlider.value)
        
    }
}


//MARK:- Player Timer
//player timer view and functions
extension AudioJournalPlayerVC{
    
    func renderCurrentTimeView(){
        currentTimeLabel.frame = CGRect(x: 22, y: audioSlider.bottom + 5, width: 60, height: 20)
        view.addSubview(currentTimeLabel)
        
        durationLabel.frame = CGRect(x: audioSlider.right - 62, y: audioSlider.bottom + 5, width: 60, height: 20)
        durationLabel.text = presenter.getDuration()
        durationLabel.textAlignment = .right
        view.addSubview(durationLabel)
    }
    
    func changeCurrentTime(value: String){
        currentTimeLabel.text = value
    }
}

//MARK:- Delete Action
//Delete Button View and actions
extension AudioJournalPlayerVC{
    
    func renderDeleteButton(){
        
        deleteButton.frame = CGRect(x: view.center.x - 70, y: durationLabel.bottom + 180, width: 140, height: 50)
        view.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        let title = deleteButton.getTitlAttributedString(text: "delete", textSize: 17, textWeight: .bold, color: .white)
        deleteButton.setAttributedTitle(title, for: .normal)
    }
    
    @objc func didTapDelete(){
        deleteButton.showSizingAnimation {
            self.presenter.deleteAudioJournal()
        }
    }
}



