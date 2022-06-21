//
//  RecordingWaveView.swift
//  EmotionDetectionApp
//
//  Created by mohamedSliem on 4/9/22.
//

import DSWaveformImage
import UIKit

class RecordingWaveView: UIView {
    
    var waveView = UIView()
    var liveRecordingWave = WaveformLiveView()
    var recordingTimeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func setViewTransion(hiddenState: Bool , alpha: CGFloat){
        
        UIView.transition(with: self, duration: 0.6, options: .transitionCrossDissolve, animations:{
            self.alpha = alpha
            self.isHidden = hiddenState
        })
    }
  
    func setupContainerViewFrame(x: CGFloat , y: CGFloat, width: CGFloat , height: CGFloat ){
        
         waveView = UIView(frame: CGRect(x: x, y: y, width: width , height: height))
         self.addSubview(waveView)
    }
    
    func setupContainerViewColor(color: UIColor){
        waveView.backgroundColor = color
        liveRecordingWave.backgroundColor = color
    }
    
    func setupContainerViewCornerRadius(cornerRadius: CGFloat){
        waveView.clipsToBounds = true
        waveView.layer.cornerRadius = 25
    }
    
    func setupRecordingWaveFrame(x: CGFloat , y: CGFloat , width: CGFloat, height: CGFloat){
        
        liveRecordingWave.frame = CGRect(x: x , y: y , width: width , height: height)
        waveView.addSubview(liveRecordingWave)
        
    }
    
    func setupRecordingTimeLabel(x: CGFloat , y: CGFloat , width: CGFloat, height: CGFloat, fontSize:CGFloat){
        
        recordingTimeLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        recordingTimeLabel.textAlignment = .center
        recordingTimeLabel.text = "0:00"
        recordingTimeLabel.textColor = .white
        recordingTimeLabel.font = .boldSystemFont(ofSize: fontSize)
        waveView.addSubview(recordingTimeLabel)

    }
    
    func updateRecordingTimeWithOneM(time: Float){
        
        let min = Int(time / 60)
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        let totalTimeString = String(format: "%0d:%02d", min, sec)
        recordingTimeLabel.text = totalTimeString
    }
    
    func updateRecordingTimeWithTwoM(time: Float){
        
        let min = Int(time / 60)
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        let totalTimeString = String(format: "%02d:%02d", min, sec)
        recordingTimeLabel.text = totalTimeString
    }
    
    func setupRecordingWaveView(color: UIColor, width: CGFloat, spacing: CGFloat){
        
        liveRecordingWave.configuration = (liveRecordingWave.configuration.with(style: .striped(.init(color: color , width: width , spacing: spacing))))
        liveRecordingWave.shouldDrawSilencePadding = true
        
        liveRecordingWave.configuration = (liveRecordingWave.configuration.with(
                                            dampening: liveRecordingWave.configuration.dampening?.with(percentage: 0.2 , sides: .both)))
    }
    
    func updateWaveAmplitude(value: Float){
        liveRecordingWave.add(sample: value)
    }
}
