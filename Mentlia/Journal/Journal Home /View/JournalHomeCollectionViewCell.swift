
import UIKit

class JournalHomeCollectionViewCell: UICollectionViewCell {
   
    private let title : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "My journey to the start"
        return label
    }()
    
    private let Date: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16)
        label.text = "12-10-2021"
        return label
    }()
    
    private var durationTime: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.text = "2:33 min"
        return label
    }()
    
    private let emotionImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage()
        return imageView
        
    }()
    
    private let journalType: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        label.backgroundColor = UIColor(displayP3Red: 0.62, green: 0.61, blue: 0.82, alpha: 1.0)
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        
        label.font = .systemFont(ofSize: 15, weight: .black)
        label.textAlignment = .center
        label.text = "Audio"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = .white
        
        contentView.addSubview(title)
        contentView.addSubview(emotionImageView)
        contentView.addSubview(durationTime)
        contentView.addSubview(Date)
        contentView.addSubview(journalType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        title.sizeToFit()
        durationTime.sizeToFit()
        
        title.frame = CGRect(x: 20, y: 20, width: contentView.width - 150, height: 40)
        
        Date.frame = CGRect(x: title.left , y: title.bottom + 2, width: contentView.width - 200, height: 30)
        
        durationTime.frame = CGRect(x: title.left , y: Date.bottom + 18 , width: 150 , height: 30)
        
        emotionImageView.frame = CGRect(x: contentView.right - 90, y: title.top, width: 70, height: 70)
        
        journalType.frame = CGRect(x: contentView.right - 90, y: durationTime.top, width: 70, height: 30)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.title.text = ""
        self.Date.text = ""
        self.emotionImageView.image = nil
        self.journalType.text = ""
        self.durationTime.text = ""
    }
    
    func configure(title: String, date: String, durationTime: String? = nil, lastEdit: String? = nil, emotion: String, journalType: String){
         
        self.title.text = title
        self.Date.text = date
        self.emotionImageView.image = UIImage(named: "emoji-"+emotion)
        self.journalType.text = journalType
        
        switch journalType {
        case "Audio":
            self.durationTime.text = durationTime
        case "Text":
            self.durationTime.text = lastEdit
        default:
            break
        }
    
    }
}
