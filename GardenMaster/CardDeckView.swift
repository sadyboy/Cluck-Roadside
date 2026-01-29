import SwiftUI

struct CardDeckView: View {
    @EnvironmentObject var appState: AppState
    @State private var allCards = DataProvider.getFlashcards()
    @State private var currentIndex = 0
    @State private var isFlipped = false
    @State private var offset: CGSize = .zero
    @State private var selectedCategory: String? = nil
    @State private var showCategoryPicker = false
    @State private var cardRotation: Double = 0
    @State private var showCardStack = true
    
    var categories: [String] {
        Array(Set(allCards.map { $0.category })).sorted()
    }
    
    var filteredCards: [Flashcard] {
        if let category = selectedCategory {
            return allCards.filter { $0.category == category }
        }
        return allCards
    }
    
    var currentCard: Flashcard? {
        guard currentIndex < filteredCards.count else { return nil }
        return filteredCards[currentIndex]
    }
    
    var masteredCount: Int {
        appState.user.masteredFlashcards.count
    }
    
    var progressPercentage: Double {
        guard allCards.count > 0 else { return 0 }
        return Double(masteredCount) / Double(allCards.count)
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    FlashcardHeader(
                        masteredCount: masteredCount,
                        totalCount: allCards.count,
                        progress: progressPercentage,
                        selectedCategory: selectedCategory,
                        onCategoryTap: { showCategoryPicker = true }
                    )
                    
                    Spacer()
                    
                    if let card = currentCard {
                        ZStack {
                            ForEach(0..<min(3, filteredCards.count - currentIndex), id: \.self) { index in
                                if currentIndex + index < filteredCards.count {
                                    CardStackBackground(index: index)
                                }
                            }
                            
                            InteractiveFlashcard(
                                card: card,
                                isFlipped: $isFlipped,
                                offset: $offset,
                                rotation: $cardRotation,
                                onSwipe: handleSwipe
                            )
                        }
                        .padding(.horizontal, 30)
                    } else {
                        CompletedState(onRestart: resetDeck)
                    }
                    
                    Spacer()
                    
                    if currentCard != nil {
                        CardControls(
                            currentIndex: currentIndex,
                            totalCards: filteredCards.count,
                            isFlipped: $isFlipped,
                            onPrevious: previousCard,
                            onFlip: flipCard,
                            onNext: nextCard
                        )
                        
                        SwipeHints()
                    }
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .sheet(isPresented: $showCategoryPicker) {
            CategorySelectionSheet(
                categories: categories,
                selectedCategory: $selectedCategory,
                onDismiss: { showCategoryPicker = false }
            )
        }
    }
    
    func handleSwipe(direction: SwipeDirection) {
        if direction == .right, let card = currentCard {
            appState.masterFlashcard(card.id)
        }
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            offset = direction == .right ? CGSize(width: 500, height: 0) : CGSize(width: -500, height: 0)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            nextCard()
            offset = .zero
        }
    }
    
    func flipCard() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isFlipped.toggle()
            cardRotation += 180
        }
    }
    
    func nextCard() {
        withAnimation(.spring()) {
            isFlipped = false
            if currentIndex < filteredCards.count - 1 {
                currentIndex += 1
            } else {
                currentIndex = 0
            }
        }
        offset = .zero
    }
    
    func previousCard() {
        withAnimation(.spring()) {
            isFlipped = false
            if currentIndex > 0 {
                currentIndex -= 1
            } else {
                currentIndex = filteredCards.count - 1
            }
        }
    }
    
    func resetDeck() {
        withAnimation {
            currentIndex = 0
            isFlipped = false
        }
    }
}

struct FlashcardHeader: View {
    let masteredCount: Int
    let totalCount: Int
    let progress: Double
    let selectedCategory: String?
    let onCategoryTap: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Flashcard Deck")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Master gardening terms")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
            }
            
            HStack(spacing: 16) {
                ProgressCircle(
                    progress: progress,
                    masteredCount: masteredCount,
                    totalCount: totalCount
                )
                
                VStack(alignment: .leading, spacing: 12) {
                    StatRow(
                        icon: "checkmark.circle.fill",
                        label: "Mastered",
                        value: "\(masteredCount)",
                        color: .green
                    )
                    
                    StatRow(
                        icon: "square.stack.fill",
                        label: "Total Cards",
                        value: "\(totalCount)",
                        color: AppColors.accentBlue
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.cardBackground)
            )
            
            Button(action: onCategoryTap) {
                HStack(spacing: 12) {
                    Image(systemName: "line.3.horizontal.decrease.circle.fill")
                        .font(.system(size: 20))
                    
                    Text(selectedCategory ?? "All Categories")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .bold))
                }
                .foregroundColor(.white)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(AppColors.primaryGradient)
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 60)
    }
}

struct ProgressCircle: View {
    let progress: Double
    let masteredCount: Int
    let totalCount: Int
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.2), lineWidth: 8)
                .frame(width: 100, height: 100)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: [AppColors.primaryGreen, AppColors.accentGold, AppColors.primaryGreen],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(-90))
            
            VStack(spacing: 2) {
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Done")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
    }
}

struct StatRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
            
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

struct CardStackBackground: View {
    let index: Int
    
    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(AppColors.cardBackground.opacity(0.6))
            .frame(height: 450)
            .scaleEffect(1.0 - (CGFloat(index) * 0.05))
            .offset(y: CGFloat(index) * 10)
    }
}

struct InteractiveFlashcard: View {
    let card: Flashcard
    @Binding var isFlipped: Bool
    @Binding var offset: CGSize
    @Binding var rotation: Double
    let onSwipe: (SwipeDirection) -> Void
    
