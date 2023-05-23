
import UIKit
import Alamofire

class CalendarPickerViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonBack: UIButton!
    var modelGetActiveLoan: NanoLoanApplyViewController.ModelGetActiveLoan? {
        didSet {
            
        }
    }
    var modelGetSchCalendar: ModelGetSchCalendar? {
        didSet {
            if modelGetSchCalendar?.responsecode == 0 {
                self.showAlertCustomPopup(title: "Error!", message: modelGetSchCalendar?.messages, iconName: .iconError)
            }
            else {
                collectionView.reloadData()
            }
        }
    }
    
    //    @IBOutlet weak var monthLabel: UILabel!
    // MARK: Views
    private lazy var dimmedBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return view
    }()
    
    //    private lazy var collectionView: UICollectionView = {
    //        let layout = UICollectionViewFlowLayout()
    //        layout.minimumLineSpacing = 0
    //        layout.minimumInteritemSpacing = 0
    //
    //        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    //        collectionView.isScrollEnabled = false
    //        collectionView.translatesAutoresizingMaskIntoConstraints = false
    //        return collectionView
    //    }()
    private var headerView: CalendarPickerHeaderView!
    //    private lazy var headerView = CalendarPickerHeaderView(
    //        didTapLastMonthCompletionHandler: { [weak self] in
    //            guard let self = self else { return }
    //
    //            self.baseDate = self.calendar.date(
    //                byAdding: .month,
    //                value: -1,
    //                to: self.baseDate
    //            ) ?? self.baseDate
    //        },
    //        didTapNextMonthCompletionHandler: { [weak self] in
    //            guard let self = self else { return }
    //
    //            self.baseDate = self.calendar.date(
    //                byAdding: .month,
    //                value: 1,
    //                to: self.baseDate
    //            ) ?? self.baseDate
    //        }) { [weak self] in
    //
    //            guard let self = self else { return }
    //            self.dismiss(animated: true)
    //
    //
    //        }
    
    private lazy var footerView = CalendarPickerFooterView(
        didTapLastMonthCompletionHandler: { [weak self] in
            guard let self = self else { return }
            
            self.baseDate = self.calendar.date(
                byAdding: .month,
                value: -1,
                to: self.baseDate
            ) ?? self.baseDate
        },
        didTapNextMonthCompletionHandler: { [weak self] in
            guard let self = self else { return }
            
            self.baseDate = self.calendar.date(
                byAdding: .month,
                value: 1,
                to: self.baseDate
            ) ?? self.baseDate
        })
    
    // MARK: Calendar Data Values
    
    private lazy var days = generateDaysInMonth(for: baseDate)
    
    private var selectedDate: Date! = Date()
    private var baseDate: Date! = nil {
        didSet {
            days = generateDaysInMonth(for: baseDate)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            headerView.baseDate = baseDate
        }
    }
    
    var numberOfWeeksInBaseDate: Int {
        calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 7
    }
    
    private var selectedDateChanged: ((Date) -> Void)!
    private let calendar = Calendar(identifier: .gregorian)
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()
    
    // MARK: Initializers
    
    //  init(baseDate: Date, selectedDateChanged: @escaping ((Date) -> Void)) {
    //    self.selectedDate = baseDate
    //    self.baseDate = baseDate
    //    self.selectedDateChanged = selectedDateChanged
    //
    //    super.init(nibName: nil, bundle: nil)
    //
    //    modalPresentationStyle = .overCurrentContext
    //    modalTransitionStyle = .crossDissolve
    //    definesPresentationContext = true
    //  }
    
    //  required init?(coder: NSCoder) {
    //    fatalError("init(coder:) has not been implemented")
    //  }
    
    @IBOutlet weak var headerViewLocal: UIView!
    // MARK: View Lifecycle
    override func viewDidAppear(_ animated: Bool) {
//        collectionView.reloadData()
    }
   
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "CalendarDateCollectionViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "CalendarDateCollectionViewCell")
        
        let cellNibStart = UINib(nibName: "CalendarStartDateCell", bundle: nil)
        collectionView.register(cellNibStart, forCellWithReuseIdentifier: "CalendarStartDateCell")
        
        let cellNibEnd = UINib(nibName: "CalendarEndDateCell", bundle: nil)
        collectionView.register(cellNibEnd, forCellWithReuseIdentifier: "CalendarEndDateCell")
        
        let cellNibDefault = UINib(nibName: "CalendarDefaultDateCell", bundle: nil)
        collectionView.register(cellNibDefault, forCellWithReuseIdentifier: "CalendarDefaultDateCell")
        
        let cellNibLoan = UINib(nibName: "CalendarLoanDateCell", bundle: nil)
        collectionView.register(cellNibLoan, forCellWithReuseIdentifier: "CalendarLoanDateCell")
        
        let cellNibCurrent = UINib(nibName: "CalendarCurrentDateCell", bundle: nil)
        collectionView.register(cellNibCurrent, forCellWithReuseIdentifier: "CalendarCurrentDateCell")
        
        
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionView.collectionViewLayout = layout
        
        //         collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .systemGroupedBackground
        
        headerView = (CalendarPickerHeaderView.instanceFromNib() as! CalendarPickerHeaderView)
        headerView.instantiate(
            didTapLastMonthCompletionHandler: { [weak self] in
                guard let self = self else { return }
                
                self.baseDate = self.calendar.date(
                    byAdding: .month,
                    value: -1,
                    to: self.baseDate
                ) ?? self.baseDate
            },
            didTapNextMonthCompletionHandler: { [weak self] in
                guard let self = self else { return }
                
                self.baseDate = self.calendar.date(
                    byAdding: .month,
                    value: 1,
                    to: self.baseDate
                ) ?? self.baseDate
            }) { [weak self] in
                
                guard let self = self else { return }
                self.dismiss(animated: true)
                
            }
        self.headerView.frame = self.headerViewLocal.frame
        self.headerViewLocal.addSubview(self.headerView)
        self.headerView.frame.origin.x = 0
        self.headerView.frame.origin.y = 0

        
        //        view.addSubview(dimmedBackgroundView)
        //        view.addSubview(collectionView)
        //        view.addSubview(headerView)
