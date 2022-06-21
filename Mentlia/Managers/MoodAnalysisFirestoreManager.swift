

import Foundation
import FirebaseFirestore

class MoodAnalysisFirestoreManager{
    
    private let db = Firestore.firestore()
    public static var shared =  MoodAnalysisFirestoreManager()
    private let currentUser =  AuthManager.shared().getCurrentUserSafe()!
    
    private init(){}
    
    // make a new analysis doc for new day
    
    public func addNewDayToCloud(completion: @escaping(Result<Bool, Error>) -> Void){
        
        let todayName = Date().getTodayName(date: Date()).uppercased()
        let safeDate = safeDateString(date: Date())
        
        let ref = db.collection("MoodAnalysis").document(currentUser)
        print(currentUser)
        ref.collection("analysis").document(safeDate).setData([
            "day": todayName,
            "date": Date(),
            "neutralCount": 0,
            "angryCount": 0,
            "sadCount": 0,
            "happyCount": 0,
            "Count":0
        ]){
            error in
            completion(.success(true))
        }
        
    }
    
    // add mood analysis type to cloud and count it
    func updateTodayMoodAnalysis(todayDate: Date, emotionVal: Int, emotionName: String){
        
        let safeDate = safeDateString(date: todayDate)
        db.collection("MoodAnalysis").document(currentUser).collection("analysis").document(safeDate).updateData([
            
            "Count": FieldValue.increment(Int64(1)),
            emotionName + "Count": FieldValue.increment(Int64(emotionVal)),
        ])
        { error in
            
            guard error == nil else {
                return
            }
            
            self.updateEmotionVal(todayDate: todayDate)
        }
        
    }
    
    // compute and update emotionValue after new analysis is done
    func updateEmotionVal(todayDate: Date){
        
        let safeDate = safeDateString(date: todayDate)
        let dbRef =  db.collection("MoodAnalysis").document(currentUser).collection("analysis").document(safeDate)
        
        dbRef.getDocument { (docSnapshot, error) in
            
            guard let data = docSnapshot?.data() , error == nil else {
                return
            }
            
            let count = data["Count"] as! Int
            let neutralCount = data["neutralCount"] as! Int
            let angryCount = data["angryCount"] as! Int
            let happyCount = data ["happyCount"] as! Int
            let sadCount = data["sadCount"] as! Int
            
            var newEmotionVal = (neutralCount + angryCount + happyCount + sadCount) / count
            newEmotionVal = Int(round(Double(newEmotionVal)))
            
            dbRef.updateData([
                "emotionVal": newEmotionVal
            ])
        }
        
    }
    
    // get the latest emotion of the last analysis
    func getLastEmotion(completion: @escaping(Result<String , Error>) -> Void){
        
        db.collection("Users").document(currentUser).getDocument { (docSnapshot, error) in
            
            guard  error == nil else {
                
                return completion(.failure(error!))
            }
            
            guard let docData = docSnapshot?.data() else{
             return
            }
            
            if let lastEmotion = docData["lastEmotion"] as? String {
                completion(.success(lastEmotion))
            }
        }
        
        
    }
    
    
    // make a query for getting analysis between two dates and return the analysis with a form of DayMoodModel
    
    func makeMoodAnalysisDateQuery(startDate: Date, endDate: Date, completion: @escaping(Result<[DayMoodModel] , Error>) -> Void){
        
        db.collection("MoodAnalysis").document(currentUser).collection("analysis")
            .whereField("date", isGreaterThanOrEqualTo: removeTimeStamp(fromDate: startDate))
            .whereField("date", isLessThanOrEqualTo: removeTimeStamp(fromDate: endDate))
            .getDocuments { (dateSanpShot, error) in
                
                var analysis: [DayMoodModel] = []
                
                guard let dates = dateSanpShot?.documents , error == nil else {
                    return completion(.failure(error!))
                }
                
                for date in dates {
                    
                    let day = date["day"] as? String ?? ""
                    if  let emotionVal =  date["emotionVal"] as? Int {
                        analysis.append(DayMoodModel(day: day , emotionVal: Int(emotionVal)))
                    }
                    
                }
                completion(.success(analysis))
            }
        
    }
    
    
    func getMoodCountForMonth(completion: @escaping(Result< MontlyMoodCountModel? , Error >)-> Void){
        
        let monthStart = removeTimeStamp(fromDate:Date().startOfMonth)
        let monthEnd = removeTimeStamp(fromDate: Date().endOfMonth)
        
        var analysis = MontlyMoodCountModel()
        
        db.collection("MoodAnalysis").document(currentUser).collection("analysis")
            .whereField("date", isGreaterThanOrEqualTo: monthStart)
            .whereField("date", isLessThanOrEqualTo: monthEnd )
            .getDocuments { (docsSnapshot, error) in
                
                guard let docs = docsSnapshot?.documents , error == nil else {
                    return completion(.failure(error!))
                }
                
                for doc in docs {
                    
                    let data = doc.data()
                    analysis.angryCount += data["angryCount"] as? Int ?? 0
                    analysis.neutralCount += data["neutralCount"] as? Int ?? 0
                    analysis.sadCount += data["sadCount"] as? Int ?? 0
                    analysis.happyCount += data["happyCount"] as? Int ?? 0
                    analysis.count += data["Count"] as? Int ?? 0
                    
                }
                
                analysis.neutralCount = analysis.neutralCount / 3
                analysis.angryCount = analysis.angryCount / 2
                analysis.happyCount = analysis.happyCount / 4
                
                completion(.success(analysis))
            }
        
    }
    
    
    func getPatientWeekUpdates(patientEmail: String, startDate: Date, endDate: Date, completion: @escaping(Result<[DayMoodModel] , Error>) -> Void){
        
        let patientSafeEmail = AuthManager.shared().safeEmail(emailAddress: patientEmail)
        
        db.collection("MoodAnalysis").document(patientSafeEmail).collection("analysis")
            .whereField("date", isGreaterThanOrEqualTo: removeTimeStamp(fromDate: startDate))
            .whereField("date", isLessThanOrEqualTo: removeTimeStamp(fromDate: endDate))
            .getDocuments { (dateSanpShot, error) in
                
                var analysis: [DayMoodModel] = []
                
                guard let dates = dateSanpShot?.documents , error == nil else {
                    return completion(.failure(error!))
                }
                
                for date in dates {
                    
                    let day = date["day"] as? String ?? ""
                    if  let emotionVal =  date["emotionVal"] as? Int {
                        analysis.append(DayMoodModel(day: day , emotionVal: Int(emotionVal)))
                    }
                    
                }
                completion(.success(analysis))
            }
        
    }
    
    
    func removeTimeStamp(fromDate: Date) -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
    
    
    func safeDateString(date: Date) -> String{
        
        let date = DateFormatter.displayLongDateFormatter
            .string(from: date).replacingOccurrences(of: ",", with: "-")
            .replacingOccurrences(of: " ", with: "-")
        
        return date
    }
    
}
