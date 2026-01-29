import Foundation

struct Expert: Identifiable, Codable {
    var id: String
    var name: String
    var yearBorn: String
    var yearDied: String?
    var biography: String
    var contributions: [String]
    var discoveries: [Discovery]
    var quote: String
    var icon: String
}

struct Discovery: Identifiable, Codable {
    var id: String
    var title: String
    var year: String
    var description: String
}