//        view.addSubview(footerView)
        
        //        var constraints = [
        //            dimmedBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        //            dimmedBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        //            dimmedBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
        //            dimmedBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        //        ]
        
        //        constraints.append(contentsOf: [
        //            //1
        //            collectionView.leadingAnchor.constraint(
        //                equalTo: view.readableContentGuide.leadingAnchor),
        //            collectionView.trailingAnchor.constraint(
        //                equalTo: view.readableContentGuide.trailingAnchor),
        //            //2
        //            collectionView.centerYAnchor.constraint(
        //                equalTo: view.centerYAnchor,
        //                constant: 10),
        //            //3
        //            collectionView.heightAnchor.constraint(
        //                equalTo: view.heightAnchor,
        //                multiplier: 0.5)
        //        ])
        
        //        constraints.append(contentsOf: [
        ////            headerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
        ////            headerView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
        ////            headerView.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
        ////            headerView.heightAnchor.constraint(equalToConstant: 85),
        //
        //            footerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
        //            footerView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
        //            footerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
        //            footerView.heightAnchor.constraint(equalToConstant: 60)
        //        ])
        
        //        NSLayoutConstraint.activate(constraints)
        
//        collectionView.register(
//            CalendarDateCollectionViewCell.self,
//            forCellWithReuseIdentifier: CalendarDateCollectionViewCell.reuseIdentifier
//        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
        self.baseDate = Date()
        headerView.baseDate = baseDate
        self.selectedDate = baseDate
//        collectionView.reloadData()
        
        loadCalendarData()
    }
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.reloadData()
    }
    
    
    
    func loadCalendarData() {
        let currentLoan = modelGetActiveLoan?.data?.currentLoan.first
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "nlDisbursementId" :  "\(currentLoan?.nlDisbursementID ?? 0)"
        ]
        //NOTE:
        //        agar currentLoan object me data araha ha to ye api call ni ho ge
        //        agar ni a raha to ye api call karin ga r data disply karwa dain ga
        APIs.postAPI(apiName: .getSchCalendar, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: ModelGetSchCalendar? = APIs.decodeDataToObject(data: responseData)
            self.modelGetSchCalendar = model
        }
    }
}

