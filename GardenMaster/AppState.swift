import Foundation
import Combine

class AppState: ObservableObject {
    @Published var user: User {
        didSet {
            UserDefaultsManager.shared.saveUser(user)
            checkAchievements()
            updateStreak()
        }
    }
    
    @Published var achievements: [Achievement] = []
    
    init() {
        self.user = UserDefaultsManager.shared.loadUser()
        self.achievements = DataProvider.getAchievements()
        updateAchievementProgress()
        updateStreak()
    }
    
    func addXP(_ amount: Int) {
        user.totalXP += amount
    }
    
    func completeLesson(_ lessonId: String, xp: Int) {
        if !user.completedLessons.contains(lessonId) {
            user.completedLessons.insert(lessonId)
            addXP(xp)
        }
    }
    
    func masterFlashcard(_ cardId: String) {
        if !user.masteredFlashcards.contains(cardId) {
            user.masteredFlashcards.insert(cardId)
            addXP(5)
        }
    }
    
    func viewExpert(_ expertId: String) {
        if !user.viewedExperts.contains(expertId) {
            user.viewedExperts.insert(expertId)
            addXP(10)
        }
    }
    
    func submitTest(_ testId: String, score: Int, total: Int) {
        let passed = score >= 3
        let attempt = TestAttempt(testId: testId, score: score, totalQuestions: total, date: Date(), passed: passed)
        user.testAttempts.append(attempt)
        
        if !user.completedTests.contains(testId) && passed {
            user.completedTests.insert(testId)
        }
    }
    
    func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastActive = calendar.startOfDay(for: user.lastActiveDate)
        let daysDifference = calendar.dateComponents([.day], from: lastActive, to: today).day ?? 0
        
        if daysDifference == 0 {
            return
        } else if daysDifference == 1 {
            user.currentStreak += 1
            user.lastActiveDate = Date()
            addXP(10)
        } else {
            user.currentStreak = 1
            user.lastActiveDate = Date()
        }
    }
    
    func updateAchievementProgress() {
        achievements = DataProvider.getAchievements()
        
        for i in 0..<achievements.count {
            switch achievements[i].id {
            case "first_steps":
                achievements[i].progress = user.completedLessons.count
            case "scholar":
                achievements[i].progress = user.completedLessons.count
            case "master_gardener":
                achievements[i].progress = user.completedLessons.count
            case "test_taker":
                achievements[i].progress = user.completedTests.count
            case "test_master":
                achievements[i].progress = user.completedTests.count
            case "perfectionist":
                let perfectTests = user.testAttempts.filter { $0.score == $0.totalQuestions }.count
                achievements[i].progress = perfectTests
            case "rising_star":
                achievements[i].progress = user.level
            case "expert_level":
                achievements[i].progress = user.level
            case "xp_collector":
                achievements[i].progress = user.totalXP
            case "memory_master":
                achievements[i].progress = user.masteredFlashcards.count
            case "flashcard_expert":
                achievements[i].progress = user.masteredFlashcards.count
            case "consistent":
                achievements[i].progress = user.currentStreak
            case "dedicated":
                achievements[i].progress = user.currentStreak
            case "historian":
                achievements[i].progress = user.viewedExperts.count
            default:
                break
            }
            
            if achievements[i].isUnlocked && !user.unlockedAchievements.contains(achievements[i].id) {
                user.unlockedAchievements.insert(achievements[i].id)
                addXP(achievements[i].xpReward)
            }
        }
    }
    
    func checkAchievements() {
        updateAchievementProgress()
    }
}
