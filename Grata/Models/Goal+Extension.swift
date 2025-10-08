
import Foundation

extension Goal {
  var currentDay: Int {
    let days = Calendar.current.dateComponents(
      [.day],
      from: dateCreated ?? Date(),
      to: Date()
    ).day ?? 0
    return days + 1
  }
}
