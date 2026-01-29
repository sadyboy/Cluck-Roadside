import SwiftUI

struct ProgressStatsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var selectedPeriod: TimePeriod = .week
    
    enum TimePeriod: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case all = "All Time"
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                StatsHeader(dismiss: dismiss)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        PeriodSelector(selectedPeriod: $selectedPeriod)
                        
                        OverallStatsCards()
                        
                        XPProgressSection()
                        
                        ActivityBreakdownCircle()
                        
                        TestPerformanceSection()
                        
                        StreakCalendarSection()
                        
                        MilestonesSection()
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
            }
        }
    }
}

struct StatsHeader: View {
    let dismiss: DismissAction
    
    var body: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(AppColors.cardBackground))
            }
            
            Spacer()
            
            Text("Your Statistics")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

struct PeriodSelector: View {
    @Binding var selectedPeriod: ProgressStatsView.TimePeriod
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(ProgressStatsView.TimePeriod.allCases, id: \.self) { period in
                Button(action: {
                    withAnimation(.spring()) {
                        selectedPeriod = period
                    }
                }) {
                    Text(period.rawValue)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(selectedPeriod == period ? .white : .white.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(selectedPeriod == period ? AppColors.primaryGradient : LinearGradient(colors: [AppColors.cardBackground], startPoint: .leading, endPoint: .trailing))
                        )
                }
            }
        }
    }
}

struct OverallStatsCards: View {
    @EnvironmentObject var appState: AppState
    
    var completionRate: Int {
        let totalLessons = DataProvider.getLessons().count
        let completed = appState.user.completedLessons.count
        return totalLessons > 0 ? Int((Double(completed) / Double(totalLessons)) * 100) : 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Overview")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                MiniStatCard(
                    icon: "target",
                    value: "\(completionRate)%",
                    label: "Completion",
                    color: AppColors.primaryGreen
                )
                
                MiniStatCard(
                    icon: "chart.line.uptrend.xyaxis",
                    value: "\(appState.user.totalXP)",
                    label: "Total XP",
                    color: AppColors.accentGold
                )
                
                MiniStatCard(
                    icon: "flame.fill",
                    value: "\(appState.user.currentStreak)",
                    label: "Day Streak",
                    color: .orange
                )
                
                MiniStatCard(
                    icon: "trophy.fill",
                    value: "\(appState.achievements.filter { $0.isUnlocked }.count)",
                    label: "Achievements",
                    color: AppColors.accentBlue
                )
            }
        }
    }
}

struct MiniStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 26))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
        )
    }
}

struct XPProgressSection: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("XP Progress")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Earned")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("\(appState.user.totalXP) XP")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(AppColors.primaryGradient)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Current Level")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("Level \(appState.user.level)")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(AppColors.successGradient)
                    }
                }
                
                SimpleBarChart()
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.cardBackground)
            )
        }
    }
}

struct SimpleBarChart: View {
    let data = [45, 60, 30, 75, 50, 90, 65]
    let maxValue: CGFloat = 100
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(0..<data.count, id: \.self) { index in
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(AppColors.primaryGradient)
                        .frame(height: CGFloat(data[index]) * 1.5)
                    
                    Text("D\(index + 1)")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 160)
    }
}

struct ActivityBreakdownCircle: View {
    @EnvironmentObject var appState: AppState
    
    var activities: [(String, Int, Color)] {
        [
            ("Lessons", appState.user.completedLessons.count, AppColors.primaryGreen),
            ("Tests", appState.user.completedTests.count, AppColors.accentBlue),
            ("Flashcards", appState.user.masteredFlashcards.count, AppColors.accentGold),
            ("Experts", appState.user.viewedExperts.count, AppColors.secondaryBrown)
        ]
    }
    
