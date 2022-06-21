//  Created by mohamedSliem on 4/21/22.

import UIKit
import Alamofire


class AudioAnalyzerAPIManager {

    enum APIAnalyzerError: Error{
        case APIError
    }
    
    public static var shared = AudioAnalyzerAPIManager()
    private init(){}
    
    
    let url = URL(string: "https://emotiongp.herokuapp.com/predict")
    
    
    func uploadAudioFile(paramName: String, fileName: String, audioData: Data, completion: @escaping(Result<String , Error>) -> Void){
    
        AF.sessionConfiguration.timeoutIntervalForRequest = 600
        AF.upload(multipartFormData: { (multipart) in
            multipart.append( audioData, withName: paramName, fileName: fileName,mimeType: "audio/wav")
        }, to: self.url!, method:.post).uploadProgress { (progress) in
            
            print(progress.fractionCompleted * 100)
            
        }.responseJSON { (jsonResponse) in
            
            
            switch jsonResponse.result {
            
            
            case .success(_):
                print(jsonResponse.result)
                self.jsonResponseDecoder(json: jsonResponse.data) { (result) in
                    
                    guard result != nil else {
                        
                        return completion(.failure(APIAnalyzerError.APIError))
                    }
                    
                    completion(.success(result?.Emotion ?? ""))
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
     
    }
    
 
    
    private func jsonResponseDecoder(json: Data? , completion: @escaping(AudioJournalAnalyzerResponse?) -> Void) {
        
        var result : AudioJournalAnalyzerResponse? = nil
        
        guard let data = json else {
            return
        }
        
        do {
            
            result = try JSONDecoder().decode(AudioJournalAnalyzerResponse.self, from: data)
            completion(result)
        }
        catch {
            print(error.localizedDescription)
        }
        
    }
    
}
