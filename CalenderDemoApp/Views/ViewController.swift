//
//  ViewController.swift
//  CalenderDemoApp
//
//  Created by Dinesh Rajput on 11/03/24.
//https://github.com/kvyatkovskys/KVKCalendar

import UIKit
//import KVKCalendar
import EventKit

// MARK: - Enum Created
enum VidhikCalendaType {
    case today
    case week
    case month
    var height: CGFloat {
        switch self {
        case .today:
            return 1
        case .week:
            return 70
        case .month:
            return 70
        }
    }
}

enum ArrowAction {
    case back
    case forward
}

class ViewController: UIViewController, KVKCalendarSettings, KVKCalendarDataModel {
    
    // MARK: - IBOutlets Properties
    @IBOutlet weak var calendarView1: UIView!
    @IBOutlet weak var calenderBackWrodButton: UIButton!
    @IBOutlet weak var calenderForWrodButton: UIButton!
    
    @IBOutlet weak var showSelectedDateLabel: UILabel!
    
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var monthButton: UIButton!
    
    @IBOutlet weak var todayView: UIView!
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var monthView: UIView!
    
    // MARK: - Created Instance Properties
    
    var selectedCalenderType: VidhikCalendaType = .month
    var currentSelectedDate: Date?
    var todayDaySelection: String?
    var selctedMonthDate = Date()
    
    // MARK: - Events
    var events = [Event]() {
        didSet {
            calendarView.reloadData()
        }
    }
    var selectDate = Date()
    var style: Style {
        createCalendarStyle()
    }
    var eventViewer = EventViewer()
    
    
    
    private var calendarView: KVKCalendarView!
    //= {
    //        //var frame = self.calendarView1.frame
    //        //frame.origin.y = 0
    //        var frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 37, height: 400)
    //        let calendar = KVKCalendarView(frame: frame, date: selectDate, style: style)
    //        calendar.delegate = self
    //        calendar.dataSource = self
    //        return calendar
    //    }()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        selectDate = defaultDate
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Controller Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //        self.calendarView1.backgroundColor = .systemBackground
        //        //view.backgroundColor = .systemBackground
        //
        //        self.calendarView1.addSubview(calendarView)
        //
        //        calendarView.delegate = self
        //        calendarView.dataSource = self
        
        DispatchQueue.main.async {
            self.manageCalenderType(type: .month)
            
        }
        
        showCurrentDate(selectDate)
        
        
        loadEvents(dateFormat: style.timeSystem.format) { (events) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.events = events
            }
        }
        setupCalender()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 37, height: 400)
