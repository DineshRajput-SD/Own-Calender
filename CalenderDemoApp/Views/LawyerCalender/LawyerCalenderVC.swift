//
//  Created by Dinesh Rajput on 06/03/24.

import UIKit

struct DateSlot {
    let date: String
    let slots: [TimeSlot]
}

struct TimeSlot {
    
}

class LawyerCalenderVC: UIViewController {
    
    enum Section {
        case calendar
        case slots([DateSlot])
        case meeting
        case availability
    }
    
    // MARK: - IBOutlets Properties
    
    @IBOutlet weak var lawyerTableView: UITableView!
    
    @IBOutlet weak var showDateLabel: UILabel!
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var monthButton: UIButton!
    
    @IBOutlet weak var todayView: UIView!
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var monthView: UIView!
    
    private var selectedEventMode: VidhikCalendaType = .month
    private var sections: [Section] = []
    private var showDate: Date?
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lawyerTableView.reloadData()
        cellsRegister()
        didSelect(eventType: .month)
        let slots = [
            DateSlot(date: "12 March 2024", slots: [TimeSlot(), TimeSlot()]),
            DateSlot(date: "13 March 2024", slots: [TimeSlot(), TimeSlot(), TimeSlot(), TimeSlot()])
        ]
        sections = [.calendar, .meeting, .availability, .slots(slots)]
    }
    
    private func cellsRegister() {
        self.lawyerTableView.register(UINib(nibName: "CalenderCell", bundle: nil), forCellReuseIdentifier: "CalenderCell")
        self.lawyerTableView.register(UINib(nibName: "MeetingWithClientCell", bundle: nil), forCellReuseIdentifier: "MeetingWithClientCell")
        self.lawyerTableView.register(UINib(nibName: "AvailablityCell", bundle: nil), forCellReuseIdentifier: "AvailablityCell")
        self.lawyerTableView.register(UINib(nibName: "SlotsCell", bundle: nil), forCellReuseIdentifier: "SlotsCell")
    }
    
    // MARK: -  IBAction Methods
    @IBAction func previousCalenderShowButtonAction(_ sender: UIButton) {
        print("Back Calender")
    }
    
    @IBAction func nextCalenderShowButtonAction(_ sender: UIButton) {
        print("Forword Calender")
    }
    
    @IBAction func todayButtonAction(_ sender: UIButton) {
        didSelect(eventType: .today)
    }
    
    @IBAction func weekButtonAction(_ sender: Any) {
        didSelect(eventType: .week)
    }
    
    @IBAction func monthButtonAction(_ sender: UIButton) {
        didSelect(eventType: .month)
    }
    
    private func didSelect(eventType: VidhikCalendaType) {
        selectedEventMode = eventType
        
        // Reset state
        [todayButton, weekButton, monthButton].forEach { button in
            button?.setTitleColor(.gray, for: .normal)
        }
        
        [todayView, weekView, monthView].forEach { eventView in
            eventView.backgroundColor = .clear
        }
        
        switch eventType {
        case .today:
            //showDateLabel.text = "\(showDate)"
            todayButton.setTitleColor(.blue, for: .normal)
            todayView.backgroundColor = .blue
            
        case .month:
            monthButton.setTitleColor(.blue, for: .normal)
            monthView.backgroundColor = .blue
            
        case .week:
            weekButton.setTitleColor(.blue, for: .normal)
            weekView.backgroundColor = .blue
        }
        lawyerTableView.reloadData()
    }
    
    private func clickPreviousAndNext(arrowType: ArrowAction) {
        switch arrowType {
        case .back:
            break
        case .forward:
            break
        }
    }
    
    @IBAction func newEventButtonAction(_ sender: UIButton) {
        print("Add new event")
    }
    
    @IBAction func filterAllEventButtonAction(_ sender: UIButton) {
        print("Filter All Event")
    }
    
}

// MARK: -  UITableView DataSource Methods
extension LawyerCalenderVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .calendar:
            return 1
            
        case .meeting:
            return 3
            
        case .availability:
            return 1
            
        case .slots(let slots):
            return slots.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .calendar:
            guard let calenderCell = tableView.dequeueReusableCell(withIdentifier: "CalenderCell", for: indexPath) as? CalenderCell else {
                return UITableViewCell()
            }
            calenderCell.set(self.selectedEventMode)
            calenderCell.didSelectDate = { [weak self] selectedDate in
                print(selectedDate)
            }
            
            return calenderCell
            
        case .meeting:
            guard let meetingWithClientCell = tableView.dequeueReusableCell(withIdentifier: "MeetingWithClientCell", for: indexPath) as? MeetingWithClientCell else {
                return MeetingWithClientCell()
            }
            meetingWithClientCell.threeDotCallback = {
                print("Three Dot Button Click")
            }
            return meetingWithClientCell
            
        case .availability:
            guard let availiablityCell = tableView.dequeueReusableCell(withIdentifier: "AvailablityCell", for: indexPath) as? AvailablityCell else {
                return AvailablityCell()
            }
            availiablityCell.addAvailableCallback = {
                print("AddAvailableCallback")
            }
            
            availiablityCell.availableCallback = {
                print("AvailableCallback")
            }
            return availiablityCell
            
        case .slots(let slots):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SlotsCell", for: indexPath) as? SlotsCell else {
                return SlotsCell()
            }
            cell.set(dateSlot: slots[indexPath.row])
            cell.slotCollectionView.reloadData()
            return cell
        }
    }
}

//MARK: - UITableViewDelegate Methods
extension LawyerCalenderVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section] {
        case .slots(let slots):
            let _slots = slots[indexPath.row].slots
            var height: Int = 80 // Header height
            height += (_slots.count / 3) * 50
            
            if (_slots.count % 3) > 0 {
                height += 50
            }
            
            return CGFloat(height)
            
        default:
            return UITableView.automaticDimension
        }
    }
}
