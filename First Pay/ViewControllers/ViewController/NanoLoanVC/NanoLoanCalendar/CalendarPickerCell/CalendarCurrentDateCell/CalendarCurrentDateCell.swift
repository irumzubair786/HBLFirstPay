//
//  CalendarCurrentDateCell.swift
//  First Pay
//
//  Created by Apple on 13/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class CalendarCurrentDateCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: CalendarCurrentDateCell.self)
    
    @IBOutlet weak var viewDateBackGround: UIView!
    @IBOutlet weak var viewMainBackGround: UIView!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    var isDefaultDay = 0
    
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
              
//              updateSelectionStatus()
          }
        
      }
    }
    
    var modelGetSchCalendar: CalendarPickerViewController.ModelGetSchCalendar? {
        didSet {
            
        }
    }
    func updateStatus() {
        if let tempDate = day?.date.convertDateToStringForCalendar() {
//            print(tempDate)
            if modelGetSchCalendar == nil {
                defaultCalendarDate()
            }
            else {
                if let modelDate = modelGetSchCalendar?.data.dates[tempDate] {
                    if isDefaultDay == 1 {
                        defaultCalendarDate()
                    }
                    else {
                        foundRecord(modelDate: modelDate)
                    }
                    
                }
                else {
                    defaultCalendarDate()
                }
            }
        }
        else {
            defaultCalendarDate()
        }
    }
    
    func foundRecord(modelDate: CalendarPickerViewController.ModelGetSchCalendarDateValue) {
        defaultCalendarDate()
        accessibilityHint = nil
//        labelStatus.isHidden = true
        labelPrice.isHidden = false
        self.viewDateBackGround.isHidden = false
        self.viewDateBackGround.radiusLineDashedStroke(color: .clrTextNormal)
        labelDate.textColor = .clrTextNormal
        labelStatus.textColor = .clrTextNormal
        
        labelPrice.text = "Rs. \(modelDate.markup)"
        
        ifStartDate(modelDate: modelDate)
        ifEndDate(modelDate: modelDate)
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
    func ifStartDate(modelDate: CalendarPickerViewController.ModelGetSchCalendarDateValue) {
        if let startDate = modelGetSchCalendar?.data.startDate {

            let compare = startDate.compareDateDifferenceToDate2(toDate: day!.date)
            if compare == 0 {
                print("Start-Date: \(startDate)")
                print("Calendar-Date: \(day!.date)")
                let calendarDate = "\(day!.date)".components(separatedBy: " ").first
                let startDatee = startDate.components(separatedBy: " ").first
                if calendarDate == startDatee {
                    print("Date Match \(calendarDate!)-\(startDatee!)")
                    labelStatus.isHidden = false
                    labelStatus.textColor = .clrGreen
                    labelStatus.text = "START DATE"
                    self.labelStatus.radius(color: .clrGreen)
                    self.labelStatus.circle()
                }
            }

//            print(compare)
        }
    }
    
    func ifEndDate(modelDate: CalendarPickerViewController.ModelGetSchCalendarDateValue) {
        if let endDate = modelGetSchCalendar?.data.endDate {
            let compare = endDate.compareDateDifferenceToDate2(toDate: day!.date)
            if compare == 0 {
                self.viewDateBackGround.isHidden = true
                labelStatus.isHidden = false
                labelStatus.textColor = .clrLightRed
                labelPrice.textColor = .clrLightRed
                labelDate.textColor = .clrLightRed

                labelPrice.text = "Rs. \(modelDate.markup)"
                labelStatus.text = "End DATE"
                self.labelStatus.radius(color: .clrLightRed)
                self.labelDate.radius(color: .clrLightRed)
                self.labelStatus.circle()
                self.labelDate.circle()
                DispatchQueue.main.async {
                    
                }
            }
//            print(compare)
        }
    }
    
}

// MARK: - Appearance
private extension CalendarDateCollectionViewCell {
  // 1
  func updateSelectionStatus() {
    guard let day = day else { return }
      
//    if day.isSelected {
//      applySelectedStyle()
//    } else {
//      applyDefaultStyle(isWithinDisplayedMonth: day.isWithinDisplayedMonth)
//    }
  }

  // 2
  var isSmallScreenSize: Bool {
    let isCompact = traitCollection.horizontalSizeClass == .compact
    let smallWidth = UIScreen.main.bounds.width <= 350
    let widthGreaterThanHeight = UIScreen.main.bounds.width > UIScreen.main.bounds.height

    return isCompact && (smallWidth || widthGreaterThanHeight)
  }

  // 3
  func applySelectedStyle() {
//    accessibilityTraits.insert(.selected)
    accessibilityHint = nil

    //labelDate.textColor = isSmallScreenSize ? .systemRed : .white
    //selectionBackgroundView.isHidden = isSmallScreenSize
  }

  // 4
  func applyDefaultStyle(isWithinDisplayedMonth: Bool) {
//    accessibilityTraits.remove(.selected)
    accessibilityHint = "Tap to select"

      labelDate.textColor = isWithinDisplayedMonth ? .label : .secondaryLabel
//    selectionBackgroundView.isHidden = true
  }
}
