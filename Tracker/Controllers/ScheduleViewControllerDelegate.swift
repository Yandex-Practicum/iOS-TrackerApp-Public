import Foundation

protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectDays(_ selectedDays: [String])
}