//        calendarView.reloadFrame(frame)
    }
    
    func setupCalender() {
        
        if let calendarView {
            calendarView.removeFromSuperview()
        }
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 37, height: 400)
        let calendar = KVKCalendarView(frame: frame, date: selectDate, style: style)
        calendar.delegate = self
        calendar.dataSource = self
        self.calendarView = calendar
        
        self.calendarView1.backgroundColor = .systemBackground
        //view.backgroundColor = .systemBackground
        
        self.calendarView1.addSubview(calendarView)
        
        calendarView.delegate = self
        calendarView.dataSource = self
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // to track changing windows and theme of device
        
        loadEvents(dateFormat: style.timeSystem.format) { [weak self] (events) in
            if let style = self?.style {
                self?.calendarView.updateStyle(style)
            }
            self?.events = events
        }
    }
    
    // MARK: - Cretaed Instnace Method Of RelaodCalenderStyle
    private func reloadCalendarStyle() {
        var updatedStyle = calendarView.style
        updatedStyle.timeSystem = calendarView.style.timeSystem == .twentyFour ? .twelve : .twentyFour
        calendarView.updateStyle(updatedStyle)
        calendarView.reloadData()
    }
    
    // MARK:  - Today Selction Method
    
    private func showTodayEvents() {
        selectDate = Date()
        calendarView.scrollTo(selectDate, animated: true)
        let  formattedDateStr = "\(selectDate)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        guard let formattedDate  =  dateFormatter.date(from: formattedDateStr) else { return }
        dateFormatter.dateFormat = "EEEE"
        let dateString12  =  dateFormatter.string(from: formattedDate)
        todayDaySelection = dateString12
        calendarView.reloadData()
    }
    
    // MARK: - Created Method on Selected Date
    
    func showCurrentDate(_ date: Date) {
        let  formattedDateStr = "\(date)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        guard let formattedDate  =  dateFormatter.date(from: formattedDateStr) else { return }
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let dateString12  =  dateFormatter.string(from: formattedDate)
        showSelectedDateLabel.text = dateString12
        
    }
    
    
    func monthPreviousAndNextDate() {
        let  formattedDateStr = "\(selctedMonthDate)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        guard let formattedDate  =  dateFormatter.date(from: formattedDateStr) else { return }
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let dateString12  =  dateFormatter.string(from: formattedDate)
        showSelectedDateLabel.text = dateString12
    }
    
    
    // MARK: - IBAction Methods
    
    @IBAction func backwordButtonAction(_ sender: UIButton) {
        
        monthDateForwordAndBackWord(type: .back)
        
    }
    
    @IBAction func forwordButtonAction(_ sender: UIButton) {
    
        monthDateForwordAndBackWord(type: .forward)
    }
    
    // MARK: - Created Manage ArrowButton Method
    
    private func monthDateForwordAndBackWord(type: ArrowAction) {
        
        switch type {
            
        case .back:
            
            switch selectedCalenderType {
                
            case .today:
                calendarView.dayView.previousDate()
                calendarView.dayView.timelinePage.changePage(.previous)
                calendarView.reloadData()
                
                let  formattedDateStr = "\(calendarView.dayView.dayViewPreviousDate ?? Date())"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
                guard let formattedDate  =  dateFormatter.date(from: formattedDateStr) else { return }
                dateFormatter.dateFormat = "dd MMM, yyyy"
                let previousTodayDate  =  dateFormatter.string(from: formattedDate)
                showSelectedDateLabel.text = previousTodayDate
                print("Previous Today")
                
            case .week:
                calendarView.weekView.previousDate()
                calendarView.weekView.timelinePage.changePage(.previous)
                calendarView.reloadData()
                
                let  formattedDateStr = "\(calendarView.weekView.weekViewPreviousDate ?? Date())"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
                guard let formattedDate  =  dateFormatter.date(from: formattedDateStr) else { return }
                dateFormatter.dateFormat = "dd MMM, yyyy"
                let previousWeekDate  =  dateFormatter.string(from: formattedDate)
                showSelectedDateLabel.text = previousWeekDate
                print("Previous Week")
                
            case .month:
                
                selctedMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: selctedMonthDate) ?? Date()
                self.calendarView.monthView.setDate(selctedMonthDate, animated: true)
                calendarView.style.month.isPagingEnabled = true
                monthPreviousAndNextDate()
                reloadCalendarStyle()
                calendarView.reloadData()
                print("Previous Month")
            }
            
        case .forward:
            
            switch selectedCalenderType {
                
            case .today:
                calendarView.dayView.nextDate()
                calendarView.dayView.timelinePage.changePage(.next)
                calendarView.reloadData()
                
                let  formattedDateStr = "\(calendarView.dayView.dayViewNextDate ?? Date())"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
                guard let formattedDate  =  dateFormatter.date(from: formattedDateStr) else { return }
                dateFormatter.dateFormat = "dd MMM, yyyy"
                let todayNextDate  =  dateFormatter.string(from: formattedDate)
                showSelectedDateLabel.text = todayNextDate
                print("Next Today")
                
            case .week:
                
                calendarView.weekView.nextDate()
                calendarView.weekView.timelinePage.changePage(.next)
                calendarView.reloadData()
                
                let  formattedDateStr = "\(calendarView.weekView.weekViewNextDate ?? Date())"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
                guard let formattedDate  =  dateFormatter.date(from: formattedDateStr) else { return }
                dateFormatter.dateFormat = "dd MMM, yyyy"
                let nextWeekDate  =  dateFormatter.string(from: formattedDate)
                showSelectedDateLabel.text = nextWeekDate
                print("Next Week")
                
            case .month:
                selctedMonthDate = Calendar.current.date(byAdding: .month, value: 1, to: selctedMonthDate) ?? Date()
                self.calendarView.monthView.setDate(selctedMonthDate, animated: true)
                calendarView.style.month.isPagingEnabled = true
                reloadCalendarStyle()
                monthPreviousAndNextDate()
                calendarView.reloadData()
                print("Next Month")
                
            }
        }
    }
    
    
    //MARK: - Calender Type Button IBAction Methods
    
    @IBAction func todayButtonAction(_ sender: UIButton) {
        
        manageCalenderType(type: .today)
    }
    
    @IBAction func weekButtonAction(_ sender: UIButton) {
        manageCalenderType(type: .week)
    }
    
    @IBAction func monthButtonAction(_ sender: UIButton) {
        manageCalenderType(type: .month)
    }
    
    
    // MARK: - Created Manged CalenderType Method
    private func manageCalenderType(type: VidhikCalendaType) {
        
        self.selectedCalenderType = type
        
        switch type {
            
        case .today:
            
            todayButton.setTitleColor(.blue, for: .normal)
            weekButton.setTitleColor(.gray, for: .normal)
            monthButton.setTitleColor(.gray, for: .normal)
            
            todayView.backgroundColor = .blue
            weekView.backgroundColor = .clear
            monthView.backgroundColor = .clear
            setupCalender()
            self.calendarView.set(type: .day, date: self.selectDate)
            
            showTodayEvents()
            showCurrentDate(selectDate)
            calendarView.reloadData()
            
            
        case .week:
            
            todayButton.setTitleColor(.gray, for: .normal)
            weekButton.setTitleColor(.blue, for: .normal)
            monthButton.setTitleColor(.gray, for: .normal)
            
            todayView.backgroundColor = .clear
            weekView.backgroundColor = .blue
            monthView.backgroundColor = .clear
            
            setupCalender()
            showCurrentDate(selectDate)
            self.calendarView.set(type: .week, date: self.selectDate)
            self.calendarView.reloadData()
            
        case .month:
            
            todayButton.setTitleColor(.gray, for: .normal)
            weekButton.setTitleColor(.gray, for: .normal)
            monthButton.setTitleColor(.blue, for: .normal)
            
            todayView.backgroundColor = .clear
            weekView.backgroundColor = .clear
            monthView.backgroundColor = .blue
            
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                
                self.calendarView.reloadData()
            })
            self.setupCalender()
            self.calendarView.set(type: .month, date: self.selectDate)
            self.calendarView.scrollTo(self.selectDate, animated: true)
            
            reloadCalendarStyle()
            showCurrentDate(selectDate)
            
            
        }
        
    }
    
    func createCalendarStyle() -> Style {
        var style = Style()
        style.timeline.isHiddenStubEvent = false
        style.startWeekDay = .monday
        style.systemCalendars = ["Calendar1", "Calendar2", "Calendar3"]
        
        style.event.iconFile = UIImage(systemName: "paperclip")
        style.timeline.scrollLineHourMode = .always//.onlyOnInitForDate(defaultDate)
       
        style.month.autoSelectionDateWhenScrolling = true
        style.timeline.useDefaultCorderHeader = true
        style.timeline.timeColor = .black
        style.timeline.backgroundColor = .clear
        
        //Show current time line
        style.timeline.currentLineHourColor = .cyan
        style.timeline.showLineHourMode = .never
        
        
        style.headerScroll.colorBackgroundCurrentDate = .blue
        
        style.headerScroll.colorWeekendDate = .black
        style.headerScroll.colorBackground = .clear
        style.headerScroll.fontNameDay = UIFont(name: "Poppins-Regular", size: 12.0) ?? UIFont()
        style.headerScroll.fontDate =  UIFont(name: "Poppins-Medium", size: 12.0) ?? UIFont()
        
        switch selectedCalenderType {
            
        case .today:
            style.headerScroll.heightHeaderWeek = 0
            style.headerScroll.heightSubviewHeader = 40
            style.headerScroll.titleDateFont = UIFont(name: "Poppins-Regular", size: 15.0) ?? UIFont()
            
        case .week:
            style.headerScroll.heightHeaderWeek = 70
            style.headerScroll.heightSubviewHeader = 0
            
        case .month:
            style.headerScroll.heightHeaderWeek = 0
            style.headerScroll.heightSubviewHeader = 0
            
        }
        
        
        style.month.heightHeaderWeek = 30
        style.month.isHiddenTitleHeader = false
        style.month.isHiddenSectionHeader = true
        style.month.colorBackgroundCurrentDate = .blue
        style.month.colorWeekendDate = .black
        // style.month.scrollDirection = .horizontal
        style.month.fontNameDate = UIFont(name: "Poppins-Regular", size: 15.0) ?? UIFont()
        
        return style
    }
    
    
}


