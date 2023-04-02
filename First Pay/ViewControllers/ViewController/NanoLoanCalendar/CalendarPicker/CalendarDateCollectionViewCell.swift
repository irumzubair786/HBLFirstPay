//
//  CalendarDateCollectionViewCell.swift
//  HBLFMB
//
//  Created by Apple on 28/03/2023.
//

import UIKit

class CalendarDateCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: CalendarDateCollectionViewCell.self)
    
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

        labelPrice.text = "Rs. 240"
        labelStatus.text = "DUE DATE"
        
        DispatchQueue.main.async {
            self.viewDateBackGround.radiusLineDashedStroke(color: .clrLightRed)
            self.labelStatus.radius(color: .clrLightRed)
            DispatchQueue.main.async {
                self.labelStatus.circle()
                
            }
        }
        
    }
    var day: Day? {
      didSet {
        guard let day = day else { return }
          if self.labelDate != nil {
              self.labelDate.text = (day.number) + "\n" + "S"
          }
        accessibilityLabel = accessibilityDateFormatter.string(from: day.date)
        updateSelectionStatus()
      }
    }
}

// MARK: - Appearance
private extension CalendarDateCollectionViewCell {
  // 1
  func updateSelectionStatus() {
    guard let day = day else { return }

    if day.isSelected {
      applySelectedStyle()
    } else {
      applyDefaultStyle(isWithinDisplayedMonth: day.isWithinDisplayedMonth)
    }
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