// MARK: - Day Generation
private extension CalendarPickerViewController {
    // 1
    func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
        // 2
        guard
            let numberOfDaysInMonth = calendar.range(
                of: .day,
                in: .month,
                for: baseDate)?.count,
            let firstDayOfMonth = calendar.date(
                from: calendar.dateComponents([.year, .month], from: baseDate))
        else {
            // 3
            throw CalendarDataError.metadataGeneration
        }
        
        // 4
        let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        // 5
        return MonthMetadata(
            numberOfDays: numberOfDaysInMonth,
            firstDay: firstDayOfMonth,
            firstDayWeekday: firstDayWeekday)
    }
    
    // 1
    func generateDaysInMonth(for baseDate: Date) -> [Day] {
        // 2
        guard let metadata = try? monthMetadata(for: baseDate) else {
            preconditionFailure("An error occurred when generating the metadata for \(baseDate)")
        }
        
        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday
        let firstDayOfMonth = metadata.firstDay
        
        // 3
        var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow))
            .map { day in
                // 4
                let isWithinDisplayedMonth = day >= offsetInInitialRow
                // 5
                let dayOffset =
                isWithinDisplayedMonth ?
                day - offsetInInitialRow :
                -(offsetInInitialRow - day)
                
                // 6
                return generateDay(
                    offsetBy: dayOffset,
                    for: firstDayOfMonth,
                    isWithinDisplayedMonth: isWithinDisplayedMonth)
            }
        
        days += generateStartOfNextMonth(using: firstDayOfMonth)
        
        return days
    }
    
    // 7
    func generateDay(
        offsetBy dayOffset: Int,
        for baseDate: Date,
        isWithinDisplayedMonth: Bool
    ) -> Day {
        let date = calendar.date(
            byAdding: .day,
            value: dayOffset,
            to: baseDate)
        ?? baseDate
        
        return Day(
            date: date,
            number: dateFormatter.string(from: date),
            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
            isWithinDisplayedMonth: isWithinDisplayedMonth
        )
    }
    
    // 1
    func generateStartOfNextMonth(
        using firstDayOfDisplayedMonth: Date
    ) -> [Day] {
        // 2
        guard
            let lastDayInMonth = calendar.date(
                byAdding: DateComponents(month: 1, day: -1),
                to: firstDayOfDisplayedMonth)
        else {
            return []
        }
        
        // 3
        let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
        guard additionalDays > 0 else {
            return []
        }
        
        // 4
        let days: [Day] = (1...additionalDays)
            .map {
                generateDay(
                    offsetBy: $0,
                    for: lastDayInMonth,
                    isWithinDisplayedMonth: false)
            }
        
        return days
    }
    
    enum CalendarDataError: Error {
        case metadataGeneration
    }
}

// MARK: - UICollectionViewDataSource
extension CalendarPickerViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        days.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let day = days[indexPath.row]
        
        if modelGetSchCalendar == nil {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CalendarDefaultDateCell.reuseIdentifier,
                for: indexPath) as! CalendarDefaultDateCell
            cell.modelGetSchCalendar = modelGetSchCalendar
            cell.day = day
            
            return cell
        }
        let type = getCellType(day: day)
        
        
        if type.0 == "currentDateRecord" {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CalendarCurrentDateCell.reuseIdentifier,
                for: indexPath) as! CalendarCurrentDateCell
            cell.modelGetSchCalendar = modelGetSchCalendar
            cell.day = day
            
            return cell
        }
        else if type.1 == 99 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CalendarDateCollectionViewCell.reuseIdentifier,
                for: indexPath) as! CalendarDateCollectionViewCell
            cell.modelGetSchCalendar = modelGetSchCalendar
            cell.day = day
            
            return cell
        }
        if type.0 == "startDateRecord" {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CalendarStartDateCell.reuseIdentifier,
                for: indexPath) as! CalendarStartDateCell
            cell.modelGetSchCalendar = modelGetSchCalendar
            cell.day = day
            
            return cell
        }
        else if type.0 == "endDateRecord" {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CalendarEndDateCell.reuseIdentifier,
                for: indexPath) as! CalendarEndDateCell
            cell.modelGetSchCalendar = modelGetSchCalendar
            cell.day = day
            
            return cell
        }
        else if type.0 == "loanDateRecord" {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CalendarLoanDateCell.reuseIdentifier,
                for: indexPath) as! CalendarLoanDateCell
            cell.modelGetSchCalendar = modelGetSchCalendar
            cell.day = day
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CalendarDefaultDateCell.reuseIdentifier,
                for: indexPath) as! CalendarDefaultDateCell
            cell.modelGetSchCalendar = modelGetSchCalendar
            cell.day = day
            
            return cell
