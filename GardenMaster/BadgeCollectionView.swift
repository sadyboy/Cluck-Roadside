import SwiftUI

struct BadgeCollectionView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var selectedRarity: Achievement.Rarity? = nil
    
    var filteredAchievements: [Achievement] {
        if let rarity = selectedRarity {
            return appState.achievements.filter { $0.rarity == rarity }
        }
        return appState.achievements
    }
    
    var unlockedCount: Int {
        appState.achievements.filter { $0.isUnlocked }.count
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                BadgeHeader(dismiss: dismiss, unlocked: unlockedCount, total: appState.achievements.count)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        RarityFilter(selectedRarity: $selectedRarity)
                        
                        ProgressSummary(achievements: appState.achievements)
                        
                        AchievementGrid(achievements: filteredAchievements)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
            }
        }
    }
}

struct BadgeHeader: View {
    let dismiss: DismissAction
    let unlocked: Int
    let total: Int
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(AppColors.cardBackground))
                }
                
                Spacer()
                
                Text("Achievements")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Color.clear.frame(width: 40, height: 40)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            
            HStack(spacing: 16) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(AppColors.successGradient)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(unlocked) of \(total) Unlocked")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.2))
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppColors.primaryGradient)
                                .frame(width: geometry.size.width * (Double(unlocked) / Double(total)))
                        }
                    }
                    .frame(height: 6)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 12)
    }
}

struct RarityFilter: View {
    @Binding var selectedRarity: Achievement.Rarity?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                RarityChip(
                    title: "All",
                    color: .white,
                    isSelected: selectedRarity == nil,
                    action: { selectedRarity = nil }
                )
                
                RarityChip(
                    title: "Common",
                    color: .gray,
                    isSelected: selectedRarity == .common,
                    action: { selectedRarity = .common }
                )
                
                RarityChip(
                    title: "Rare",
                    color: .blue,
                    isSelected: selectedRarity == .rare,
                    action: { selectedRarity = .rare }
                )
                
                RarityChip(
                    title: "Epic",
                    color: .purple,
                    isSelected: selectedRarity == .epic,
                    action: { selectedRarity = .epic }
                )
                
                RarityChip(
                    title: "Legendary",
                    color: .orange,
                    isSelected: selectedRarity == .legendary,
                    action: { selectedRarity = .legendary }
                )
            }
        }
    }
}

struct RarityChip: View {
    let title: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(isSelected ? .white : .white.opacity(0.6))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(isSelected ? color.opacity(0.3) : Color.clear)
                    .overlay(
                        Capsule()
                            .stroke(color.opacity(0.5), lineWidth: 1.5)
                    )
            )
        }
    }
}

struct ProgressSummary: View {
    let achievements: [Achievement]
    
    var rarityBreakdown: [(Achievement.Rarity, Int, Color)] {
        [
            (.common, achievements.filter { $0.rarity == .common && $0.isUnlocked }.count, .gray),
            (.rare, achievements.filter { $0.rarity == .rare && $0.isUnlocked }.count, .blue),
            (.epic, achievements.filter { $0.rarity == .epic && $0.isUnlocked }.count, .purple),
            (.legendary, achievements.filter { $0.rarity == .legendary && $0.isUnlocked }.count, .orange)
        ]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Collection Summary")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                ForEach(rarityBreakdown, id: \.0) { rarity, count, color in
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(color.opacity(0.2))
                                .frame(width: 50, height: 50)
                            
                            Text("\(count)")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(color)
                        }
                        
                        Text(rarity.rawValue)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardBackground)
            )
        }
    }
}

struct AchievementGrid: View {
    let achievements: [Achievement]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("All Achievements")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(achievements) { achievement in
                    AchievementCard(achievement: achievement)
                }
            }
        }
    }
}

struct AchievementCard: View {
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
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? rarityColor.opacity(0.2) : Color.white.opacity(0.05))
                    .frame(width: 80, height: 80)
                
                if achievement.isUnlocked {
                    Image(systemName: achievement.icon)
                        .font(.system(size: 36))
                        .foregroundColor(rarityColor)
                } else {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.white.opacity(0.3))
                }
                
                if achievement.isUnlocked {
                    Circle()
                        .stroke(rarityColor, lineWidth: 3)
                        .frame(width: 85, height: 85)
                }
            }
            
            VStack(spacing: 4) {
                Text(achievement.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(achievement.description)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                
                Text(achievement.rarity.rawValue)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(rarityColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(
                        Capsule()
                            .fill(rarityColor.opacity(0.2))
                    )
            }
            
            if !achievement.isUnlocked {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.1))
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(rarityColor)
                            .frame(width: geometry.size.width * achievement.progressPercentage)
                    }
                }
                .frame(height: 6)
                
                Text("\(achievement.progress)/\(achievement.requirement)")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))
            } else {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.accentGold)
                    
                    Text("+\(achievement.xpReward) XP")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(AppColors.accentGold)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(achievement.isUnlocked ? rarityColor.opacity(0.5) : Color.white.opacity(0.1), lineWidth: 2)
                )
                .shadow(color: achievement.isUnlocked ? rarityColor.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 5)
        )
    }
}
