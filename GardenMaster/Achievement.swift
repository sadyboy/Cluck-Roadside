import Foundation

struct Achievement: Identifiable, Codable {
    var id: String
    var title: String
    var description: String
    var icon: String
    var rarity: Rarity
    var xpReward: Int
    var requirement: Int
    var progress: Int
    
    var isUnlocked: Bool {
        return progress >= requirement
    }
    
    var progressPercentage: Double {
        return min(Double(progress) / Double(requirement), 1.0)
    }
    
    enum Rarity: String, Codable {
        case common = "Common"
        case rare = "Rare"
        case epic = "Epic"
        case legendary = "Legendary"
        
        var color: String {
            switch self {
            case .common: return "gray"
            case .rare: return "blue"
            case .epic: return "purple"
            case .legendary: return "orange"
            }
        }
    }
}
