
import Foundation
import AVFoundation

class AudioJournalRecorder: NSObject , AVAudioRecorderDelegate {
    
    var recordingSession: AVAudioSession?
    var audioRecorder: AVAudioRecorder?
    var audioRecordName: String?
    var audioDuration: Float?
    var recordingDurationTimer: Timer?
    var recordingWaveRefreshTimer: Timer?
    
    weak var presenter: JournalRecordingPresenter!
    
    init(presenter: JournalRecordingPresenter){
        self.presenter = presenter
    }
    

    func getRecordingState() -> Bool{
          
        if  audioRecorder?.isRecording == false {
            
            return true
        }
        
        return false
    }
    
    func getCurrentTime() -> Double {
        return audioRecorder?.currentTime ?? 0.0
    }
    
    func setAudioName(name : String){
        audioRecordName = name
    }
    
    func checkRecordingPermission(){
        
        recordingSession = AVAudioSession.sharedInstance() //shared audio Session
        
        do {
            try recordingSession?.setCategory(.record , mode: .default)
            try recordingSession?.setActive(true)
            
            recordingSession?.requestRecordPermission({ [unowned self] allowed in
    
                if allowed {
                    
                    startRecording()
                }
            })
        }
        catch{
            print(error)
        }
    }
    
    func startRecording(){
        
        print("start recording")
        
        let audioPath = getDocumentsDirectory().appendingPathComponent(audioRecordName!)
        print(audioPath)
        let settings = [
            AVFormatIDKey : Int(kAudioFormatLinearPCM),
            AVNumberOfChannelsKey : 1 ,
            AVSampleRateKey : 12000,
            AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue
        ]
        
        do {
            
            try audioRecorder = AVAudioRecorder(url: audioPath , settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            fireWaveRecordingTimer()
            fireAudioRecordingTimer()
            
        }
        catch {
            finishRecording(success: false)
        }
    }
    
    func stopRecording(){
        audioRecorder?.pause()
        recordingWaveRefreshTimer?.invalidate()
        recordingDurationTimer?.invalidate()
    }
    
    func resumeRecording(){
        
        audioRecorder?.record()
        fireAudioRecordingTimer()
        fireWaveRecordingTimer()
        
    }
    
    func fireWaveRecordingTimer(){
        recordingWaveRefreshTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateRecordingAmplitude), userInfo: nil, repeats: true)
        
    }
    
    func fireAudioRecordingTimer(){
        recordingDurationTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateRecordingTime), userInfo: nil, repeats: true)
        audioRecorder?.isMeteringEnabled = true
    }
    
    func finishRecording(success: Bool) {
                
        recordingDurationTimer?.invalidate()
        recordingWaveRefreshTimer?.invalidate()
        
        let duration = audioRecorder!.currentTime / 100 * 100
        audioDuration = Float(round(duration))

        audioRecorder?.stop()
    }
    
   
    
    private func getDocumentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func getAbsolutePath(path: String) -> String? {
        
        if let range = path.range(of: "//"){
            
            let absolutePath = String(path[range.upperBound...])
            return absolutePath
            
        }
        return nil
    }

    @objc func updateRecordingTime(){
        
        guard let currentTime = audioRecorder?.currentTime  else {return}
        presenter.updateRecordingTime(value: Float(currentTime))
        
    }
    
    @objc func updateRecordingAmplitude(){
        
        audioRecorder?.updateMeters()
        let currentAmplitude = 1 - pow(10, audioRecorder?.averagePower(forChannel: 0) ?? 1 / 100)
        presenter.updateRecordingWave(value: currentAmplitude)
        
    }
    
}