    @State private var dragAmount: CGSize = .zero
    
    var body: some View {
        ZStack {
            CardSide(
                content: card.term,
                icon: card.icon,
                label: "Term",
                gradient: AppColors.primaryGradient,
                isVisible: !isFlipped
            )
            .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
            .opacity(isFlipped ? 0 : 1)
            
            CardSide(
                content: card.definition,
                icon: "quote.bubble.fill",
                label: "Definition",
                gradient: AppColors.cosmicGradient,
                isVisible: isFlipped
            )
            .rotation3DEffect(.degrees(rotation + 180), axis: (x: 0, y: 1, z: 0))
            .opacity(isFlipped ? 1 : 0)
        }
        .frame(height: 450)
        .offset(offset)
        .offset(dragAmount)
        .rotationEffect(.degrees(Double(dragAmount.width / 20)))
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragAmount = value.translation
                }
                .onEnded { value in
                    if abs(value.translation.width) > 150 {
                        if value.translation.width > 0 {
                            onSwipe(.right)
                        } else {
                            onSwipe(.left)
                        }
                    }
                    withAnimation(.spring()) {
                        dragAmount = .zero
                    }
                }
        )
        .onTapGesture {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isFlipped.toggle()
                rotation += 180
            }
        }
    }
}

struct CardSide: View {
    let content: String
    let icon: String
    let label: String
    let gradient: LinearGradient
    let isVisible: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(gradient)
                    .frame(height: 120)
                
                Image(systemName: icon)
                    .font(.system(size: 60))
                    .foregroundColor(.white.opacity(0.9))
            }
            
            VStack(spacing: 20) {
                Text(label.uppercased())
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white.opacity(0.6))
                    .tracking(2)
                
                Text(content)
                    .font(.system(size: label == "Term" ? 28 : 18, weight: label == "Term" ? .bold : .regular))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .padding(.horizontal, 30)
                
                Spacer()
            }
            .padding(.top, 30)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.cardBackground)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.3), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
}

struct CardControls: View {
    let currentIndex: Int
    let totalCards: Int
    @Binding var isFlipped: Bool
    let onPrevious: () -> Void
    let onFlip: () -> Void
    let onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("\(currentIndex + 1) / \(totalCards)")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white.opacity(0.7))
            
            HStack(spacing: 24) {
                ControlButton(
                    icon: "chevron.left",
                    size: 50,
                    color: AppColors.secondaryBrown,
                    action: onPrevious
                )
                
                ControlButton(
                    icon: "arrow.triangle.2.circlepath",
                    size: 65,
                    color: AppColors.primaryGreen,
                    action: onFlip
                )
                
                ControlButton(
                    icon: "chevron.right",
                    size: 50,
                    color: AppColors.secondaryBrown,
                    action: onNext
                )
            }
        }
        .padding(.top, 20)
    }
}

struct ControlButton: View {
    let icon: String
    let size: CGFloat
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: size, height: size)
                
                Circle()
                    .stroke(color, lineWidth: 2)
                    .frame(width: size, height: size)
                
                Image(systemName: icon)
                    .font(.system(size: size * 0.4, weight: .bold))
                    .foregroundColor(color)
            }
        }
    }
}

struct SwipeHints: View {
    var body: some View {
        HStack(spacing: 60) {
            HintLabel(
                icon: "arrow.left",
                text: "Skip",
                color: .red
            )
            
            HintLabel(
                icon: "arrow.right",
                text: "Mastered",
                color: .green
            )
        }
        .padding(.top, 16)
    }
}

struct HintLabel: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
            
            Text(text)
                .font(.system(size: 15, weight: .semibold))
        }
        .foregroundColor(color)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(color.opacity(0.15))
        )
    }
}

struct CompletedState: View {
    let onRestart: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 100))
                .foregroundStyle(AppColors.successGradient)
            
            Text("All Cards Reviewed!")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Text("Great job! You've gone through all flashcards.")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Button(action: onRestart) {
                Text("Start Again")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: 200)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.primaryGradient)
                    )
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, 40)
    }
}

struct CategorySelectionSheet: View {
    let categories: [String]
    @Binding var selectedCategory: String?
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        CategoryOption(
                            title: "All Categories",
                            icon: "square.grid.2x2.fill",
                            isSelected: selectedCategory == nil,
                            action: {
                                selectedCategory = nil
                                onDismiss()
                            }
                        )
                        
                        ForEach(categories, id: \.self) { category in
                            CategoryOption(
                                title: category,
                                icon: iconForCategory(category),
                                isSelected: selectedCategory == category,
                                action: {
                                    selectedCategory = category
                                    onDismiss()
                                }
                            )
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Select Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onDismiss()
                    }
                    .foregroundColor(AppColors.primaryGreen)
                    .font(.system(size: 17, weight: .semibold))
                }
            }
        }
    }
    
    func iconForCategory(_ category: String) -> String {
        switch category {
        case "Plant Biology": return "leaf.fill"
        case "Growth": return "arrow.up.right"
        case "Soil": return "mountain.2.fill"
        case "Techniques": return "gearshape.fill"
        case "Nutrients": return "drop.fill"
        case "Seasons": return "calendar"
        case "Varieties": return "tree.fill"
        case "Environment": return "globe.americas.fill"
        case "Maintenance": return "wrench.fill"
        default: return "folder.fill"
        }
    }
}

struct CategoryOption: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.primaryGreen.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(AppColors.primaryGreen)
                }
                
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.primaryGreen)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? AppColors.primaryGreen.opacity(0.15) : AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? AppColors.primaryGreen : Color.clear, lineWidth: 2)
                    )
            )
        }
    }
}

enum SwipeDirection {
    case left, right
}
