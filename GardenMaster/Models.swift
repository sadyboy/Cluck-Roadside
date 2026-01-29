import Foundation

struct User: Codable {
    var id: UUID = UUID()
    var name: String = "Gardener"
    var profileImageData: Data?
    var totalXP: Int = 0
    var currentStreak: Int = 0
    var lastActiveDate: Date = Date()
    var completedLessons: Set<String> = []
    var completedTests: Set<String> = []
    var masteredFlashcards: Set<String> = []
    var viewedExperts: Set<String> = []
    var unlockedAchievements: Set<String> = []
    var testAttempts: [TestAttempt] = []
    
    var level: Int {
        return (totalXP / 100) + 1
    }
    
    var progressToNextLevel: Double {
        let currentLevelXP = (level - 1) * 100
        let nextLevelXP = level * 100
        let progress = Double(totalXP - currentLevelXP) / Double(nextLevelXP - currentLevelXP)
        return min(max(progress, 0), 1)
    }
}

struct TestAttempt: Codable, Identifiable {
    var id: UUID = UUID()
    var testId: String
    var score: Int
    var totalQuestions: Int
    var date: Date
    var passed: Bool
}
