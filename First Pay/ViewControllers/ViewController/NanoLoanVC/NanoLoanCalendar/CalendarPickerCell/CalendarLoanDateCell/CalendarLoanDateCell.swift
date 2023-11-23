//
//  CalendarLoanDateCell.swift
//  First Pay
//
//  Created by Apple on 13/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class CalendarLoanDateCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: CalendarLoanDateCell.self)
    
    @IBOutlet weak var viewDateBackGround: UIView!
    @IBOutlet weak var viewMainBackGround: UIView!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    var modelGetSchCalendar: CalendarPickerViewController.ModelGetSchCalendar? {
        didSet {
            
        }
    }
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

    func updateStatus() {
        if let tempDate = day?.date.convertDateToStringForCalendar() {
            if let modelDate = modelGetSchCalendar?.data.dates[tempDate] {
                foundRecord(modelDate: modelDate)
            }
        }
    }
    
    func foundRecord(modelDate: CalendarPickerViewController.ModelGetSchCalendarDateValue) {
        defaultCalendarDate()
        accessibilityHint = nil
        
        labelPrice.text = "Rs. \(modelDate.markup)"
        
        labelStatus.isHidden = true
        labelPrice.isHidden = false
        self.viewDateBackGround.isHidden = false
        self.viewDateBackGround.backgroundColor = .clrLightGrayCalendarWithOccupacy05
        DispatchQueue.main.async {
            self.viewDateBackGround.radiusLineDashedStroke(color: .clrTextNormal)
        }
        labelDate.textColor = .clrTextNormal
        labelStatus.textColor = .clrTextNormal        
        ifCurrentDate()
    }
    
    func ifCurrentDate() {
        //Check if Current Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        let stringCurrentFromDate = dateFormatter.string(from: Date())
        let compare = stringCurrentFromDate.compareDateDifferenceToDate2(toDate: day!.date)
        if compare == 0 {
            //currentDateRecord
            labelPrice.textColor = .clrGreen
            labelDate.textColor = .clrGreen
            self.viewDateBackGround.radiusLineDashedStroke(color: .clrGreen)
            self.viewDateBackGround.backgroundColor = .clrGreenWithOccupacy05
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
