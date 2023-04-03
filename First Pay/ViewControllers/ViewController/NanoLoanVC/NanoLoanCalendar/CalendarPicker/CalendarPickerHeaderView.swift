//
//  CalendarPickerHeaderView2.swift
//  HBLFMB
//
//  Created by Apple on 27/03/2023.
//

import UIKit

class CalendarPickerHeaderView: UIView {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    
    var didTapLastMonthCompletionHandler: (() -> Void)!
    var didTapNextMonthCompletionHandler: (() -> Void)!
    var exitButtonTappedCompletionHandler: (() -> Void)!
    
    var baseDate = Date() {
        didSet {
            monthLabel.text = dateFormatter.string(from: baseDate).uppercased()
        }
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM")
        return dateFormatter
    }()
    
    @IBOutlet weak var dayOfWeekStackView: UIStackView!
    
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CalendarPickerHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func instantiate(
        didTapLastMonthCompletionHandler: @escaping (() -> Void),
        didTapNextMonthCompletionHandler: @escaping (() -> Void),
        exitButtonTappedCompletionHandler: @escaping (() -> Void)
    ) {
        
        self.didTapLastMonthCompletionHandler = didTapLastMonthCompletionHandler
        self.didTapNextMonthCompletionHandler = didTapNextMonthCompletionHandler
        self.exitButtonTappedCompletionHandler = exitButtonTappedCompletionHandler
        
        dayOfWeekStackView.translatesAutoresizingMaskIntoConstraints = false
        for dayNumber in 1...7 {
            let dayLabel = UILabel()
            dayLabel.font = .systemFont(ofSize: 10, weight: .bold)
            dayLabel.textColor = .clrBlack
            dayLabel.textAlignment = .center
            dayLabel.text = dayOfWeekLetter(for: dayNumber)
            dayLabel.isAccessibilityElement = false
            dayOfWeekStackView.addArrangedSubview(dayLabel)
        }
    }
    
    
    @IBAction func buttonBack(_ sender: Any) {
        didTapPreviousMonthButton()
    }
    @IBAction func buttonNext(_ sender: Any) {
        didTapNextMonthButton()
    }
    @objc func didTapPreviousMonthButton() {
        didTapLastMonthCompletionHandler()
    }
    @objc func didTapNextMonthButton() {
        didTapNextMonthCompletionHandler()
    }
    
    
    private func dayOfWeekLetter(for dayNumber: Int) -> String {
        switch dayNumber {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            return ""
        }
    }
}



