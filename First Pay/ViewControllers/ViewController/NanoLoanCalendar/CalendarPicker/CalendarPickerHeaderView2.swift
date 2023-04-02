//
//import UIKit
//
//class CalendarPickerHeaderView2: UIView {
//    
//    
//    @IBOutlet weak var monthLabel: UILabel!
//    @IBOutlet weak var buttonBack: UIButton!
//    @IBOutlet weak var buttonNext: UIButton!
//
//    class func instanceFromNib() -> UIView {
//        return UINib(nibName: "CalendarPickerHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
//    }
//    
//    lazy var stackViewForButton: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .horizontal
//        stackView.accessibilityTraits = .header
//        stackView.isAccessibilityElement = true
//        return stackView
//    }()
//    
//
//    
//    lazy var closeButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        
//        let configuration = UIImage.SymbolConfiguration(scale: .large)
//        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: configuration)
//        button.setImage(image, for: .normal)
//        
//        button.tintColor = .secondaryLabel
//        button.contentMode = .scaleAspectFill
//        button.isUserInteractionEnabled = true
//        button.isAccessibilityElement = true
//        button.accessibilityLabel = "Close Picker"
//        button.isHidden = true
//        return button
//    }()
//    
//    @IBAction func buttonBack(_ sender: Any) {
//        didTapPreviousMonthButton()
//    }
//    @IBAction func buttonNext(_ sender: Any) {
//        didTapNextMonthButton()
//    }
//    lazy var dayOfWeekStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.distribution = .fillEqually
//        return stackView
//    }()
//    
//    lazy var separatorView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor.label.withAlphaComponent(0.2)
//        return view
//    }()
//    
//    private lazy var dateFormatter: DateFormatter = {
//        let dateFormatter = DateFormatter()
//        dateFormatter.calendar = Calendar(identifier: .gregorian)
//        dateFormatter.locale = Locale.autoupdatingCurrent
//        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM")
//        return dateFormatter
//    }()
//    
//    var baseDate = Date() {
//        didSet {
//            monthLabel.text = dateFormatter.string(from: baseDate)
//        }
//    }
//    
//    var exitButtonTappedCompletionHandler: (() -> Void)
//    
//    //  init(exitButtonTappedCompletionHandler: @escaping (() -> Void)) {
//    //    self.exitButtonTappedCompletionHandler = exitButtonTappedCompletionHandler
//    //
//    //    super.init(frame: CGRect.zero)
//    //
//    //    translatesAutoresizingMaskIntoConstraints = false
//    //
//    //    backgroundColor = .systemGroupedBackground
//    //
//    //    layer.maskedCorners = [
//    //      .layerMinXMinYCorner,
//    //      .layerMaxXMinYCorner
//    //    ]
//    //    layer.cornerCurve = .continuous
//    //    layer.cornerRadius = 15
//    //
//    //    addSubview(monthLabel)
//    //    addSubview(closeButton)
//    //    addSubview(dayOfWeekStackView)
//    //    addSubview(separatorView)
//    //
//    //    for dayNumber in 1...7 {
//    //      let dayLabel = UILabel()
//    //      dayLabel.font = .systemFont(ofSize: 10, weight: .bold)
//    //      dayLabel.textColor = .clrBlack
//    //      dayLabel.textAlignment = .center
//    //      dayLabel.text = dayOfWeekLetter(for: dayNumber)
//    //
//    //      // VoiceOver users don't need to hear these days of the week read to them, nor do SwitchControl or Voice Control users need to select them
//    //      // If fact, they get in the way!
//    //      // When a VoiceOver user highlights a day of the month, the day of the week is read to them.
//    //      // That method provides the same amount of context as this stack view does to visual users
//    //      dayLabel.isAccessibilityElement = false
//    //      dayOfWeekStackView.addArrangedSubview(dayLabel)
//    //    }
//    //
//    //    closeButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
//    //  }
//    
//    @objc func didTapExitButton() {
//        exitButtonTappedCompletionHandler()
//    }
//   
////    required init?(coder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
////    }
//    
//    private func dayOfWeekLetter(for dayNumber: Int) -> String {
//        switch dayNumber {
//        case 1:
//            return "Sun"
//        case 2:
//            return "Mon"
//        case 3:
//            return "Tue"
//        case 4:
//            return "Wed"
//        case 5:
//            return "Thu"
//        case 6:
//            return "Fri"
//        case 7:
//            return "Sat"
//        default:
//            return ""
//        }
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        NSLayoutConstraint.activate([
//            NSLayoutConstraint(item: stackViewForButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0),
//            NSLayoutConstraint(item: stackViewForButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0),
////            stackViewForButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
////            closeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 15),
////
////            stackViewForButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
////            stackViewForButton.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: 15),
//
////            closeButton.centerYAnchor.constraint(equalTo: stackViewForButton.centerYAnchor),
////            closeButton.heightAnchor.constraint(equalToConstant: 28),
////            closeButton.widthAnchor.constraint(equalToConstant: 28),
////            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
////
//            dayOfWeekStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            dayOfWeekStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            dayOfWeekStackView.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: -5),
//
//            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            separatorView.heightAnchor.constraint(equalToConstant: 1)
//        ])
//    }
//    
//    lazy var previousMonthButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
//        button.titleLabel?.textAlignment = .left
//        
//        if let chevronImage = UIImage(named: "leftArrow") {
//            let imageAttachment = NSTextAttachment(image: chevronImage)
//            imageAttachment.bounds = CGRect(x: 0, y: -3, width: 12, height: 20)
//            let attributedString = NSMutableAttributedString()
//            
//            attributedString.append(
//                NSAttributedString(attachment: imageAttachment)
//            )
//            
//            attributedString.append(
//                NSAttributedString(string: "     ")
//            )
//            
//            button.setAttributedTitle(attributedString, for: .normal)
//        } else {
////            button.setTitle("Previous", for: .normal)
//        }
//        
//        button.titleLabel?.textColor = .label
//        
//        button.addTarget(self, action: #selector(didTapPreviousMonthButton), for: .touchUpInside)
//        return button
//    }()
//    
//    lazy var nextMonthButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
//        button.titleLabel?.textAlignment = .right
//        
//        
//        
//        if let chevronImage = UIImage(named: "rightArrow") {
//            var imageAttachment = NSTextAttachment(image: chevronImage)
//            imageAttachment.bounds = CGRect(x: 0, y: -7, width: 12, height: 20)
//
//            let attributedString = NSMutableAttributedString(string: "     ")
////            let attributedString = NSMutableAttributedString()
//
//            attributedString.append(
//                NSAttributedString(attachment: imageAttachment)
//            )
//            
//            button.setAttributedTitle(attributedString, for: .normal)
//        } else {
////            button.setTitle("Next", for: .normal)
//        }
//        
//        button.titleLabel?.textColor = .label
//        
//        button.addTarget(self, action: #selector(didTapNextMonthButton), for: .touchUpInside)
//        return button
//    }()
//    
//    @objc func didTapPreviousMonthButton() {
//        didTapLastMonthCompletionHandler()
//    }
//    
//    @objc func didTapNextMonthButton() {
//        didTapNextMonthCompletionHandler()
//    }
//    
//    let didTapLastMonthCompletionHandler: (() -> Void)
//    let didTapNextMonthCompletionHandler: (() -> Void)
////    required init?(coder aDecoder: NSCoder) {
////            super.init(coder: aDecoder)
////    }
//    
//    required init(
//        didTapLastMonthCompletionHandler: @escaping (() -> Void),
//        didTapNextMonthCompletionHandler: @escaping (() -> Void),
//        exitButtonTappedCompletionHandler: @escaping (() -> Void)
//    ) {
//        self.didTapLastMonthCompletionHandler = didTapLastMonthCompletionHandler
//        self.didTapNextMonthCompletionHandler = didTapNextMonthCompletionHandler
//        self.exitButtonTappedCompletionHandler = exitButtonTappedCompletionHandler
//        
//        super.init(frame: CGRect.zero)
//        
//        translatesAutoresizingMaskIntoConstraints = false
//        backgroundColor = .systemGroupedBackground
//        
//        layer.maskedCorners = [
//              .layerMinXMinYCorner,
//              .layerMaxXMinYCorner
//            ]
//        layer.cornerCurve = .continuous
//        layer.cornerRadius = 15
//        
////        addSubview(separatorView)
////        stackViewForButton.addArrangedSubview(previousMonthButton)
////        stackViewForButton.addArrangedSubview(monthLabel)
////        stackViewForButton.addArrangedSubview(nextMonthButton)
////        addSubview(stackViewForButton)
//        
//        
////        addSubview(previousMonthButton)
////        addSubview(monthLabel)
////        addSubview(nextMonthButton)
////
//        
////        addSubview(closeButton)
////        addSubview(dayOfWeekStackView)
////        addSubview(separatorView)
//        
//        for dayNumber in 1...7 {
//            let dayLabel = UILabel()
//            dayLabel.font = .systemFont(ofSize: 10, weight: .bold)
//            dayLabel.textColor = .clrBlack
//            dayLabel.textAlignment = .center
//            dayLabel.text = dayOfWeekLetter(for: dayNumber)
//            
//            // VoiceOver users don't need to hear these days of the week read to them, nor do SwitchControl or Voice Control users need to select them
//            // If fact, they get in the way!
//            // When a VoiceOver user highlights a day of the month, the day of the week is read to them.
//            // That method provides the same amount of context as this stack view does to visual users
//            dayLabel.isAccessibilityElement = false
//            dayOfWeekStackView.addArrangedSubview(dayLabel)
//        }
//        
//        closeButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
//    }
//}
//
//
//
//
//
//
////import UIKit
////
////class CalendarPickerHeaderView: UIView {
////    lazy var monthLabel: UILabel = {
////        let label = UILabel()
////        label.translatesAutoresizingMaskIntoConstraints = false
////        label.font = .systemFont(ofSize: 14)
////        label.text = "Month"
////        label.accessibilityTraits = .header
////        label.isAccessibilityElement = true
////        return label
////    }()
////
////
////    lazy var stackViewForButton: UIStackView = {
////        let stackView = UIStackView()
////        stackView.translatesAutoresizingMaskIntoConstraints = false
////        stackView.axis = .horizontal
////        stackView.accessibilityTraits = .header
////        stackView.isAccessibilityElement = true
////        return stackView
////    }()
////
////
////
////    lazy var closeButton: UIButton = {
////        let button = UIButton()
////        button.translatesAutoresizingMaskIntoConstraints = false
////
////        let configuration = UIImage.SymbolConfiguration(scale: .large)
////        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: configuration)
////        button.setImage(image, for: .normal)
////
////        button.tintColor = .secondaryLabel
////        button.contentMode = .scaleAspectFill
////        button.isUserInteractionEnabled = true
////        button.isAccessibilityElement = true
////        button.accessibilityLabel = "Close Picker"
////        button.isHidden = true
////        return button
////    }()
////
////    lazy var dayOfWeekStackView: UIStackView = {
////        let stackView = UIStackView()
////        stackView.translatesAutoresizingMaskIntoConstraints = false
////        stackView.distribution = .fillEqually
////        return stackView
////    }()
////
////    lazy var separatorView: UIView = {
////        let view = UIView()
////        view.translatesAutoresizingMaskIntoConstraints = false
////        view.backgroundColor = UIColor.label.withAlphaComponent(0.2)
////        return view
////    }()
////
////    private lazy var dateFormatter: DateFormatter = {
////        let dateFormatter = DateFormatter()
////        dateFormatter.calendar = Calendar(identifier: .gregorian)
////        dateFormatter.locale = Locale.autoupdatingCurrent
////        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM")
////        return dateFormatter
////    }()
////
////    var baseDate = Date() {
////        didSet {
////            monthLabel.text = dateFormatter.string(from: baseDate)
////        }
////    }
////
////    var exitButtonTappedCompletionHandler: (() -> Void)
////
////    //  init(exitButtonTappedCompletionHandler: @escaping (() -> Void)) {
////    //    self.exitButtonTappedCompletionHandler = exitButtonTappedCompletionHandler
////    //
////    //    super.init(frame: CGRect.zero)
////    //
////    //    translatesAutoresizingMaskIntoConstraints = false
////    //
////    //    backgroundColor = .systemGroupedBackground
////    //
////    //    layer.maskedCorners = [
////    //      .layerMinXMinYCorner,
////    //      .layerMaxXMinYCorner
////    //    ]
////    //    layer.cornerCurve = .continuous
////    //    layer.cornerRadius = 15
////    //
////    //    addSubview(monthLabel)
////    //    addSubview(closeButton)
////    //    addSubview(dayOfWeekStackView)
////    //    addSubview(separatorView)
////    //
////    //    for dayNumber in 1...7 {
////    //      let dayLabel = UILabel()
////    //      dayLabel.font = .systemFont(ofSize: 10, weight: .bold)
////    //      dayLabel.textColor = .clrBlack
////    //      dayLabel.textAlignment = .center
////    //      dayLabel.text = dayOfWeekLetter(for: dayNumber)
////    //
////    //      // VoiceOver users don't need to hear these days of the week read to them, nor do SwitchControl or Voice Control users need to select them
////    //      // If fact, they get in the way!
////    //      // When a VoiceOver user highlights a day of the month, the day of the week is read to them.
////    //      // That method provides the same amount of context as this stack view does to visual users
////    //      dayLabel.isAccessibilityElement = false
////    //      dayOfWeekStackView.addArrangedSubview(dayLabel)
////    //    }
////    //
////    //    closeButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
////    //  }
////
////    @objc func didTapExitButton() {
////        exitButtonTappedCompletionHandler()
////    }
////
////    required init?(coder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
////    }
////
////    private func dayOfWeekLetter(for dayNumber: Int) -> String {
////        switch dayNumber {
////        case 1:
////            return "Sun"
////        case 2:
////            return "Mon"
////        case 3:
////            return "Tue"
////        case 4:
////            return "Wed"
////        case 5:
////            return "Thu"
////        case 6:
////            return "Fri"
////        case 7:
////            return "Sat"
////        default:
////            return ""
////        }
////    }
////
////    override func layoutSubviews() {
////        super.layoutSubviews()
////
////        NSLayoutConstraint.activate([
////            NSLayoutConstraint(item: stackViewForButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0),
////            NSLayoutConstraint(item: stackViewForButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0),
//////            stackViewForButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
//////            closeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 15),
//////
//////            stackViewForButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
//////            stackViewForButton.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: 15),
////
//////            closeButton.centerYAnchor.constraint(equalTo: stackViewForButton.centerYAnchor),
//////            closeButton.heightAnchor.constraint(equalToConstant: 28),
//////            closeButton.widthAnchor.constraint(equalToConstant: 28),
//////            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
//////
////            dayOfWeekStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
////            dayOfWeekStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
////            dayOfWeekStackView.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: -5),
////
////            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
////            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
////            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
////            separatorView.heightAnchor.constraint(equalToConstant: 1)
////        ])
////    }
////
////    lazy var previousMonthButton: UIButton = {
////        let button = UIButton()
////        button.translatesAutoresizingMaskIntoConstraints = false
////        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
////        button.titleLabel?.textAlignment = .left
////
////        if let chevronImage = UIImage(named: "leftArrow") {
////            let imageAttachment = NSTextAttachment(image: chevronImage)
////            imageAttachment.bounds = CGRect(x: 0, y: -3, width: 12, height: 20)
////            let attributedString = NSMutableAttributedString()
////
////            attributedString.append(
////                NSAttributedString(attachment: imageAttachment)
////            )
////
////            attributedString.append(
////                NSAttributedString(string: "     ")
////            )
////
////            button.setAttributedTitle(attributedString, for: .normal)
////        } else {
//////            button.setTitle("Previous", for: .normal)
////        }
////
////        button.titleLabel?.textColor = .label
////
////        button.addTarget(self, action: #selector(didTapPreviousMonthButton), for: .touchUpInside)
////        return button
////    }()
////
////    lazy var nextMonthButton: UIButton = {
////        let button = UIButton()
////        button.translatesAutoresizingMaskIntoConstraints = false
////        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
////        button.titleLabel?.textAlignment = .right
////
////
////
////        if let chevronImage = UIImage(named: "rightArrow") {
////            var imageAttachment = NSTextAttachment(image: chevronImage)
////            imageAttachment.bounds = CGRect(x: 0, y: -7, width: 12, height: 20)
////
////            let attributedString = NSMutableAttributedString(string: "     ")
//////            let attributedString = NSMutableAttributedString()
////
////            attributedString.append(
////                NSAttributedString(attachment: imageAttachment)
////            )
////
////            button.setAttributedTitle(attributedString, for: .normal)
////        } else {
//////            button.setTitle("Next", for: .normal)
////        }
////
////        button.titleLabel?.textColor = .label
////
////        button.addTarget(self, action: #selector(didTapNextMonthButton), for: .touchUpInside)
////        return button
////    }()
////
////    @objc func didTapPreviousMonthButton() {
////        didTapLastMonthCompletionHandler()
////    }
////
////    @objc func didTapNextMonthButton() {
////        didTapNextMonthCompletionHandler()
////    }
////
////    let didTapLastMonthCompletionHandler: (() -> Void)
////    let didTapNextMonthCompletionHandler: (() -> Void)
////
////    init(
////        didTapLastMonthCompletionHandler: @escaping (() -> Void),
////        didTapNextMonthCompletionHandler: @escaping (() -> Void),
////        exitButtonTappedCompletionHandler: @escaping (() -> Void)
////    ) {
////        self.didTapLastMonthCompletionHandler = didTapLastMonthCompletionHandler
////        self.didTapNextMonthCompletionHandler = didTapNextMonthCompletionHandler
////        self.exitButtonTappedCompletionHandler = exitButtonTappedCompletionHandler
////
////        super.init(frame: CGRect.zero)
////
////        translatesAutoresizingMaskIntoConstraints = false
////        backgroundColor = .systemGroupedBackground
////
////        layer.maskedCorners = [
////              .layerMinXMinYCorner,
////              .layerMaxXMinYCorner
////            ]
////        layer.cornerCurve = .continuous
////        layer.cornerRadius = 15
////
//////        addSubview(separatorView)
////        stackViewForButton.addArrangedSubview(previousMonthButton)
////        stackViewForButton.addArrangedSubview(monthLabel)
////        stackViewForButton.addArrangedSubview(nextMonthButton)
////        addSubview(stackViewForButton)
////
////
//////        addSubview(previousMonthButton)
//////        addSubview(monthLabel)
//////        addSubview(nextMonthButton)
//////
////
////        addSubview(closeButton)
////        addSubview(dayOfWeekStackView)
////        addSubview(separatorView)
////
////        for dayNumber in 1...7 {
////            let dayLabel = UILabel()
////            dayLabel.font = .systemFont(ofSize: 10, weight: .bold)
////            dayLabel.textColor = .clrBlack
////            dayLabel.textAlignment = .center
////            dayLabel.text = dayOfWeekLetter(for: dayNumber)
////
////            // VoiceOver users don't need to hear these days of the week read to them, nor do SwitchControl or Voice Control users need to select them
////            // If fact, they get in the way!
////            // When a VoiceOver user highlights a day of the month, the day of the week is read to them.
////            // That method provides the same amount of context as this stack view does to visual users
////            dayLabel.isAccessibilityElement = false
////            dayOfWeekStackView.addArrangedSubview(dayLabel)
////        }
////
////        closeButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
////    }
////}
