import SwiftUI

struct QuizHubView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTest: Test? = nil
    @State private var showTestView = false
    
    let allTests = DataProvider.getTests()
    
    var passedTests: Int {
        appState.user.completedTests.count
    }
    
    var totalAttempts: Int {
        appState.user.testAttempts.count
    }
    
    var averageScore: Double {
        guard !appState.user.testAttempts.isEmpty else { return 0 }
        let total = appState.user.testAttempts.reduce(0.0) { $0 + (Double($1.score) / Double($1.totalQuestions)) }
        return total / Double(appState.user.testAttempts.count)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        QuizHeader()
                        
                        StatsOverview(
                            passedTests: passedTests,
                            totalAttempts: totalAttempts,
                            averageScore: averageScore
                        )
                        
                        TestsList(tests: allTests, onTestSelect: { test in
                            selectedTest = test
                            showTestView = true
                        })
                        
                        RecentAttemptsSection()
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showTestView) {
                if let test = selectedTest {
                    TestTakingView(test: test)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct QuizHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Quiz Hub")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
            
            Text("Test your knowledge and track progress")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct StatsOverview: View {
    let passedTests: Int
    let totalAttempts: Int
    let averageScore: Double
    
    var body: some View {
        HStack(spacing: 12) {
            OverviewCard(
                icon: "checkmark.seal.fill",
                value: "\(passedTests)",
                label: "Passed",
                color: .green
            )
            
            OverviewCard(
                icon: "list.bullet.clipboard.fill",
                value: "\(totalAttempts)",
                label: "Attempts",
                color: AppColors.accentBlue
            )
            
            OverviewCard(
                icon: "percent",
                value: "\(Int(averageScore * 100))%",
                label: "Avg Score",
                color: AppColors.accentGold
            )
        }
    }
}

struct OverviewCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 12, weight: .medium))
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

struct TestsList: View {
    let tests: [Test]
    let onTestSelect: (Test) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Available Tests")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            ForEach(tests) { test in
                TestCard(test: test, onTap: { onTestSelect(test) })
            }
        }
    }
}

struct TestCard: View {
    @EnvironmentObject var appState: AppState
    let test: Test
    let onTap: () -> Void
    
    var isPassed: Bool {
        appState.user.completedTests.contains(test.id)
    }
    
    var attemptCount: Int {
        appState.user.testAttempts.filter { $0.testId == test.id }.count
    }
    
    var bestScore: Int? {
        let attempts = appState.user.testAttempts.filter { $0.testId == test.id }
        return attempts.map { $0.score }.max()
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.cosmicGradient)
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: test.icon)
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                    
                    if isPassed {
                        Circle()
                            .fill(.green)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            )
                            .offset(x: 26, y: -26)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(test.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(test.category)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                    
                    HStack(spacing: 16) {
                        Label("\(test.questions.count) questions", systemImage: "questionmark.circle")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.7))
                        
                        if let score = bestScore {
                            Label("Best: \(score)/\(test.questions.count)", systemImage: "star.fill")
                                .font(.system(size: 13))
                                .foregroundColor(AppColors.accentGold)
                        }
                    }
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(AppColors.primaryGreen)
                    
                    if attemptCount > 0 {
                        Text("\(attemptCount)×")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.cardBackground)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct RecentAttemptsSection: View {
    @EnvironmentObject var appState: AppState
    
    var recentAttempts: [TestAttempt] {
        Array(appState.user.testAttempts.sorted { $0.date > $1.date }.prefix(5))
    }
    
    var body: some View {
        if !recentAttempts.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                Text("Recent Attempts")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                ForEach(recentAttempts) { attempt in
                    AttemptRow(attempt: attempt)
                }
            }
        }
    }
}

struct AttemptRow: View {
    let attempt: TestAttempt
    
    var testTitle: String {
        DataProvider.getTests().first { $0.id == attempt.testId }?.title ?? "Unknown Test"
    }
    
    var scorePercentage: Double {
        Double(attempt.score) / Double(attempt.totalQuestions)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 4)
                    .frame(width: 50, height: 50)
                
                Circle()
                    .trim(from: 0, to: scorePercentage)
                    .stroke(attempt.passed ? Color.green : Color.orange, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(scorePercentage * 100))%")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(testTitle)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("\(attempt.score)/\(attempt.totalQuestions) correct")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.6))
                
                Text(attempt.date, style: .relative)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.5))
            }
            
            Spacer()
            
            Image(systemName: attempt.passed ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(attempt.passed ? .green : .orange)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
        )
    }
}
