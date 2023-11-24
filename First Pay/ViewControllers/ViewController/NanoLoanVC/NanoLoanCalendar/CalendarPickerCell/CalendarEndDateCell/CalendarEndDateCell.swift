//
//  CalendarEndDateCell.swift
//  First Pay
//
//  Created by Apple on 13/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class CalendarEndDateCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: CalendarEndDateCell.self)
    
    @IBOutlet weak var viewBackGroundPrice: UIView!
    @IBOutlet weak var viewDateBackGround: UIView!
    @IBOutlet weak var viewMainBackGround: UIView!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
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
        labelStatus.textColor = .clrLightRed

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
            if let modelDate = modelGetSchCalendar?.data.dates[tempDate] {
//                ifEndDate(modelDate: modelDate)
                forceEndDate(modelDate: modelDate)
            }
            else {
                forceEndDate(modelDate: nil)
            }
            //Upper Comment mention code is fine
            
        }
    }
    
    func forceEndDate(modelDate: CalendarPickerViewController.ModelGetSchCalendarDateValue?) {
        self.viewDateBackGround.isHidden = true
        labelStatus.isHidden = false
        labelStatus.textColor = .clrLightRed
        labelPrice.textColor = .clrLightRed
        labelDate.textColor = .clrLightRed

        if modelDate?.markup != nil {
            labelPrice.text = "Rs. \(modelDate?.markup ?? 0)"
        }
        else {
            labelPrice.text = "Rs. 0.00"
        }
        labelStatus.text = "END DATE"
        self.labelStatus.backgroundColor = .clrLightRedWithOccupacy20
        
        self.viewBackGroundPrice.radius(color: .clrLightRed)
        self.viewBackGroundPrice.backgroundColor = .clrLightRedWithOccupacy20
        self.viewBackGroundPrice.circle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.labelStatus.radius(color: .clrLightRed)
            self.labelStatus.circle()
        }
    }
    
    func foundRecord(modelDate: CalendarPickerViewController.ModelGetSchCalendarDateValue) {
        defaultCalendarDate()
        accessibilityHint = nil
        labelPrice.isHidden = false
        self.viewDateBackGround.isHidden = false
        self.viewDateBackGround.radiusLineDashedStroke(color: .clrTextNormal)
        labelDate.textColor = .clrTextNormal
        labelStatus.textColor = .clrTextNormal
        
        labelPrice.text = "Rs. \(modelDate.markup)"
        
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
                self.viewBackGroundPrice.radius(color: .clrLightRed)
                
                self.viewBackGroundPrice.backgroundColor = .clrLightRedWithOccupacy20
                self.labelStatus.backgroundColor = .clrLightRedWithOccupacy20
                
                DispatchQueue.main.async {
                    self.viewBackGroundPrice.radius(color: .clrLightRed)
                    self.viewBackGroundPrice.circle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.labelStatus.circle()
                    }
                    
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