//            let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: CalendarDateCollectionViewCell.reuseIdentifier,
//                for: indexPath) as! CalendarDateCollectionViewCell
//            cell.modelGetSchCalendar = modelGetSchCalendar
//            cell.day = day
//
//            return cell
        }
        
    
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarDateCollectionViewCell.reuseIdentifier,
            for: indexPath) as! CalendarDateCollectionViewCell
        // swiftlint:disable:previous force_cast
        //        cell.labelDate.text = day.number
        cell.modelGetSchCalendar = modelGetSchCalendar
        cell.day = day
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        (cell as! CalendarDateCollectionViewCell).updateStatus()
    }
    
    func getCellType(day: Day?) -> (String, Int) {
        if let tempDate = day?.date.convertDateToStringForCalendar() {
            if modelGetSchCalendar == nil {
                return ("default" , 99)
            }
            else {
                if let _ = modelGetSchCalendar?.data.dates[tempDate] {
                    
                    if let startDate = modelGetSchCalendar?.data.startDate {
                        let compareDays = fetchCompareDaysFromDatetoToDate(fromDate: startDate, todate: day!.date)
                        if compareDays == 0 {
                            return ("startDateRecord" , compareDays)
                        }
                    }
                    
                    if let endDate = modelGetSchCalendar?.data.endDate {
                        
                        let compareDays = fetchCompareDaysFromDatetoToDate(fromDate: endDate, todate: day!.date)
                        
                        if compareDays == 0 {
                            return ("endDateRecord" , compareDays)
                        }
                    }
                    
                    let compareDays = fetchCompareDaysFromCurrentDate(date: day!.date)
                    
                    if compareDays == 0 {
                        return ("currentDateRecord" , compareDays)
                    }
                    else if compareDays > 0 {
                        return ("loanDateRecord" , compareDays)
                    }
                    return ("default" , compareDays)
                }
                else {
                    return ("recordFound" , 0)
                }
            }
        }
        else {
            return ("default", 99)
        }
    }
    
    
    func fetchCompareDaysFromDatetoToDate(fromDate: String, todate: Date) -> Int {
        let dateCalendar = fetchFormatedDate(date: todate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let stringCurrentFromDate = dateFormatter.string(from: date)
        let compareDays = fromDate.compareDateDifferenceToDate2(toDate: dateCalendar)
        
        print(compareDays)
        return compareDays
    }
    
    func fetchCompareDaysFromCurrentDate(date: Date) -> Int {
        let dateCalendar = fetchFormatedDate(date: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringCurrentFromDate = dateFormatter.string(from: Date())
        let compareDays = stringCurrentFromDate.compareDateDifferenceToDate2(toDate: dateCalendar)
        
        print(compareDays)
        return compareDays
    }

    func fetchFormatedDate(date: Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringCurrentFromDate = dateFormatter.string(from: date)
        let stringDate = dateFormatter.string(from: date)
        let date = dateFormatter.date(from: stringDate)!
        
        return date
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CalendarPickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let day = days[indexPath.row]
        //        selectedDateChanged(day.date)
        //        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = Int(collectionView.frame.width / 7)
        let height = Int(collectionView.frame.height) / numberOfWeeksInBaseDate
        return CGSize(width: width, height: height)
    }
}
