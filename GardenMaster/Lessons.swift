
import Foundation

struct Lesson: Identifiable, Codable {
    var id: String
    var title: String
    var icon: String
    var difficulty: Difficulty
    var xpReward: Int
    var estimatedTime: String
    var contentBlocks: [ContentBlock]
    
    enum Difficulty: String, Codable {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
    }
}

struct ContentBlock: Identifiable, Codable {
    var id: String
    var type: BlockType
    var content: String
    
    enum BlockType: String, Codable {
        case heading
        case text
        case fact
        case formula
    }
}
