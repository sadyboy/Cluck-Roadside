import SwiftUI
import SpriteKit

struct SplashView: View {
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            SpriteView(scene: ParticleScene(), options: [.allowsTransparency])
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(AppColors.primaryGradient)
                    .shadow(color: AppColors.primaryGreen.opacity(0.8), radius: 20)
                    .scaleEffect(1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: UUID())
                
                Text("Cluck Roadside\nGardenMaster")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.primaryGradient)
                
                Text("Grow Your Knowledge")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .onAppear {
            let _ = UUID()
        }
    }
}

class ParticleScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        size = view.bounds.size
        scaleMode = .resizeFill
        
        createParticles()
    }
    
    func createParticles() {
        let emitter = SKEmitterNode()
        emitter.particleTexture = createParticleTexture()
        emitter.particleBirthRate = 20
        emitter.particleLifetime = 5
        emitter.particleScale = 0.3
        emitter.particleScaleRange = 0.2
        emitter.particleScaleSpeed = -0.05
        emitter.particleAlpha = 0.6
        emitter.particleAlphaSpeed = -0.1
        emitter.particleColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1)
        emitter.particleColorBlendFactor = 1
        emitter.particleSpeed = 30
        emitter.particleSpeedRange = 20
        emitter.emissionAngle = 0
        emitter.emissionAngleRange = .pi * 2
        emitter.position = CGPoint(x: size.width / 2, y: size.height / 2)
        emitter.particlePositionRange = CGVector(dx: size.width, dy: size.height)
        addChild(emitter)
    }
    
    func createParticleTexture() -> SKTexture {
        let size = CGSize(width: 8, height: 8)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(UIColor.white.cgColor)
        context?.fillEllipse(in: CGRect(origin: .zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return SKTexture(image: image!)
    }
}
