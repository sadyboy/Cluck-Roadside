import SwiftUI

struct GardenHomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showSimulations = false
    @State private var showHistory = false
    @State private var showStats = false
    @State private var showAchievements = false
    @State private var animateGradient = false
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView(animate: $animateGradient)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    WelcomeHeader()
                    
                    XPLevelCard()
                    
                    DailyStreakBanner()
                    
                    QuickAccessGrid(
                        showSimulations: $showSimulations,
                        showHistory: $showHistory,
                        showStats: $showStats,
                        showAchievements: $showAchievements
                    )
                    
                    ProgressSnapshot()
                    
                    FeaturedLessons()
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
            }
        }
        .fullScreenCover(isPresented: $showSimulations) {
            InteractiveSimulationsView()
        }
        .fullScreenCover(isPresented: $showHistory) {
            ExpertHistoryView()
        }
        .fullScreenCover(isPresented: $showStats) {
            ProgressStatsView()
        }
        .fullScreenCover(isPresented: $showAchievements) {
            BadgeCollectionView()
        }
        .onAppear {
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: true)) {
                animateGradient = true
            }
        }
    }
}

struct AnimatedBackgroundView: View {
    @Binding var animate: Bool
    
    var body: some View {
        ZStack {
            AppColors.background
            
            Circle()
                .fill(AppColors.primaryGreen.opacity(0.15))
                .frame(width: 300, height: 300)
                .blur(radius: 100)
                .offset(x: animate ? 100 : -100, y: animate ? -100 : 100)
            
            Circle()
                .fill(AppColors.accentGold.opacity(0.1))
                .frame(width: 250, height: 250)
                .blur(radius: 80)
                .offset(x: animate ? -120 : 120, y: animate ? 150 : -150)
        }
    }
}

struct WelcomeHeader: View {
    @EnvironmentObject var appState: AppState
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        default: return "Good Evening"
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(greeting)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                
                Text(appState.user.name)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
            
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.primaryGradient)
                    .frame(width: 70, height: 70)
                    .shadow(color: AppColors.primaryGreen.opacity(0.6), radius: 15)
                
                if let imageData = appState.user.profileImageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 66, height: 66)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct XPLevelCard: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.2, green: 0.8, blue: 0.4).opacity(0.8),
                                Color(red: 0.15, green: 0.6, blue: 0.35).opacity(0.6)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "star.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                            
                            Text("Level \(appState.user.level)")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Text("\(appState.user.totalXP) Total XP")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Next Level")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Spacer()
                                
                                Text("\(Int(appState.user.progressToNextLevel * 100))%")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(Color.white.opacity(0.3))
                                    
                                    Capsule()
                                        .fill(Color.white)
                                        .frame(width: geometry.size.width * appState.user.progressToNextLevel)
                                }
                            }
                            .frame(height: 8)
                        }
                    }
                    
                    Spacer()
                }
                .padding(24)
            }
            .frame(height: 180)
        }
    }
}

struct DailyStreakBanner: View {
    @EnvironmentObject var appState: AppState
    @State private var flameScale = 1.0
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "flame.fill")
                .font(.system(size: 36))
                .foregroundColor(AppColors.accentGold)
                .scaleEffect(flameScale)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                        flameScale = 1.2
                    }
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(appState.user.currentStreak) Day Streak!")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Keep it going! +10 XP daily")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 32))
                .foregroundColor(.green)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppColors.accentGold.opacity(0.3), lineWidth: 2)
                )
        )
    }
}

struct QuickAccessGrid: View {
    @Binding var showSimulations: Bool
    @Binding var showHistory: Bool
    @Binding var showStats: Bool
    @Binding var showAchievements: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Access")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                QuickAccessCard(
                    icon: "flask.fill",
                    title: "Simulations",
                    subtitle: "4 interactive",
                    gradient: AppColors.cosmicGradient,
                    action: { showSimulations = true }
                )
                
                QuickAccessCard(
                    icon: "book.closed.fill",
                    title: "History",
                    subtitle: "Experts & Timeline",
                    gradient: AppColors.secondaryGradient,
                    action: { showHistory = true }
                )
                
                QuickAccessCard(
                    icon: "chart.xyaxis.line",
                    title: "Statistics",
                    subtitle: "Your progress",
                    gradient: AppColors.successGradient,
                    action: { showStats = true }
                )
                
                QuickAccessCard(
                    icon: "trophy.fill",
                    title: "Achievements",
                    subtitle: "14 badges",
                    gradient: AppColors.primaryGradient,
                    action: { showAchievements = true }
                )
            }
        }
    }
}

struct QuickAccessCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let gradient: LinearGradient
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: icon)
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(18)
            .frame(height: 140)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(gradient)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
        )
    }
}

struct ProgressSnapshot: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today's Progress")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                ProgressMiniCard(
                    icon: "book.fill",
                    value: "\(appState.user.completedLessons.count)",
                    total: "\(DataProvider.getLessons().count)",
                    label: "Lessons",
                    color: AppColors.primaryGreen
                )
                
                ProgressMiniCard(
                    icon: "brain.head.profile",
                    value: "\(appState.user.completedTests.count)",
                    total: "\(DataProvider.getTests().count)",
                    label: "Tests",
                    color: AppColors.accentBlue
                )
                
                ProgressMiniCard(
                    icon: "square.stack.3d.up.fill",
                    value: "\(appState.user.masteredFlashcards.count)",
                    total: "\(DataProvider.getFlashcards().count)",
                    label: "Cards",
                    color: AppColors.accentGold
                )
            }
        }
    }
}

struct ProgressMiniCard: View {
    let icon: String
    let value: String
    let total: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            HStack(spacing: 2) {
                Text(value)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                Text("/\(total)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
            
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
        )
    }
}

struct FeaturedLessons: View {
    let lessons = DataProvider.getLessons().prefix(3)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Continue Learning")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                NavigationLink(destination: EducationView()) {
                    HStack(spacing: 4) {
                        Text("See All")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(AppColors.primaryGreen)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(AppColors.primaryGreen)
                    }
                }
            }
            
            VStack(spacing: 12) {
                ForEach(Array(lessons), id: \.id) { lesson in
                    NavigationLink(destination: LessonDetailView(lesson: lesson)) {
                        FeaturedLessonCard(lesson: lesson)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct FeaturedLessonCard: View {
    @EnvironmentObject var appState: AppState
    let lesson: Lesson
    
    var isCompleted: Bool {
        appState.user.completedLessons.contains(lesson.id)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(difficultyGradient(lesson.difficulty))
                    .frame(width: 65, height: 65)
                
                Image(systemName: lesson.icon)
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                
                if isCompleted {
                    Circle()
                        .fill(.green)
                        .frame(width: 22, height: 22)
                        .overlay(
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .offset(x: 24, y: -24)
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(lesson.title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                HStack(spacing: 12) {
                    Label(lesson.estimatedTime, systemImage: "clock.fill")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Label("\(lesson.xpReward) XP", systemImage: "star.fill")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(AppColors.accentGold)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right.circle.fill")
                .font(.system(size: 28))
                .foregroundColor(.white.opacity(0.2))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        )
    }
    
    func difficultyGradient(_ difficulty: Lesson.Difficulty) -> LinearGradient {
        switch difficulty {
        case .beginner:
            return LinearGradient(colors: [Color.green.opacity(0.8), Color.green.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .intermediate:
            return LinearGradient(colors: [Color.orange.opacity(0.8), Color.orange.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .advanced:
            return LinearGradient(colors: [Color.red.opacity(0.8), Color.red.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}
