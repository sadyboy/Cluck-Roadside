import SwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var editedName: String = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var isEditingName = false
    @State private var showImagePicker = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    ProfileHeader(
                        user: appState.user,
                        onPhotoTap: { showImagePicker = true },
                        isEditingName: $isEditingName,
                        editedName: $editedName,
                        onSaveName: saveName
                    )
                    
                    LevelCard(user: appState.user)
                    
                    AchievementPreview()
                    
                    StatsGrid()
                    
                    SettingsSection()
                    
                    DangerZone()
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
            }
        }
        .photosPicker(isPresented: $showImagePicker, selection: $selectedPhoto, matching: .images)
        .onChange(of: selectedPhoto) { newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    appState.user.profileImageData = data
                }
            }
        }
        .onAppear {
            editedName = appState.user.name
        }
    }
    
    func saveName() {
        if !editedName.trimmingCharacters(in: .whitespaces).isEmpty {
            appState.user.name = editedName
        }
        isEditingName = false
    }
}

struct ProfileHeader: View {
    let user: User
    let onPhotoTap: () -> Void
    @Binding var isEditingName: Bool
    @Binding var editedName: String
    let onSaveName: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Button(action: onPhotoTap) {
                ZStack(alignment: .bottomTrailing) {
                    if let imageData = user.profileImageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(AppColors.primaryGradient)
                            .frame(width: 120, height: 120)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                            )
                    }
                    
                    ZStack {
                        Circle()
                            .fill(AppColors.cardBackground)
                            .frame(width: 36, height: 36)
                        
                        Image(systemName: "camera.fill")
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.primaryGreen)
                    }
                    .offset(x: -5, y: -5)
                }
                .shadow(color: AppColors.primaryGreen.opacity(0.5), radius: 20)
            }
            
            if isEditingName {
                HStack(spacing: 12) {
                    TextField("Enter name", text: $editedName)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.cardBackground)
                        )
                    
                    Button(action: onSaveName) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(AppColors.primaryGreen)
                    }
                }
            } else {
                Button(action: { isEditingName = true }) {
                    HStack(spacing: 8) {
                        Text(user.name)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        Image(systemName: "pencil")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
            }
            
            HStack(spacing: 20) {
                LevelBadge(level: user.level)
                StreakBadge(streak: user.currentStreak)
            }
        }
    }
}

struct LevelBadge: View {
    let level: Int
    
    var body: some View {
        VStack(spacing: 4) {
            Text("Level")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
            
            Text("\(level)")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(AppColors.successGradient)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
        )
    }
}

struct StreakBadge: View {
    let streak: Int
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: "flame.fill")
                .font(.system(size: 16))
                .foregroundColor(AppColors.accentGold)
            
            Text("\(streak) days")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground)
        )
    }
}

struct LevelCard: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total XP")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Text("\(user.totalXP)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(AppColors.primaryGradient)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Next Level")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Text("\((user.level) * 100) XP")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.1))
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColors.primaryGradient)
                        .frame(width: geometry.size.width * user.progressToNextLevel)
                        .shadow(color: AppColors.primaryGreen.opacity(0.6), radius: 8)
                }
            }
            .frame(height: 12)
            
            Text("\(Int(user.progressToNextLevel * 100))% to Level \(user.level + 1)")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
        )
    }
}

struct AchievementPreview: View {
    @EnvironmentObject var appState: AppState
    
    var unlockedCount: Int {
        appState.achievements.filter { $0.isUnlocked }.count
    }
    
    var recentAchievements: [Achievement] {
        Array(appState.achievements.filter { $0.isUnlocked }.prefix(3))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Achievements")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(unlockedCount)/14")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            if recentAchievements.isEmpty {
                Text("Complete lessons and tests to unlock achievements")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.vertical, 20)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(recentAchievements) { achievement in
                            MiniAchievementCard(achievement: achievement)
                        }
                    }
                }
            }
        }
    }
}

struct MiniAchievementCard: View {
    let achievement: Achievement
    
    var rarityColor: Color {
        switch achievement.rarity {
        case .common: return .gray
        case .rare: return .blue
        case .epic: return .purple
        case .legendary: return .orange
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: achievement.icon)
                .font(.system(size: 32))
                .foregroundColor(rarityColor)
            
            Text(achievement.title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(width: 100, height: 100)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(rarityColor.opacity(0.5), lineWidth: 2)
                )
        )
    }
}

struct StatsGrid: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Stats")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                StatCard(icon: "book.fill", value: "\(appState.user.completedLessons.count)", label: "Lessons Done", color: AppColors.primaryGreen)
                StatCard(icon: "checkmark.seal.fill", value: "\(appState.user.completedTests.count)", label: "Tests Passed", color: AppColors.accentBlue)
                StatCard(icon: "square.stack.3d.up.fill", value: "\(appState.user.masteredFlashcards.count)", label: "Cards Mastered", color: AppColors.accentGold)
                StatCard(icon: "person.2.fill", value: "\(appState.user.viewedExperts.count)", label: "Experts Viewed", color: AppColors.secondaryBrown)
            }
        }
    }
}

struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
        )
    }
}

struct SettingsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                SettingsRow(icon: "bell.fill", title: "Notifications", color: AppColors.accentGold)
                SettingsRow(icon: "moon.fill", title: "Dark Mode", color: AppColors.accentBlue)
                SettingsRow(icon: "globe", title: "Language", color: AppColors.primaryGreen)
                SettingsRow(icon: "questionmark.circle.fill", title: "Help & Support", color: .orange)
            }
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(color.opacity(0.2))
                    )
                
                Text(title)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardBackground)
            )
        }
    }
}

struct DangerZone: View {
    @EnvironmentObject var appState: AppState
    @State private var showResetConfirmation = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Danger Zone")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.red)
            
            Button(action: { showResetConfirmation = true }) {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    
                    Text("Reset All Progress")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.red.opacity(0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.red.opacity(0.5), lineWidth: 2)
                        )
                )
            }
        }
        .confirmationDialog("Reset All Progress?", isPresented: $showResetConfirmation) {
            Button("Reset Everything", role: .destructive) {
                appState.user = User()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will delete all your progress permanently. This action cannot be undone.")
        }
    }
}
