import Foundation

struct Test: Identifiable, Codable {
    var id: String
    var title: String
    var category: String
    var icon: String
    var questions: [Question]
    var passingScore: Int
}

struct Question: Identifiable, Codable {
    var id: String
    var question: String
    var options: [String]
    var correctAnswer: Int
}
