
//  Created by mohamedSliem on 3/14/22.

import UIKit
import NVActivityIndicatorView


extension UIImageView {
    func applyshadow(shadowRadius : CGFloat , shadowOpacity :Float , shadowColor : UIColor){

        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowPath = UIBezierPath(rect:self.bounds).cgPath

    }
}


extension UIView
{
    var height : CGFloat {
        return frame.size.height
    }
    var width : CGFloat  {
        return frame.size.width
    }
    var left : CGFloat {
        return frame.origin.x
    }
    var right : CGFloat {
        return left + width
    }
    var top : CGFloat {
        return frame.origin.y
    }
    var bottom : CGFloat{
        return top + height
    }
    
    func showSizingAnimation(_ completionBlock: @escaping () -> Void) {
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
                        self?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
                       }) {  (done) in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                            self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                           }) { [weak self] (_) in
                self?.isUserInteractionEnabled = true
                completionBlock()
            }
                       }
    }
    
    
    
    static var activityIndactor: NVActivityIndicatorView!
    func addLoadingView(){
        
        let frame = CGRect(x: (self.width / 2) - 50 , y: (self.height / 2) - 50, width: 100, height: 100)

        UIView.activityIndactor = NVActivityIndicatorView(
            frame: frame,
            type: .ballZigZagDeflect,
            color: .link, padding: 25
        )
        
        DispatchQueue.main.async {
            
            self.addSubview(UIView.activityIndactor)
            UIView.activityIndactor.startAnimating()
        
        }
    }
    
    func removeLoaddingView(){
        
        DispatchQueue.main.async {
            UIView.activityIndactor.stopAnimating()
        }
    }
    
    
}

extension DateFormatter{
    
    static let longDateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        return dateFormatter
    }()
    
    static let dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        return dateFormatter
    }()
    
    static let displayLongDateFormatter : DateFormatter = {
        
        let Formmater = DateFormatter()
        Formmater.dateStyle = .long
        return Formmater
        
    }()
}


extension UITabBar{
    
    func setTransparentTabbar() {
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().clipsToBounds = true
    }
}

extension UIImage {
    
    func setImageSymbolConfiguration(imageName: String ,points: CGFloat , weight: UIImage.SymbolWeight, scale : UIImage.SymbolScale) -> UIImage {
        
        let config = UIImage.SymbolConfiguration(pointSize: points, weight: weight, scale: scale)
        guard let image = UIImage(systemName: imageName, withConfiguration: config) else {
            return UIImage()
        }
        return image
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension UITextView {
    
    func adjustTextViewHeight() {
        
        let currentFrame = self.frame
        let fixedWidth = self.frame.size.width
        var newSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        if newSize.height > 166
        {
            newSize.height = 166
        }
        self.frame = CGRect(x: currentFrame.origin.x, y: currentFrame.origin.y, width: fixedWidth , height: newSize.height)
        
        self.layoutIfNeeded()
    }
    
    func setPadding(_ amount:CGFloat) {
        self.textContainerInset = UIEdgeInsets(top: 18, left: amount, bottom: 11, right: amount)
    }
    
}

extension UITextField{
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
}

extension UIButton {
    
    func getTitlAttributedString(text: String, textSize: CGFloat, textWeight: UIFont.Weight , color: UIColor ) -> NSAttributedString{
        
        let string =  NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: textSize, weight: textWeight), NSAttributedString.Key.foregroundColor : color]
        )
        return string
    }
    
    
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        let isRTL = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft
        
        if isRTL {
            imageEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: -insetAmount)
        } else {
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        }
    }
}

extension UIViewController {
    
    
    func showAlertWithOk(alertTitle: String,message: String,actionTitle: String){
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlertWithRetry(alertMessage: String , retryHandler: ((UIAlertAction) -> Void)?){
        
        let alert = UIAlertController(title: "Error", message: alertMessage, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "retry", style: .destructive, handler: retryHandler))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertMessage(alertText : String, alertMessage : String, optionalHandler: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: optionalHandler))

        if var topController = UIApplication.shared.keyWindow?.rootViewController {
                 while let presentedViewController = topController.presentedViewController {
                     topController = presentedViewController
                 }
                 topController.present(alert, animated: true, completion: nil)
          }
        
    }
    
    func showEnsuringAlert(alertText: String, alertMessage: String, yesHandler: ((UIAlertAction) -> Void)?, noHandler: ((UIAlertAction)-> Void)?){
        
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "no", style: .default, handler: noHandler))
        alert.addAction(UIAlertAction(title: "yes", style: .destructive, handler: yesHandler))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    static var activityIndactorView: UIView!
    static var activityIndactor: NVActivityIndicatorView!
    
    func showLoader(frame: CGRect? = nil) {
        
        UIViewController.activityIndactorView = UIView(frame: frame ?? view.frame)
        UIViewController.activityIndactorView.backgroundColor = .white
        
        let loaderFrame = CGRect(
            x: UIViewController.activityIndactorView.frame.width / 2 - 50,
            y: UIViewController.activityIndactorView.frame.height / 2 - 100,
            width: 100, height: 100
        )
        
        let color =  UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)
        UIViewController.activityIndactor = NVActivityIndicatorView(
            frame: loaderFrame,
            type: .ballZigZagDeflect,
            color: color, padding: 25
        )
        
        DispatchQueue.main.async {
            
            self.view.addSubview(UIViewController.activityIndactorView)
            UIViewController.activityIndactorView.addSubview(UIViewController.activityIndactor)
            UIViewController.activityIndactor.startAnimating()
            
        }
        
        
    }
    
    func removeLoader(){
        DispatchQueue.main.async {
            
            UIViewController.activityIndactor.stopAnimating()
            UIViewController.activityIndactorView.removeFromSuperview()
            
        }
    }
    
}


extension Calendar {
    
    static let gregorian = Calendar(identifier: .gregorian)
}

extension Date {
    
    
    var startOfWeek: Date {
        
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.firstWeekday = 7
        
        guard let sat = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return Date()}
        
        return sat
    }
    
    func formatLongDate(date: Date) -> Date? {
        
        let newDate = DateFormatter.displayLongDateFormatter.string(from: date)
        let formattedDate = DateFormatter.displayLongDateFormatter.date(from: newDate)
        
        return formattedDate
    }
    
    func getTodayName(date: Date) -> String {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let dayInWeek = dateFormatter.string(from: date)
        return dayInWeek
    }
    
    var startOfMonth: Date {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        return  calendar.date(from: components)!
        
    }
    
    var endOfMonth: Date {
        
        let calender = Calendar(identifier: .gregorian)
        var dateCompenent = DateComponents()
        dateCompenent.month = 1
        dateCompenent.day = -1
        
        let endMonth = calender.date(byAdding: dateCompenent, to: startOfMonth)!
        return endMonth
    }
    
}



