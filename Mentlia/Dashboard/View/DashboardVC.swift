
import UIKit
import Charts

class DashboardVC: UIViewController,ChartViewDelegate {
    
    //MARK:- view variables
    @IBOutlet weak var dashboardScroll: UIScrollView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentMoodImageView: UIImageView!
    @IBOutlet weak var currentMoodLabel: UILabel!
    @IBOutlet weak var currentMoodView: UIView!
    @IBOutlet weak var ProfileView: UIView!
    @IBOutlet weak var topView: UIView!
    
    private var lastContentOffset: CGFloat = 0
    
    //DateLabel
    private let dateLabel = UILabel()
    private let increasingDateBtn = UIButton()
    private let decreasingDateBtn = UIButton()
    
    //line Chart
    private var lineChart = LineChartView()
    private var lineChartViewContainer = UIView()
    private let lineChartTitle = UILabel()
    
    //Pie Chart
    private var moodCountPieChart = PieChartView()
    private let pieChartContainerView = UIView()
    private let pieChartTitle = UILabel()
    private var totalCountLabel = UILabel()
    
    var presenter : DashboardPresenter!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        presenter = DashboardPresenter(View: self)
        renderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        presenter.updateDataOfView()


    }
    
    func renderView(){
        
        configureProfileImageView()
        configureCurrentMoodView()
        configureMoodGraphView()
        configureChartTitle()
        configureTopView()
        configureNameLabel()
        configureMoodCountPieChart()
        configurePieChartTitle()
        configureDateSwitcher()
        configureTotalLabel()
    }
    
    private func configureProfileImageView(){
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 50
        
        //profile imageview container
        ProfileView.layer.cornerRadius = 50
        ProfileView.layer.shadowColor = UIColor.darkGray.cgColor
        ProfileView.layer.shadowOffset = CGSize.zero
        ProfileView.layer.shadowRadius = 10
        ProfileView.layer.shadowOpacity = 1.0
    }
    
    
    private func configureCurrentMoodView(){
        
        currentMoodView.layer.cornerRadius = 15
        currentMoodView.layer.shadowColor = UIColor.darkGray.cgColor
        currentMoodView.layer.shadowOffset = CGSize.zero
        currentMoodView.layer.shadowRadius = 10
        currentMoodView.layer.shadowOpacity = 0.9
        
    }
    
    private func configureTopView(){
        
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOffset = CGSize.zero
        topView.layer.shadowRadius = 40
        topView.layer.shadowOpacity = 1.0
        topView.layer.cornerRadius = 25
        
    }
    
    private func configureNameLabel(){
        
        nameLabel.font =  UIFont(name: "CircularStd-Black", size: 24)
        nameLabel.layer.shadowColor = UIColor.white.cgColor
        nameLabel.layer.shadowOffset = CGSize.zero
        nameLabel.layer.shadowRadius = 30
        nameLabel.layer.shadowOpacity = 0.7
        
    }
    
    func updateUserName(username: String){
        nameLabel.text = "Hi," + username
    }
    
    func updateUserProfilePic(url: URL?){
        profileImageView.sd_setImage(with: url, completed: nil)
    }
    
    func updateLastEmotionView(result: String){
        
        currentMoodImageView.image = UIImage(named: "emoji-" + result)
        currentMoodLabel.text = result
    }
    
}

//MARK:- Date switcher view
/// Date Switcher rendering function

extension DashboardVC {
    
