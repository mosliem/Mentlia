//  Created by mohamedSliem on 3/13/22.

import Foundation
import Charts

class DashboardPresenter{
    
    weak var view :DashboardVC!
    var interactor: DashboardInteractor!
    
    var startOfWeekDate = Date().startOfWeek
    var endOfWeekDate: Date!
    
    var weekMoodData: [DayMoodModel] = []
    
    var group = DispatchGroup()
    
    init(View:DashboardVC) {
        self.view = View
    }
    
    
    func updateDataOfView(){
        
        view.showLoader()
        interactor = DashboardInteractor(presenter: self)
        checkTodayData()
        getUsername()
        getUserProfilePic()
        getcurrentWeekDate()
        getLastEmotion()
        getMontlyCountData()
    }
    
    func getUsername(){
        
        let email =  AuthManager.shared().getCurrentUserEmail()
        let safeEmail = AuthManager.shared().safeEmail(emailAddress: email)
        group.enter()
        
        interactor.getUserName(safeEmail: safeEmail) { (result) in
            
            defer {
                self.group.leave()
            }
            
            switch result{
            
            case .success(let username):
                self.view.updateUserName(username: username)
            case .failure(let error):
                self.view.showAlertMessage(alertText: "Sorry", alertMessage: error.localizedDescription)
                
            }
        }
        
    }
    
    func getUserProfilePic(){
        group.enter()
        
        let email =  AuthManager.shared().getCurrentUserEmail()
        let safeEmail = AuthManager.shared().safeEmail(emailAddress: email)
        interactor.getUserProfilePic(safeEmail: safeEmail) { (result) in
            
            defer{
                self.group.leave()
            }
            
            switch result{
            
            case .success(let photoLinkString):
                
                let photoUrl = URL(string: photoLinkString)
                self.view.updateUserProfilePic(url: photoUrl)
                
            case .failure(let error):
                self.view.showAlertMessage(alertText: "Sorry", alertMessage: error.localizedDescription)
            }
        }
    }
    
    func getLastEmotion(){
        
        group.enter()
        
        interactor.getUpdatedLastEmotion(completion: ({ result in
            
            defer{
                self.group.leave()
            }
            
            switch result {
            
            case .success(let emotion):
                self.view.updateLastEmotionView(result: emotion)
            case .failure(let error):
                self.view.showAlertMessage(alertText: "Error", alertMessage: error.localizedDescription)
                
            }
        }))
        
    }
    
