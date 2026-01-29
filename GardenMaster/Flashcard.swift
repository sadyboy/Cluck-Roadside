import Foundation

struct Flashcard: Identifiable, Codable {
    var id: String
    var term: String
    var definition: String
    var category: String
    var icon: String
}
