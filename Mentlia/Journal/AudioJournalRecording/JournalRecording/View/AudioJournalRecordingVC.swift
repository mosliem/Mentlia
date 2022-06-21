
import UIKit

class AudioJournalRecordingVC: UIViewController {
    
    var recordButton: UIButton!
    var finishRecordingButton: UIButton!
    var audioRecordingPresenter: JournalRecordingPresenter!
    var recordingWaveView = RecordingWaveView()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioRecordingPresenter = JournalRecordingPresenter(view: self)
        renderView()
    }
    
    
    private func renderView(){
        
        view.backgroundColor = UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)
        title = "Journal Recording"
        navigationController?.navigationBar.tintColor = .white
       
        audioRecordingPresenter.viewDidLoad()
        renderingRecordingButton()
        renderingfinishRecordingButton()
        setupRecordingWaveView()
        
    }
    
    private func renderingRecordingButton() {
        
        let frame = CGRect(x: view.width/2 - 35, y: view.height/2 + 80, width: 70, height: 70)
        recordButton = UIButton(frame: frame)
        recordButton.backgroundColor = .white
        recordButton.tintColor = UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)
        recordButton.layer.cornerRadius = 35
        recordButton.clipsToBounds = true
        
        // add default image and target
        let image = UIImage().setImageSymbolConfiguration(imageName: "play.fill", points: 20, weight: .medium, scale: .medium)
        recordButton.setImage(image, for: .normal)
        recordButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        
        view.addSubview(recordButton)
    }
    
    @objc func playButtonPressed(){
        
        if !recordButton.isSelected{
            
            let image = UIImage().setImageSymbolConfiguration(imageName: "pause.fill", points: 20, weight: .medium, scale: .medium)
            recordButton.setImage(image, for: .selected)
            recordButton.isSelected = true
            audioRecordingPresenter.startRecording()
            
        }
        else{
            
            let image = UIImage().setImageSymbolConfiguration(imageName: "play.fill", points: 20, weight: .medium, scale: .medium)
            recordButton.setImage(image, for: .normal)
            recordButton.isSelected = false
            audioRecordingPresenter.stopRecording()
        }
        
    }
    
    private func renderingfinishRecordingButton(){
        
        let frame = CGRect(x: view.width/2 - 70, y: recordButton.bottom + 60, width: 140, height: 50)
        let tintColor = UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)
        
        finishRecordingButton = UIButton(frame: frame)
        finishRecordingButton.backgroundColor = .white
        finishRecordingButton.layer.cornerRadius = 25
        finishRecordingButton.clipsToBounds = true
    
        
        view.addSubview(finishRecordingButton)
        
        let title = finishRecordingButton.getTitlAttributedString(text: "Finish", textSize: 17, textWeight: .bold, color: tintColor)

        finishRecordingButton.setAttributedTitle(title, for: .normal)
        finishRecordingButton.addTarget(self, action: #selector(finishRecordingButtonPressed), for: .touchUpInside)
    }
    
    func resetRecordButtonState(){
        
        recordButton.isSelected = false
        let image = UIImage().setImageSymbolConfiguration(imageName: "play.fill", points: 20, weight: .medium, scale: .medium)
        recordButton.setImage(image, for: .normal)
        recordButton.isSelected = false

    }
    
    @objc func finishRecordingButtonPressed(){
        finishRecordingButton.showSizingAnimation {
            self.audioRecordingPresenter.finishRecording()
        }
    }
    
}

extension AudioJournalRecordingVC {
    
    func setupRecordingWaveView(){
        
        let recordingViewX = CGFloat(15)
        let recordingViewY = recordButton.top - 300
        let recordingViewWidth = (view.width - 30)
        let recordingViewHeight = CGFloat(250)

        recordingWaveView.frame = CGRect( x: recordingViewX,
                                          y: recordingViewY,
                                          width: recordingViewWidth,
                                          height: recordingViewHeight
                                      )
        view.addSubview(recordingWaveView)

        recordingWaveView.setupContainerViewFrame(
            x: 0,
            y: 0,
            width: recordingViewWidth,
            height: recordingViewHeight
        )
                
        let waveView = recordingWaveView.waveView
        
        recordingWaveView.setupRecordingTimeLabel(
            x: 40, y: 10,
            width: waveView.width - 80,
            height: 90, fontSize: 40
        )
        
        recordingWaveView.setupRecordingWaveFrame(
            x:  10,
            y:  100,
            width: waveView.width - 20,
            height: 145
        )
                
        recordingWaveView.setupRecordingWaveView(color: .white, width: 2, spacing: 3)
        recordingWaveView.setupContainerViewColor(color: UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0))
        
        recordingWaveView.recordingTimeLabel.text = "00:00"
    }
    
    func updateWaveView(value: Float){
        recordingWaveView.updateWaveAmplitude(value: value)
    }
    
    func updateTimeLabel(value: Float){
        recordingWaveView.updateRecordingTimeWithTwoM(time: value)
    }
    
}

extension AudioJournalRecordingVC{
    
    func viewDetailsVC(){
        let vc = AddJournalDetailsVC()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.saveDelegate = self
        present(vc, animated: true)
    }
}
