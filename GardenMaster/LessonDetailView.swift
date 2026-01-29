import SwiftUI

struct LessonDetailView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    let lesson: Lesson
    
    @State private var currentBlockIndex = 0
    @State private var showCompletion = false
    
    var isCompleted: Bool {
        appState.user.completedLessons.contains(lesson.id)
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TopNavigationBar(title: lesson.title, dismiss: dismiss)
                
                ProgressIndicator(current: currentBlockIndex + 1, total: lesson.contentBlocks.count)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        ContentBlockView(block: lesson.contentBlocks[currentBlockIndex])
                            .id(currentBlockIndex)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                
                NavigationButtons(
                    currentIndex: $currentBlockIndex,
                    totalBlocks: lesson.contentBlocks.count,
                    onComplete: {
                        if !isCompleted {
                            appState.completeLesson(lesson.id, xp: lesson.xpReward)
                        }
                        showCompletion = true
                    }
                )
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showCompletion) {
            CompletionScreen(
                title: "Lesson Complete!",
                xpEarned: lesson.xpReward,
                onDismiss: { dismiss() }
            )
        }
    }
}

struct TopNavigationBar: View {
    let title: String
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
            
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)
            
            Spacer()
            
            Color.clear
                .frame(width: 40, height: 40)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

struct ProgressIndicator: View {
    let current: Int
    let total: Int
    
    var body: some View {
        VStack(spacing: 8) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.primaryGradient)
                        .frame(width: geometry.size.width * (CGFloat(current) / CGFloat(total)), height: 8)
                        .animation(.spring(), value: current)
                }
            }
            .frame(height: 8)
            
            Text("\(current) of \(total)")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
    }
}

struct ContentBlockView: View {
    let block: ContentBlock
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            switch block.type {
            case .heading:
                Text(block.content)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
            case .text:
                Text(block.content)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white.opacity(0.9))
                    .lineSpacing(6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
            case .fact:
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.accentGold)
                    
                    Text(block.content)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .lineSpacing(4)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.accentGold.opacity(0.15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(AppColors.accentGold.opacity(0.3), lineWidth: 2)
                        )
                )
                
            case .formula:
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "function")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.accentBlue)
                    
                    Text(block.content)
                        .font(.system(size: 16, weight: .semibold, design: .monospaced))
                        .foregroundColor(.white)
                        .lineSpacing(4)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.accentBlue.opacity(0.15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(AppColors.accentBlue.opacity(0.3), lineWidth: 2)
                        )
                )
            }
        }
    }
}

struct NavigationButtons: View {
    @Binding var currentIndex: Int
    let totalBlocks: Int
    let onComplete: () -> Void
    
    var isLastBlock: Bool {
        currentIndex == totalBlocks - 1
    }
    
    var body: some View {
        HStack(spacing: 16) {
            if currentIndex > 0 {
                Button(action: {
                    withAnimation(.spring()) {
                        currentIndex -= 1
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Previous")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.cardBackground)
                    )
                }
            }
            
            Button(action: {
                if isLastBlock {
                    onComplete()
                } else {
                    withAnimation(.spring()) {
                        currentIndex += 1
                    }
                }
            }) {
                HStack {
                    Text(isLastBlock ? "Complete" : "Next")
                    if !isLastBlock {
                        Image(systemName: "chevron.right")
                    }
                }
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.primaryGradient)
                        .shadow(color: AppColors.primaryGreen.opacity(0.5), radius: 10)
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(AppColors.background)
    }
}

struct CompletionScreen: View {
    let title: String
    let xpEarned: Int
    let onDismiss: () -> Void
    
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                if showContent {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 100))
                        .foregroundStyle(AppColors.successGradient)
                        .scaleEffect(showContent ? 1 : 0.5)
                        .animation(.spring(response: 0.6, dampingFraction: 0.6), value: showContent)
                }
                
                VStack(spacing: 12) {
                    Text(title)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("+\(xpEarned) XP")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(AppColors.successGradient)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(0.3), value: showContent)
                
                Spacer()
                
                Button(action: onDismiss) {
                    Text("Continue")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColors.primaryGradient)
                        )
                }
                .padding(.horizontal, 20)
                .opacity(showContent ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.6), value: showContent)
            }
        }
        .onAppear {
            showContent = true
        }
    }
}
