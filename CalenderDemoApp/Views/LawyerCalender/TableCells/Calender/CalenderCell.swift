//

//  Created by Dinesh Rajput on 06/03/24.
//

import UIKit
import EventKit


class CalenderCell: UITableViewCell, KVKCalendarSettings, KVKCalendarDataModel {
    
    // MARK: - IBOutlets Properties
    @IBOutlet weak var calenderContainerView: UIView!
    
    private var selctedMonthDate = Date()
    
    private var selectedCalenderType: VidhikCalendaType = .month
    private var arrowType: ArrowAction?
    
    var didSelectDate: ((Date) -> ())?
    
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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCalender()
        loadEvents(dateFormat: style.timeSystem.format) { (events) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.events = events
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//                let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 37, height: 400)
//                calendarView.reloadFrame(frame)
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
        self.calenderContainerView.backgroundColor = .systemBackground
        self.calenderContainerView.addSubview(calendarView)
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
extension CalenderCell: CalendarDataSource {
    
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
        handleSizeCell(type: type, stye: calendarView.style, view: self)
    }
    
}
// MARK: - Calendar delegate

extension CalenderCell: CalendarDelegate {
    func didChangeEvent(_ event: Event, start: Date?, end: Date?) {
        if let result = handleChangingEvent(event, start: start, end: end) {
            events.replaceSubrange(result.range, with: result.events)
        }
    }
    
    func didSelectDates(_ dates: [Date], type: CalendarType, frame: CGRect?) {
        selectDate = dates.first ?? Date()
        //setupDateFormate(date: selectDate)
        calendarView.reloadData()
        didSelectDate?(selectDate)
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

// MARK: - Public Methods
extension CalenderCell {
    
    func set(_ type: VidhikCalendaType) {
        self.selectedCalenderType = type
        self.manageCalenderType()
       // previousAndNextSelection(type: arrowType ?? ArrowAction)
        
    }
}

extension CalenderCell {
    
    // MARK: - Created Manged CalenderType Method
    private func manageCalenderType() {
        switch self.selectedCalenderType {
        case .today:
            setupCalender()
            self.calendarView.set(type: .day, date: self.selectDate)
            setupDateFormate(date: selectDate)
            calendarView.reloadData()
            
        case .week:
            setupCalender()
            setupDateFormate(date: selectDate)
            self.calendarView.set(type: .week, date: self.selectDate)
            self.calendarView.reloadData()
            
        case .month:
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self.calendarView.reloadData()
            })
            self.calendarView.set(type: .month, date: self.selectDate)
            self.calendarView.scrollTo(self.selectDate, animated: true)
            //self.setupCalender()
            reloadCalendarStyle()
            setupDateFormate(date: selectDate)
        }
    }
}

extension CalenderCell {
    private func setupDateFormate(date: Date) {
        let  formattedDateStr = "\(date)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        guard let formattedDate  =  dateFormatter.date(from: formattedDateStr) else { return }
        dateFormatter.dateFormat = "dd MMM, yyyy"
        _  =  dateFormatter.string(from: formattedDate)
    }
    
    private func previousAndNextSelection(type: ArrowAction) {
        switch type {
        case .back:
            
            switch selectedCalenderType {
            case .today:
                calendarView.dayView.previousDate()
                calendarView.dayView.timelinePage.changePage(.previous)
                calendarView.reloadData()
                setupDateFormate(date: calendarView.dayView.dayViewPreviousDate ?? Date())
                
            case .week:
                calendarView.weekView.previousDate()
                calendarView.weekView.timelinePage.changePage(.previous)
                calendarView.reloadData()
                setupDateFormate(date: calendarView.weekView.weekViewPreviousDate ?? Date())
                
            case .month:
                selctedMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: selctedMonthDate) ?? Date()
                self.calendarView.monthView.setDate(selctedMonthDate, animated: true)
                calendarView.style.month.isPagingEnabled = true
                setupDateFormate(date: selctedMonthDate)
                reloadCalendarStyle()
                calendarView.reloadData()
            }
            
        case .forward:
            switch selectedCalenderType {
            case .today:
                calendarView.dayView.nextDate()
                calendarView.dayView.timelinePage.changePage(.next)
                calendarView.reloadData()
                setupDateFormate(date: calendarView.dayView.dayViewNextDate ?? Date())
                
            case .week:
                calendarView.weekView.nextDate()
                calendarView.weekView.timelinePage.changePage(.next)
                calendarView.reloadData()
                setupDateFormate(date: calendarView.weekView.weekViewNextDate ?? Date())
                
            case .month:
                selctedMonthDate = Calendar.current.date(byAdding: .month, value: 1, to: selctedMonthDate) ?? Date()
                self.calendarView.monthView.setDate(selctedMonthDate, animated: true)
                calendarView.style.month.isPagingEnabled = true
                reloadCalendarStyle()
                setupDateFormate(date: selctedMonthDate)
                calendarView.reloadData()
            }
        }
    }
}