    func configureDateSwitcher(){
        
        dateLabel.frame = CGRect(x: view.center.x - 90, y: lineChartViewContainer.top - 60, width: 180, height: 40)
        dateLabel.font = UIFont(name: "CircularStd-Bold", size: 15)
        dateLabel.textAlignment = .center
        dateLabel.backgroundColor = .white
        dateLabel.clipsToBounds = true
        dateLabel.layer.cornerRadius = 15
        
        //right button
        configureDateRightButton()
        
        //left button
        configureDateLeftButton()
        
        //subviews
        dashboardScroll.addSubview(dateLabel)
        
        increasingDateBtn.addTarget(self, action: #selector(increasePressed), for: .touchUpInside)
        decreasingDateBtn.addTarget(self, action: #selector(decreasePressed), for: .touchUpInside)
    }
    
    func setDateText(dateString: String){
        
        dateLabel.text = dateString
    }
    
    func configureDateRightButton() {
        
        increasingDateBtn.frame = CGRect(
            x: dateLabel.right + 3,
            y: lineChartViewContainer.top - 52,
            width: 25,
            height: 25
        )
        
        var rightBtnTintImage = UIImage(named: "rightButton")
        rightBtnTintImage = rightBtnTintImage?.withRenderingMode(.alwaysTemplate)
        increasingDateBtn.setImage(rightBtnTintImage, for: .normal)
        increasingDateBtn.tintColor = UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)
        dashboardScroll.addSubview(increasingDateBtn)
        
    }
    
    
    func configureDateLeftButton(){
        
        decreasingDateBtn.frame = CGRect(
            x: dateLabel.left - 28,
            y: lineChartViewContainer.top - 52,
            width: 25,
            height: 25
        )
        
        decreasingDateBtn.backgroundColor = .clear
        var tintImage = UIImage(named:"leftButton")
        tintImage = tintImage?.withRenderingMode(.alwaysTemplate)
        decreasingDateBtn.setImage(tintImage, for: .normal)
        decreasingDateBtn.tintColor = UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)
        dashboardScroll.addSubview(decreasingDateBtn)
        
    }
    
    @objc func increasePressed()
    {
        presenter.increasingDatePressed()
    }
    
    @objc func decreasePressed()
    {
        presenter.decreasingDatePressed()
    }
    
}

//MARK:- Line chart view

///Line Chart View Rendering
///Setting data
extension DashboardVC {
    
    private func configureChartTitle() {
        
        lineChartTitle.frame = CGRect(
            x: lineChartViewContainer.left+5,
            y: 10,
            width: view.bounds.width,
            height: 30
        )
        
        lineChartTitle.text = "Mood Chart"
        lineChartTitle.textColor = .black
        lineChartTitle.font = UIFont(name: "CircularStd-Black", size: 22)
        lineChartViewContainer.addSubview(lineChartTitle)
        
    }
    
    func configureMoodGraphView(){
        
        lineChartViewContainer.frame = CGRect(x: 15, y:currentMoodView.bottom + 270, width: view.bounds.width-30, height: 350)
        lineChart.frame =  CGRect(x: 20, y:40 , width: lineChartViewContainer.bounds.width-40, height: 300)
        
        //reset chart data
        lineChart.data = nil
        
        // Rounded chart corner
        lineChart.clipsToBounds = true
        lineChart.backgroundColor = .clear
        lineChartViewContainer.layer.cornerRadius = 15
        
        //subView
        dashboardScroll.addSubview(lineChartViewContainer)
        self.lineChartViewContainer.addSubview(lineChart)
        lineChartViewContainer.backgroundColor = .white
        
        lineChart.doubleTapToZoomEnabled = false
        lineChart.pinchZoomEnabled = false
        lineChart.scaleXEnabled = false
        lineChart.scaleYEnabled = false
        
        // Shadow
        applyLineChartShadow()
        
        // Chart Fonts and label postion
        renderLineChartLabelFonts()
        //animation
        lineChart.animate(xAxisDuration: 1, yAxisDuration: 1)
        //right side of Grid
        removeLineChartRightSide()
    }
    
    private func applyLineChartShadow(){
        
        lineChartViewContainer.layer.shadowColor = UIColor.lightGray.cgColor
        lineChartViewContainer.layer.shadowOffset = CGSize.zero
        lineChartViewContainer.layer.shadowRadius = 5
        lineChartViewContainer.layer.shadowOpacity = 1.0
        
    }
    
    private func renderLineChartLabelFonts(){
        
        lineChart.leftYAxisRenderer.axis.labelFont = .boldSystemFont(ofSize: 25)
        lineChart.leftYAxisRenderer.axis.labelAlignment = .right
        lineChart.xAxisRenderer.axis.labelFont = UIFont(name: "CircularStd-Black", size: 12)!
        lineChart.xAxisRenderer.axis.wordWrapEnabled = true
        lineChart.xAxisRenderer.axis.labelPosition = .bottomInside
        lineChart.rightAxis.drawLabelsEnabled = false
        
        let lenged = lineChart.legend
        lenged.enabled = false
        
        lineChart.noDataFont = UIFont(name: "CircularStd-Black", size: 15)!
        lineChart.noDataText = "No mood analysis data yet!"
    }
    
