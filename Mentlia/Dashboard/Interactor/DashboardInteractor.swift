

import Foundation

class DashboardInteractor {
    
    weak var presenter: DashboardPresenter!
    
    init(presenter: DashboardPresenter) {
        self.presenter = presenter
    }
    
    func getUpdatedLastEmotion(completion: @escaping(Result< String , Error>) -> Void){
        
        MoodAnalysisFirestoreManager.shared.getLastEmotion { (result) in
            
            switch result{
            
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
    
    
    func getUserName(safeEmail: String , completion: @escaping(Result< String , Error >) -> Void){
        
        UserInfoManager.shared.getUserName(safeEmail: safeEmail) { (result) in
            
            switch result{
            
            case .success(let username):
                completion(.success(username))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    
    func getUserProfilePic(safeEmail: String, completion: @escaping(Result< String , Error >) -> Void){
        
        UserInfoManager.shared.getUserProfilePicLink(safeEmail: safeEmail) { (result) in
            switch result {
            
            case .success(let photoUrlString):
                completion(.success(photoUrlString))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    func getDateIntervalAnalysis(startDate: Date, endDate: Date, completion: @escaping(Result<[DayMoodModel] , Error>) -> Void ){
        
        MoodAnalysisFirestoreManager.shared.makeMoodAnalysisDateQuery(startDate: startDate, endDate: endDate) { (result) in
            
            switch result{
            
            case .success(let analysis):
                completion(.success(analysis))
                
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
    
    func getMontlyMoodCount(completion: @escaping(Result<MontlyMoodCountModel? , Error>) -> Void){
        
        MoodAnalysisFirestoreManager.shared.getMoodCountForMonth { (result) in
            
            switch result{
            
            case .success(let analysis):
                completion(.success(analysis))
                
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
    }
    
    func checkTodayData(completion: @escaping(Result< Bool , Error>) -> Void){
        MoodAnalysisFirestoreManager.shared.addNewDayToCloud(completion: {
            result in
            switch result {
            
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            
            }
        })
    }
    
}
