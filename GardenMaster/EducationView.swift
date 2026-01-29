import SwiftUI

struct EducationView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText = ""
    @State private var selectedDifficulty: Lesson.Difficulty? = nil
    @State private var showFilterSheet = false
    @State private var animateHeader = false
    
    let allLessons = DataProvider.getLessons()
    
    var filteredLessons: [Lesson] {
        var result = allLessons
        
        if let difficulty = selectedDifficulty {
            result = result.filter { $0.difficulty == difficulty }
        }
        
        if !searchText.isEmpty {
            result = result.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        
        return result
    }
    
    var completedCount: Int {
        appState.user.completedLessons.count
    }
    
    var totalCount: Int {
        allLessons.count
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        LearningHeader(
                            completed: completedCount,
                            total: totalCount,
                            animate: $animateHeader
                        )
                        
                        SearchBarWithFilter(
                            searchText: $searchText,
                            onFilterTap: { showFilterSheet = true }
                        )
                        
                        if selectedDifficulty != nil {
                            ActiveFilterChip(selectedDifficulty: $selectedDifficulty)
                        }
                        
                        LearningPathSection()
                        
                        CategorizedLessons(lessons: filteredLessons)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showFilterSheet) {
                FilterBottomSheet(selectedDifficulty: $selectedDifficulty)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    animateHeader = true
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct LearningHeader: View {
    let completed: Int
    let total: Int
    @Binding var animate: Bool
    
    var percentage: Double {
        total > 0 ? Double(completed) / Double(total) : 0
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Learning Path")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Master gardening step by step")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 6)
                        .frame(width: 70, height: 70)
                    
                    Circle()
                        .trim(from: 0, to: percentage)
                        .stroke(AppColors.primaryGradient, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .frame(width: 70, height: 70)
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 2) {
                        Text("\(completed)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("of \(total)")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.1))
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [
                                    AppColors.primaryGreen,
                                    AppColors.accentGold,
                                    AppColors.primaryGreen
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * percentage)
                        .shadow(color: AppColors.primaryGreen.opacity(0.6), radius: 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        colors: [.white.opacity(0.3), .clear],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: geometry.size.width * percentage)
                        )
                }
            }
            .frame(height: 16)
            
            HStack {
                Label("\(Int(percentage * 100))% Complete", systemImage: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.primaryGreen)
                
                Spacer()
                
                Label("\(total - completed) remaining", systemImage: "book.closed")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(AppColors.cardBackground)
                .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 8)
        )
    }
}

struct SearchBarWithFilter: View {
    @Binding var searchText: String
    let onFilterTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white.opacity(0.6))
                    .font(.system(size: 18))
                
                TextField("Search lessons...", text: $searchText)
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .font(.system(size: 16))
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.system(size: 18))
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardBackground)
            )
            
            Button(action: onFilterTap) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.primaryGradient)
                    )
            }
        }
    }
}

struct ActiveFilterChip: View {
    @Binding var selectedDifficulty: Lesson.Difficulty?
    
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Text("Filter:")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                
                Text(selectedDifficulty?.rawValue ?? "")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                
                Button(action: { selectedDifficulty = nil }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(AppColors.accentBlue.opacity(0.3))
            )
            
            Spacer()
        }
    }
}

struct LearningPathSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "map.fill")
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.accentGold)
                
                Text("Recommended Path")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            Text("Follow our curated learning path from beginner to advanced")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
        }
    }
}

struct CategorizedLessons: View {
    let lessons: [Lesson]
    
    var beginnerLessons: [Lesson] {
        lessons.filter { $0.difficulty == .beginner }
    }
    
    var intermediateLessons: [Lesson] {
        lessons.filter { $0.difficulty == .intermediate }
    }
    
    var advancedLessons: [Lesson] {
        lessons.filter { $0.difficulty == .advanced }
    }
    
    var body: some View {
        VStack(spacing: 28) {
            if !beginnerLessons.isEmpty {
                LessonCategory(
                    title: "Beginner Level",
                    icon: "leaf.fill",
                    color: .green,
                    lessons: beginnerLessons
                )
            }
            
            if !intermediateLessons.isEmpty {
                LessonCategory(
                    title: "Intermediate Level",
                    icon: "tree.fill",
                    color: .orange,
                    lessons: intermediateLessons
                )
            }
            
            if !advancedLessons.isEmpty {
                LessonCategory(
                    title: "Advanced Level",
                    icon: "mountain.2.fill",
                    color: .red,
                    lessons: advancedLessons
                )
            }
        }
    }
}

struct LessonCategory: View {
    let title: String
    let icon: String
    let color: Color
    let lessons: [Lesson]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(lessons.count)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            VStack(spacing: 12) {
                ForEach(lessons) { lesson in
                    NavigationLink(destination: LessonDetailView(lesson: lesson)) {
                        ModernLessonCard(lesson: lesson, accentColor: color)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct ModernLessonCard: View {
    @EnvironmentObject var appState: AppState
    let lesson: Lesson
    let accentColor: Color
    
    var isCompleted: Bool {
        appState.user.completedLessons.contains(lesson.id)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 0)
                    .fill(
                        LinearGradient(
                            colors: [accentColor.opacity(0.8), accentColor.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80)
                
                VStack(spacing: 8) {
                    Image(systemName: lesson.icon)
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                    
                    if isCompleted {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.green)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(lesson.title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 12))
                        Text(lesson.estimatedTime)
                            .font(.system(size: 13))
                    }
                    .foregroundColor(.white.opacity(0.7))
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                        Text("\(lesson.xpReward) XP")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(AppColors.accentGold)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white.opacity(0.5))
                }
                
                if !isCompleted {
                    HStack(spacing: 6) {
                        ForEach(0..<lesson.contentBlocks.count, id: \.self) { index in
                            Circle()
                                .fill(Color.white.opacity(0.3))
                                .frame(width: 4, height: 4)
                        }
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 100)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isCompleted ? Color.green.opacity(0.5) : Color.clear, lineWidth: 2)
        )
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
}

struct FilterBottomSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedDifficulty: Lesson.Difficulty?
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Text("Filter by Difficulty")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 16) {
                        FilterOption(
                            title: "All Levels",
                            icon: "books.vertical.fill",
                            color: .white,
                            isSelected: selectedDifficulty == nil,
                            action: {
                                selectedDifficulty = nil
                                dismiss()
                            }
                        )
                        
                        FilterOption(
                            title: "Beginner",
                            icon: "leaf.fill",
                            color: .green,
                            isSelected: selectedDifficulty == .beginner,
                            action: {
                                selectedDifficulty = .beginner
                                dismiss()
                            }
                        )
                        
                        FilterOption(
                            title: "Intermediate",
                            icon: "tree.fill",
                            color: .orange,
                            isSelected: selectedDifficulty == .intermediate,
                            action: {
                                selectedDifficulty = .intermediate
                                dismiss()
                            }
                        )
                        
                        FilterOption(
                            title: "Advanced",
                            icon: "mountain.2.fill",
                            color: .red,
                            isSelected: selectedDifficulty == .advanced,
                            action: {
                                selectedDifficulty = .advanced
                                dismiss()
                            }
                        )
                    }
                    
                    Spacer()
                }
                .padding(24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
            }
        }
    }
}

struct FilterOption: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(color)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? color.opacity(0.15) : AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? color.opacity(0.5) : Color.clear, lineWidth: 2)
                    )
            )
        }
    }
}