    var total: Int {
        max(activities.reduce(0) { $0 + $1.1 }, 1)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Activity Breakdown")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 30)
                        .frame(width: 180, height: 180)
                    
                    ForEach(Array(activities.enumerated()), id: \.offset) { index, activity in
                        let startAngle = calculateStartAngle(for: index)
                        let endAngle = calculateEndAngle(for: index)
                        
                        Circle()
                            .trim(from: startAngle, to: endAngle)
                            .stroke(activity.2, style: StrokeStyle(lineWidth: 30, lineCap: .round))
                            .frame(width: 180, height: 180)
                            .rotationEffect(.degrees(-90))
                    }
                    
                    VStack(spacing: 4) {
                        Text("\(total)")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Activities")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                
                VStack(spacing: 8) {
                    ForEach(activities, id: \.0) { activity in
                        HStack {
                            Circle()
                                .fill(activity.2)
                                .frame(width: 12, height: 12)
                            
                            Text(activity.0)
                                .font(.system(size: 15))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("\(activity.1)")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("(\(Int((Double(activity.1) / Double(total)) * 100))%)")
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.cardBackground)
            )
        }
    }
    
    func calculateStartAngle(for index: Int) -> CGFloat {
        let previousTotal = activities.prefix(index).reduce(0) { $0 + $1.1 }
        return CGFloat(previousTotal) / CGFloat(total)
    }
    
    func calculateEndAngle(for index: Int) -> CGFloat {
        let currentTotal = activities.prefix(index + 1).reduce(0) { $0 + $1.1 }
        return CGFloat(currentTotal) / CGFloat(total)
    }
}

struct TestPerformanceSection: View {
    @EnvironmentObject var appState: AppState
    
    var testScores: [(String, Double)] {
        let attempts = appState.user.testAttempts.suffix(5)
        return attempts.map { attempt in
            let testName = DataProvider.getTests().first { $0.id == attempt.testId }?.title ?? "Test"
            let score = Double(attempt.score) / Double(attempt.totalQuestions)
            return (testName, score)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Test Scores")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            if testScores.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "chart.bar.xaxis")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.3))
                    
                    Text("No test attempts yet")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.6))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColors.cardBackground)
                )
            } else {
                VStack(spacing: 12) {
                    ForEach(testScores, id: \.0) { test in
                        HStack {
                            Text(test.0)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .frame(width: 120, alignment: .leading)
                            
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.white.opacity(0.1))
                                    
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(test.1 >= 0.6 ? AppColors.primaryGradient : LinearGradient(colors: [.orange], startPoint: .leading, endPoint: .trailing))
                                        .frame(width: geometry.size.width * test.1)
                                }
                            }
                            .frame(height: 10)
                            
                            Text("\(Int(test.1 * 100))%")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 50, alignment: .trailing)
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColors.cardBackground)
                )
            }
        }
    }
}

struct StreakCalendarSection: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Streak Calendar")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.accentGold)
                    
                    Text("\(appState.user.currentStreak) day streak")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 8) {
                    ForEach(0..<28) { day in
                        RoundedRectangle(cornerRadius: 6)
                            .fill(day < appState.user.currentStreak ? AppColors.primaryGreen : Color.white.opacity(0.1))
                            .frame(height: 40)
                            .overlay(
                                Text("\(day + 1)")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(day < appState.user.currentStreak ? .white : .white.opacity(0.4))
                            )
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.cardBackground)
            )
        }
    }
}

struct MilestonesSection: View {
    @EnvironmentObject var appState: AppState
    
    var milestones: [(String, String, Bool, Color)] {
        [
            ("First Lesson", "Complete your first lesson", appState.user.completedLessons.count >= 1, AppColors.primaryGreen),
            ("5 Lessons", "Complete 5 lessons", appState.user.completedLessons.count >= 5, AppColors.accentBlue),
            ("First Test", "Pass your first test", appState.user.completedTests.count >= 1, AppColors.accentGold),
            ("Level 5", "Reach level 5", appState.user.level >= 5, .purple),
            ("10 Flashcards", "Master 10 flashcards", appState.user.masteredFlashcards.count >= 10, .orange)
        ]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Milestones")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                ForEach(milestones, id: \.0) { milestone in
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(milestone.2 ? milestone.3 : Color.white.opacity(0.1))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: milestone.2 ? "checkmark" : "lock.fill")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(milestone.0)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text(milestone.1)
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        
                        Spacer()
                        
                        if milestone.2 {
                            Image(systemName: "star.fill")
                                .font(.system(size: 20))
                                .foregroundColor(milestone.3)
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(milestone.2 ? milestone.3.opacity(0.15) : AppColors.cardBackground)
                    )
                }
            }
        }
    }
}
