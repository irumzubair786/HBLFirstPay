//
//  CalendarOverDueDateCell.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 24/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class CalendarOverDueDateCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: CalendarOverDueDateCell.self)
    
    @IBOutlet weak var viewBackGroundPrice: UIView!
    @IBOutlet weak var viewDateBackGround: UIView!
    @IBOutlet weak var viewMainBackGround: UIView!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    var modelGetSchCalendar: CalendarPickerViewController.ModelGetSchCalendar? {
        didSet {
            
        }
    }
    
    private lazy var accessibilityDateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.calendar = Calendar(identifier: .gregorian)
      dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d")
      return dateFormatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labelDate.textColor = .clrLightGrayCalendar
        labelPrice.textColor = .clrLightGrayCalendar
//        labelStatus.textColor = .clrLightRed

        labelPrice.text = ""
        labelStatus.text = ""
        
    }
    var day: Day? {
      didSet {
        guard let day = day else { return }
          if self.labelDate != nil {
              self.labelDate.text = (day.number)
              accessibilityLabel = accessibilityDateFormatter.string(from: day.date)
              self.updateStatus()
          }
        
      }
    }
    
    
    func updateStatus() {
        if let tempDate = day?.date.convertDateToStringForCalendar() {
            if let modelDate = modelGetSchCalendar?.data.dates[tempDate] {
                DispatchQueue.main.async {
                    self.foundRecord(modelDate: modelDate)
                }
            }
        }
    }
    
    func foundRecord(modelDate: CalendarPickerViewController.ModelGetSchCalendarDateValue) {
        defaultCalendarDate()
        accessibilityHint = nil
        
        labelPrice.text = "Rs. \(modelDate.markup)"
        labelStatus.text = "OVER DUE"
        
        labelPrice.isHidden = false
        self.viewDateBackGround.isHidden = false
        labelStatus.isHidden = false
        labelStatus.textColor = .clrGreen
        self.labelStatus.radius(color: .clrGreen)
        self.labelStatus.circle()
        
        //Check if Current Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        let stringCurrentFromDate = dateFormatter.string(from: Date())
        let compare = stringCurrentFromDate.compareDateDifferenceToDate2(toDate: day!.date)
        
        if compare == 0 {
            self.viewDateBackGround.isHidden = false
            labelStatus.isHidden = false
            labelPrice.isHidden = false
            labelStatus.textColor = .clrLightRed
            labelPrice.textColor = .clrLightRed
            labelDate.textColor = .clrLightRed

            labelPrice.text = "Rs. \("\(modelDate.markup)".getIntegerValue())"
            labelStatus.text = "OVER DUE"
            self.labelStatus.radius(color: .clrLightRed)
            self.labelStatus.backgroundColor = .clrLightRedWithOccupacy20
            self.labelStatus.circle()

            labelPrice.textColor = .clrLightRed
            labelDate.textColor = .clrLightRed
            self.viewDateBackGround.radiusLineDashedStroke(color: .clrGreen)
            self.viewDateBackGround.backgroundColor = .clrLightRedWithOccupacy05
        }
        else {
            
        }
    }
    func defaultCalendarDate() {
        if self.viewDateBackGround == nil {
            return
        }
        labelDate.textColor = .lightGray
        labelStatus.text = nil
        labelPrice.text = nil
        labelStatus.isHidden = true
        labelPrice.isHidden = true
        self.viewDateBackGround.isHidden = true
    }
    
    
}