    func checkTodayData(){
        
        let todayDate = Date().formatLongDate(date: Date())
        let updateDate = UserDefaults.standard.object(forKey: "updateDate") as? Date
        
        if updateDate != nil && updateDate == todayDate {
            return
        }
        
        interactor.checkTodayData { (result) in
            
            switch result {
            
            case .success(_):
                let updatedDate = Date().formatLongDate(date: Date())!
                UserDefaults.standard.setValue(updatedDate, forKey: "updateDate")
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
    
}

//MARK:- Line Chart
// Line Chart Logic
extension DashboardPresenter {
    
    func setLineChartData() {
        
        var entry = [ChartDataEntry]()
        
        for x in weekMoodData{
            
            let dayVal = convertDaysToNum(day: x.day)
            entry.append(ChartDataEntry(x: Double(dayVal), y: Double(x.emotionVal)))
            
        }
        
        let set = LineChartDataSet(entries: entry)
        set.circleRadius = 4
        set.lineWidth = 1.8
        set.setColor(UIColor.systemBlue)
        set.setCircleColor(UIColor.systemBlue)
        
        let data = LineChartData(dataSet: set)
        view.updateMoodGraphData(data: data)
    }
    
    func getcurrentWeekDate(){
        
        let currnetDate = DateFormatter.dateFormatter.string(from: startOfWeekDate)
        var dayComponent = DateComponents()
        dayComponent.day = 6
        endOfWeekDate = Calendar.current.date(byAdding: dayComponent, to: startOfWeekDate)!
        
        let endWeekDate = DateFormatter.dateFormatter.string(from: endOfWeekDate)
        let newDate = "\(currnetDate) - \(endWeekDate)"
        
        getLineChartAnalysis()
        view.setDateText(dateString: newDate)
        
    }
    
    func increasingDatePressed(){
        
        startOfWeekDate = endOfWeekDate.addingTimeInterval(86400)
        let currnetDate = DateFormatter.dateFormatter.string(from: startOfWeekDate)
        
        var dayComponent = DateComponents()
        dayComponent.day = 7
        
        endOfWeekDate = Calendar.current.date(byAdding: dayComponent, to: endOfWeekDate)!
        
        let weekDate = DateFormatter.dateFormatter.string(from: endOfWeekDate)
        let newDate = "\(currnetDate) - \(weekDate)"
        view.setDateText(dateString: newDate)
        getLineChartAnalysis()
        
    }
    
    func decreasingDatePressed(){
        
        endOfWeekDate = startOfWeekDate.addingTimeInterval(-86400)
        let endWeekDate = DateFormatter.dateFormatter.string(from: endOfWeekDate)
        
        var dayComponent = DateComponents()
        dayComponent.day = -7
        
        startOfWeekDate = Calendar.current.date(byAdding: dayComponent, to: startOfWeekDate)!
        let startWeekDate = DateFormatter.dateFormatter.string(from: startOfWeekDate)
        
        let newDate = "\(startWeekDate) - \(endWeekDate)"
        view.setDateText(dateString: newDate)
        
        getLineChartAnalysis()
    }
    
    func getLineChartAnalysis(){
        
        group.enter()
        
        interactor.getDateIntervalAnalysis(startDate: startOfWeekDate, endDate: endOfWeekDate, completion: { result in
            
            defer{
                self.group.leave()
            }
            
            switch result{
            
            case .success(let analysis):
                self.updateChartDataView(analysis: analysis)
                
            case .failure(let error):
                self.view.showAlertMessage(alertText: "Error", alertMessage: error.localizedDescription)
            }
        })
        
        group.notify(queue: .main){
            
            self.view.removeLoader()
        }
    }
    
    
    func updateChartDataView(analysis: [DayMoodModel]){
        
        weekMoodData = analysis
        view.configureMoodGraphView()
        
        if !weekMoodData.isEmpty{
            setLineChartData()
        }
        
    }
    
    func convertDaysToNum(day: String) -> Int {
        
        switch day {
        
        case "SAT":
            return 1
        case "SUN":
            return 2
        case "MON":
            return 3
        case "TUE":
            return 4
        case "WED":
            return 5
        case "THU":
            return 6
        case "FRI":
            return 7
            
        default:
            return 1
        }
        
    }
    
}


//MARK:- Pie Charet logic
extension DashboardPresenter {
    
    func setPieChartData(data: MontlyMoodCountModel?) {
        
        guard  let data = data else {
            return
        }
        
        var entry = [PieChartDataEntry]()
        entry.append(PieChartDataEntry(value: Double(data.angryCount), label: "Angry"))
        entry.append(PieChartDataEntry(value: Double(data.happyCount), label: "Happy"))
        entry.append(PieChartDataEntry(value: Double(data.neutralCount), label: "Neutral"))
        entry.append(PieChartDataEntry(value: Double(data.sadCount), label: "Sad"))
        
        let set = PieChartDataSet(entries: entry)
        
        set.colors = [UIColor(displayP3Red: 240/255, green: 106/255, blue: 112/255, alpha: 1.0) ,
                      UIColor(displayP3Red: 174/255, green: 216/255, blue: 118/255, alpha: 1.0) ,
                      UIColor(displayP3Red: 139/255, green: 219/255, blue: 218/255, alpha: 1.0),
                      UIColor(displayP3Red: 77/255, green: 77/255, blue: 77/255, alpha: 1.0)]
        
        set.valueFont = .boldSystemFont(ofSize: 17)
        set.label = nil
        
        let chartData = PieChartData(dataSet: set)
        view.updatePieChartData(data: chartData, totalCount: String(data.count))
    }
    
    func getMontlyCountData(){
        
        group.enter()
        
        interactor.getMontlyMoodCount { (result) in
            
            defer{
                self.group.leave()
            }
            
            switch result{
            
            case .success(let data):
                self.setPieChartData(data: data)
                
            case .failure(let error):
                self.view.showAlertMessage(alertText: "Error", alertMessage: error.localizedDescription)
            }
        }
    }
    
}
