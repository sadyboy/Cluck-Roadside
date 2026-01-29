import SwiftUI

struct ExpertHistoryView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var selectedExpert: Expert? = nil
    @State private var showTimeline = false
    
    let allExperts = DataProvider.getExperts()
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HistoryHeader(dismiss: dismiss, showTimeline: $showTimeline)
                
                if showTimeline {
                    TimelineTab()
                } else {
                    ExpertsTab(experts: allExperts, onExpertSelect: { expert in
                        selectedExpert = expert
                    })
                }
            }
        }
        .sheet(item: $selectedExpert) { expert in
            ExpertDetailSheet(expert: expert)
        }
    }
}

struct HistoryHeader: View {
    let dismiss: DismissAction
    @Binding var showTimeline: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(AppColors.cardBackground))
                }
                
                Spacer()
                
                Text("Garden History")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Color.clear.frame(width: 40, height: 40)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            
            HStack(spacing: 12) {
                TabButton(
                    title: "Experts",
                    icon: "person.2.fill",
                    isSelected: !showTimeline,
                    action: { showTimeline = false }
                )
                
                TabButton(
                    title: "Timeline",
                    icon: "clock.fill",
                    isSelected: showTimeline,
                    action: { showTimeline = true }
                )
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 12)
    }
}

struct TabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(isSelected ? .white : .white.opacity(0.6))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.primaryGradient : LinearGradient(colors: [AppColors.cardBackground], startPoint: .leading, endPoint: .trailing))
            )
        }
    }
}

struct ExpertsTab: View {
    @EnvironmentObject var appState: AppState
    let experts: [Expert]
    let onExpertSelect: (Expert) -> Void
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                Text("Discover pioneering gardeners and botanists who shaped modern horticulture")
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                
                LazyVStack(spacing: 16) {
                    ForEach(experts) { expert in
                        ExpertCard(
                            expert: expert,
                            isViewed: appState.user.viewedExperts.contains(expert.id),
                            onTap: {
                                appState.viewExpert(expert.id)
                                onExpertSelect(expert)
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer(minLength: 100)
            }
        }
    }
}

struct ExpertCard: View {
    let expert: Expert
    let isViewed: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    ZStack(alignment: .bottomTrailing) {
                        Circle()
                            .fill(AppColors.secondaryGradient)
                            .frame(width: 70, height: 70)
                            .overlay(
                                Image(systemName: expert.icon)
                                    .font(.system(size: 32))
                                    .foregroundColor(.white)
                            )
                        
                        if isViewed {
                            Circle()
                                .fill(.green)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.white)
                                )
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(expert.name)
                            .font(.system(size: 19, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("\(expert.yearBorn) - \(expert.yearDied ?? "Present")")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                        
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.accentGold)
                            
                            Text("\(expert.discoveries.count) discoveries")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.4))
                }
                .padding(16)
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                HStack {
                    Image(systemName: "quote.bubble.fill")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.accentBlue)
                    
                    Text(expert.quote)
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(2)
                    
                    Spacer()
                }
                .padding(16)
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.cardBackground)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            )
        }
    }
}

struct TimelineTab: View {
    let events = DataProvider.getTimelineEvents().sorted {
        (Int($0.year.filter(\.isNumber)) ?? 0) < (Int($1.year.filter(\.isNumber)) ?? 0)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                Text("Journey through the history of gardening and agriculture")
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                
                ForEach(Array(events.enumerated()), id: \.element.id) { index, event in
                    TimelineEventRow(event: event, isLast: index == events.count - 1)
                }
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
    }
}

struct TimelineEventRow: View {
    let event: TimelineEvent
    let isLast: Bool
    
    var categoryColor: Color {
        switch event.category {
        case "Ancient": return .purple
        case "Exploration": return .orange
        case "People": return .blue
        case "Discovery": return .green
        case "Publication": return .red
        case "Innovation": return AppColors.accentGold
        default: return .gray
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(categoryColor)
                        .frame(width: 40, height: 40)
                    
                    Circle()
                        .fill(AppColors.cardBackground)
                        .frame(width: 32, height: 32)
                    
                    Circle()
                        .fill(categoryColor)
                        .frame(width: 16, height: 16)
                }
                
                if !isLast {
                    Rectangle()
                        .fill(categoryColor.opacity(0.3))
                        .frame(width: 2)
                        .frame(height: 100)
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(event.year)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(categoryColor)
                    
                    Spacer()
                    
                    Text(event.category)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(categoryColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(categoryColor.opacity(0.2))
                        )
                }
                
                Text(event.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Text(event.description)
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.8))
                    .lineSpacing(4)
                
                if let expertId = event.expertId {
                    HStack(spacing: 6) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.primaryGreen)
                        
                        if let expert = DataProvider.getExperts().first(where: { $0.id == expertId }) {
                            Text(expert.name)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(AppColors.primaryGreen)
                        }
                    }
                    .padding(.top, 4)
                }
            }
            .padding(.bottom, 24)
        }
    }
}

struct ExpertDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    let expert: Expert
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        ExpertHeader(expert: expert)
                        
                        BiographySection(biography: expert.biography)
                        
                        ContributionsSection(contributions: expert.contributions)
                        
                        DiscoveriesSection(discoveries: expert.discoveries)
                        
                        QuoteSection(quote: expert.quote, name: expert.name)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
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

struct ExpertHeader: View {
    let expert: Expert
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.secondaryGradient)
                    .frame(width: 120, height: 120)
                
                Image(systemName: expert.icon)
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }
            .shadow(color: AppColors.secondaryBrown.opacity(0.5), radius: 20)
            
            Text(expert.name)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("\(expert.yearBorn) - \(expert.yearDied ?? "Present")")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
        }
    }
}

struct BiographySection: View {
    let biography: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle(title: "Biography", icon: "book.fill")
            
            Text(biography)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(6)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
        )
    }
}

struct ContributionsSection: View {
    let contributions: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle(title: "Major Contributions", icon: "star.fill")
            
            VStack(spacing: 12) {
                ForEach(Array(contributions.enumerated()), id: \.offset) { index, contribution in
                    HStack(alignment: .top, spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(AppColors.primaryGreen.opacity(0.2))
                                .frame(width: 32, height: 32)
                            
                            Text("\(index + 1)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(AppColors.primaryGreen)
                        }
                        
                        Text(contribution)
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.9))
                            .lineSpacing(4)
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

struct DiscoveriesSection: View {
    let discoveries: [Discovery]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionTitle(title: "Key Discoveries", icon: "lightbulb.fill")
            
            ForEach(discoveries) { discovery in
                DiscoveryCard(discovery: discovery)
            }
        }
    }
}

struct DiscoveryCard: View {
    let discovery: Discovery
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(discovery.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(discovery.year)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.accentGold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(AppColors.accentGold.opacity(0.2))
                    )
            }
            
            Text(discovery.description)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.8))
                .lineSpacing(4)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.accentGold.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct QuoteSection: View {
    let quote: String
    let name: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "quote.opening")
                .font(.system(size: 40))
                .foregroundColor(AppColors.accentBlue.opacity(0.5))
            
            Text(quote)
                .font(.system(size: 18, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
            
            Text("— \(name)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.accentBlue.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppColors.accentBlue.opacity(0.3), lineWidth: 2)
                )
        )
    }
}

struct SectionTitle: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(AppColors.primaryGreen)
            
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
        }
    }
}
