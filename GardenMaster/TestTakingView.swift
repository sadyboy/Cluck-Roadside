import SwiftUI

struct TestTakingView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    let test: Test
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswers: [Int?]
    @State private var showResults = false
    @State private var showExitConfirmation = false
    
    init(test: Test) {
        self.test = test
        _selectedAnswers = State(initialValue: Array(repeating: nil, count: test.questions.count))
    }
    
    var currentQuestion: Question {
        test.questions[currentQuestionIndex]
    }
    
    var score: Int {
        selectedAnswers.enumerated().filter { index, answer in
            guard let answer = answer else { return false }
            return answer == test.questions[index].correctAnswer
        }.count
    }
    
    var passed: Bool {
        score >= test.passingScore
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            if showResults {
                ResultsView(
                    test: test,
                    score: score,
                    passed: passed,
                    onDismiss: { dismiss() },
                    onRetry: resetTest
                )
            } else {
                VStack(spacing: 0) {
                    TestHeader(
                        testTitle: test.title,
                        currentQuestion: currentQuestionIndex + 1,
                        totalQuestions: test.questions.count,
                        onExit: { showExitConfirmation = true }
                    )
                    
                    QuestionProgress(current: currentQuestionIndex + 1, total: test.questions.count)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 32) {
                            QuestionCard(question: currentQuestion, questionNumber: currentQuestionIndex + 1)
                            
                            AnswerOptions(
                                options: currentQuestion.options,
                                selectedAnswer: $selectedAnswers[currentQuestionIndex]
                            )
                            
                            Spacer(minLength: 20)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                    }
                    
                    NavigationControls(
                        currentIndex: currentQuestionIndex,
                        totalQuestions: test.questions.count,
                        hasAnswer: selectedAnswers[currentQuestionIndex] != nil,
                        onPrevious: {
                            withAnimation {
                                currentQuestionIndex -= 1
                            }
                        },
                        onNext: {
                            if currentQuestionIndex < test.questions.count - 1 {
                                withAnimation {
                                    currentQuestionIndex += 1
                                }
                            } else {
                                submitTest()
                            }
                        }
                    )
                }
            }
        }
        .confirmationDialog("Exit Test?", isPresented: $showExitConfirmation) {
            Button("Exit", role: .destructive) {
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Your progress will not be saved")
        }
    }
    
    func submitTest() {
        appState.submitTest(test.id, score: score, total: test.questions.count)
        withAnimation {
            showResults = true
        }
    }
    
    func resetTest() {
        selectedAnswers = Array(repeating: nil, count: test.questions.count)
        currentQuestionIndex = 0
        showResults = false
    }
}

struct TestHeader: View {
    let testTitle: String
    let currentQuestion: Int
    let totalQuestions: Int
    let onExit: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onExit) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(AppColors.cardBackground))
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Text(testTitle)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("Question \(currentQuestion)/\(totalQuestions)")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Color.clear
                .frame(width: 40, height: 40)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

struct QuestionProgress: View {
    let current: Int
    let total: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 8)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(AppColors.cosmicGradient)
                    .frame(width: geometry.size.width * (CGFloat(current) / CGFloat(total)), height: 8)
                    .animation(.spring(), value: current)
            }
        }
        .frame(height: 8)
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
    }
}

struct QuestionCard: View {
    let question: Question
    let questionNumber: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Question \(questionNumber)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.accentBlue)
                    .textCase(.uppercase)
                    .tracking(1.2)
                
                Spacer()
                
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.accentBlue.opacity(0.5))
            }
            
            Text(question.question)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .lineSpacing(6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppColors.accentBlue.opacity(0.3), lineWidth: 2)
                )
        )
    }
}

struct AnswerOptions: View {
    let options: [String]
    @Binding var selectedAnswer: Int?
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(0..<options.count, id: \.self) { index in
                AnswerButton(
                    letter: String(UnicodeScalar(65 + index)!),
                    text: options[index],
                    isSelected: selectedAnswer == index,
                    action: {
                        withAnimation(.spring(response: 0.3)) {
                            selectedAnswer = index
                        }
                    }
                )
            }
        }
    }
}

struct AnswerButton: View {
    let letter: String
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(isSelected ? AppColors.primaryGradient : LinearGradient(colors: [Color.white.opacity(0.1)], startPoint: .leading, endPoint: .trailing))
                        .frame(width: 44, height: 44)
                    
                    Text(letter)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Text(text)
                    .font(.system(size: 17))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? AppColors.primaryGreen.opacity(0.2) : AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? AppColors.primaryGreen : Color.white.opacity(0.1), lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct NavigationControls: View {
    let currentIndex: Int
    let totalQuestions: Int
    let hasAnswer: Bool
    let onPrevious: () -> Void
    let onNext: () -> Void
    
    var isLastQuestion: Bool {
        currentIndex == totalQuestions - 1
    }
    
    var body: some View {
        HStack(spacing: 16) {
            if currentIndex > 0 {
                Button(action: onPrevious) {
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
            
            Button(action: onNext) {
                HStack {
                    Text(isLastQuestion ? "Submit Test" : "Next Question")
                    if !isLastQuestion {
                        Image(systemName: "chevron.right")
                    }
                }
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(hasAnswer ? AppColors.primaryGradient : LinearGradient(colors: [Color.gray.opacity(0.5)], startPoint: .leading, endPoint: .trailing))
                        .shadow(color: hasAnswer ? AppColors.primaryGreen.opacity(0.5) : Color.clear, radius: 10)
                )
            }
            .disabled(!hasAnswer)
            .opacity(hasAnswer ? 1.0 : 0.6)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(AppColors.background)
    }
}

struct ResultsView: View {
    let test: Test
    let score: Int
    let passed: Bool
    let onDismiss: () -> Void
    let onRetry: () -> Void
    
    @State private var showContent = false
    
    var percentage: Double {
        Double(score) / Double(test.questions.count)
    }
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            if showContent {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 12)
                        .frame(width: 180, height: 180)
                    
                    Circle()
                        .trim(from: 0, to: percentage)
                        .stroke(passed ? Color.green : Color.orange, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .frame(width: 180, height: 180)
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(response: 1.0, dampingFraction: 0.7), value: showContent)
                    
                    VStack(spacing: 8) {
                        Text("\(Int(percentage * 100))%")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("\(score)/\(test.questions.count)")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .scaleEffect(showContent ? 1 : 0.5)
                .animation(.spring(response: 0.6, dampingFraction: 0.6), value: showContent)
            }
            
            VStack(spacing: 12) {
                Text(passed ? "Congratulations!" : "Keep Trying!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                Text(passed ? "You passed the test!" : "You need \(test.passingScore) correct to pass")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.7))
                
                if passed {
                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 18))
                            .foregroundColor(AppColors.accentGold)
                        
                        Text("Achievement Unlocked!")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppColors.accentGold)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(AppColors.accentGold.opacity(0.2))
                    )
                }
            }
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 20)
            .animation(.easeOut(duration: 0.5).delay(0.3), value: showContent)
            
            Spacer()
            
            VStack(spacing: 12) {
                Button(action: onDismiss) {
                    Text("Continue")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColors.primaryGradient)
                                .shadow(color: AppColors.primaryGreen.opacity(0.5), radius: 15)
                        )
                }
                
                Button(action: onRetry) {
                    Text("Retry Test")
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
            .padding(.horizontal, 20)
            .opacity(showContent ? 1 : 0)
            .animation(.easeOut(duration: 0.5).delay(0.6), value: showContent)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showContent = true
            }
        }
    }
}
