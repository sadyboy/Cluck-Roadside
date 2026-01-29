import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab = 0
    @State private var previousTab = 0
    @Namespace private var animation
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                NavigationView {
                    GardenHomeView()
                        .navigationBarHidden(true)
                }
                .navigationViewStyle(.stack)
                .tag(0)
                
                EducationView()
                    .tag(1)
                
                CardDeckView()
                    .tag(2)
                
                QuizHubView()
                    .tag(3)
                
                NavigationView {
                    ProfileView()
                        .navigationBarHidden(true)
                }
                .navigationViewStyle(.stack)
                .tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            CustomTabBar(selectedIndex: $selectedTab, namespace: animation)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
        }
        .onChange(of: selectedTab) { newValue in
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            previousTab = newValue
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedIndex: Int
    var namespace: Namespace.ID
    
    let items: [(icon: String, label: String)] = [
        ("house.fill", "Home"),
        ("book.fill", "Learn"),
        ("square.stack.3d.up.fill", "Cards"),
        ("brain.head.profile", "Quiz"),
        ("person.fill", "Profile")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<items.count, id: \.self) { index in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedIndex = index
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: items[index].icon)
                            .font(.system(size: selectedIndex == index ? 24 : 20))
                            .foregroundColor(selectedIndex == index ? .white : .white.opacity(0.5))
                            .frame(height: 28)
                        
                        if selectedIndex == index {
                            Text(items[index].label)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.white)
                                .matchedGeometryEffect(id: "label", in: namespace)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        ZStack {
                            if selectedIndex == index {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(AppColors.primaryGradient)
                                    .matchedGeometryEffect(id: "background", in: namespace)
                                    .shadow(color: AppColors.primaryGreen.opacity(0.5), radius: 10, x: 0, y: 5)
                            }
                        }
                    )
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(AppColors.cardBackground)
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        )
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