    private func removeLineChartRightSide(){
        
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.rightAxis.drawGridLinesEnabled = false
        lineChart.rightAxis.drawZeroLineEnabled = false
        lineChart.extraRightOffset = 14
        lineChart.rightAxis.axisLineColor = .clear
        lineChart.xAxis.axisLineWidth = 0
        
    }
    
    func updateMoodGraphData(data: LineChartData){
        
        lineChart.data = data
        labelChart()
        
    }
    
    private func labelChart(){
        
        let leftAxis = lineChart.leftAxis
        
        //set constant label range
        leftAxis.forceLabelsEnabled = true
        leftAxis.labelCount = 4
        
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 4.5
        
        leftAxis.granularity = 1
        leftAxis.axisLineWidth = 0
        leftAxis.valueFormatter = YAxisData()
        
        //x axis label
        let bottomAxis = lineChart.xAxis
        bottomAxis.valueFormatter = XAxisData()
        
        bottomAxis.axisMinimum = 1
        bottomAxis.labelCount = 7
        
        bottomAxis.granularity = 1
        bottomAxis.axisLineWidth = 0
        bottomAxis.labelHeight = 30
        
        lineChart.lineData?.setDrawValues(false)
        
    }
    
}


//MARK:- Pie Chart View

extension DashboardVC {
    
    func configurePieChartTitle(){
        
        pieChartTitle.text = "Montly Mood Count"
        pieChartTitle.frame = CGRect(x: pieChartContainerView.left+5, y: 15, width: view.bounds.width, height: 30)
        pieChartTitle.textColor = .black
        pieChartTitle.font = UIFont(name: "CircularStd-Black", size: 22)
        self.pieChartContainerView.addSubview(pieChartTitle)
        
    }
    
    private func configureMoodCountPieChart() {
        
        //setting the frames
        pieChartContainerView.frame = CGRect(x: 15, y: lineChartViewContainer.bottom+50 , width: view.bounds.width-30, height: 370)
        moodCountPieChart.frame = CGRect(x: 7.5, y: 50, width: pieChartContainerView.width-15, height: 300)
        
        // rounded view corner
        moodCountPieChart.clipsToBounds = true
        pieChartContainerView.layer.cornerRadius = 15
        pieChartContainerView.backgroundColor = .white
        moodCountPieChart.noDataText = "No data entries"

        
        //Sub view
        dashboardScroll.addSubview(pieChartContainerView)
        self.pieChartContainerView.addSubview(moodCountPieChart)
        
        //shadow for view
        let container = pieChartContainerView.layer
        container.shadowColor = UIColor.lightGray.cgColor
        container.shadowOffset = CGSize.zero
        container.shadowRadius = 5
        container.shadowOpacity = 1.0
        
        moodCountPieChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
        moodCountPieChart.sizeToFit()
        
        moodCountPieChart.legend.font = UIFont(name: "CircularStd-Medium", size: 15)!
        
    }
    
    func configureTotalLabel(){
        
        totalCountLabel.frame = CGRect(x: pieChartContainerView.right - 120, y: moodCountPieChart.bottom - 30 , width: 120, height: 30)
        pieChartContainerView.addSubview(totalCountLabel)
        totalCountLabel.font = UIFont(name: "CircularStd-Medium", size: 15)
        totalCountLabel.textAlignment = .center
        
    }
    
    func updatePieChartData(data: PieChartData, totalCount: String){
        
        moodCountPieChart.data = data
        moodCountPieChart.drawEntryLabelsEnabled = false

        // formatting the integer values
        let numFormatter = NumberFormatter()
        numFormatter.maximumFractionDigits = 0
        data.setValueFormatter(DefaultValueFormatter(formatter: numFormatter))
        
        totalCountLabel.text = "Total: \(totalCount)"
    }
}