// MARK: - Calendar datasource

extension ViewController: CalendarDataSource {
    
    func willSelectDate(_ date: Date, type: CalendarType) {
        print(date, type)
    }
    
    
    func eventsForCalendar(systemEvents: [EKEvent]) -> [Event] {
        // if you want to get a system events, you need to set style.systemCalendars = ["test"]
        handleEvents(systemEvents: systemEvents)
    }
    
    func willDisplayEventView(_ event: Event, frame: CGRect, date: Date?) -> EventViewGeneral? {
        
        handleCustomEventView(event: event, style: style, frame: frame)
        
    }
    
    func willDisplayEventViewer(date: Date, frame: CGRect) -> UIView? {
        eventViewer.frame = frame
        return eventViewer
    }
    
    func sizeForCell(_ date: Date?, type: CalendarType) -> CGSize? {
        
        handleSizeCell(type: type, stye: calendarView.style, view: view)
    }
    
    
}
// MARK: - Calendar delegate

extension ViewController: CalendarDelegate {
    func didChangeEvent(_ event: Event, start: Date?, end: Date?) {
        if let result = handleChangingEvent(event, start: start, end: end) {
            events.replaceSubrange(result.range, with: result.events)
        }
    }
    
    func didSelectDates(_ dates: [Date], type: CalendarType, frame: CGRect?) {
        selectDate = dates.first ?? Date()
        showCurrentDate(selectDate)
        currentSelectedDate = selectDate
        calendarView.reloadData()
    }
    
    func didSelectEvent(_ event: Event, type: CalendarType, frame: CGRect?) {
        print(type, event)
        
        switch type {
            
        case .day:
            eventViewer.text = event.title.timeline
            
        default:
            break
        }
    }
    
    
    func didDeselectEvent(_ event: Event, animated: Bool) {
        print(event)
    }
    
    func didSelectMore(_ date: Date, frame: CGRect?) {
        print(date)
    }
    
    func didChangeViewerFrame(_ frame: CGRect) {
        eventViewer.reloadFrame(frame: frame)
    }
    
    func didAddNewEvent(_ event: Event, _ date: Date?) {
        if let newEvent = handleNewEvent(event, date: date) {
            events.append(newEvent)
        }
    }
}

