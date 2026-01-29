import SwiftUI
import SpriteKit

struct InteractiveSimulationsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedSimulation = 0
    
    let simulations = [
        ("Plant Growth", "leaf.fill"),
        ("Water Cycle", "drop.fill"),
        ("Pollination", "sparkles"),
        ("Composting", "arrow.3.trianglepath")
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                SimulationHeader(dismiss: dismiss)
                
                SimulationPicker(
                    simulations: simulations,
                    selectedIndex: $selectedSimulation
                )
                
                ZStack {
                    switch selectedSimulation {
                    case 0:
                        SpriteView(scene: PlantGrowthScene())
                            .ignoresSafeArea()
                    case 1:
                        SpriteView(scene: WaterCycleScene())
                            .ignoresSafeArea()
                    case 2:
                        SpriteView(scene: PollinationScene())
                            .ignoresSafeArea()
                    case 3:
                        SpriteView(scene: CompostingScene())
                            .ignoresSafeArea()
                    default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                InstructionBar(simulation: selectedSimulation)
            }
        }
    }
}

struct SimulationHeader: View {
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
            
            Text("Interactive Simulations")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

struct SimulationPicker: View {
    let simulations: [(String, String)]
    @Binding var selectedIndex: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(0..<simulations.count, id: \.self) { index in
                    Button(action: {
                        withAnimation(.spring()) {
                            selectedIndex = index
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: simulations[index].1)
                                .font(.system(size: 16))
                            
                            Text(simulations[index].0)
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(selectedIndex == index ? .white : .white.opacity(0.6))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(selectedIndex == index ? AppColors.primaryGradient : LinearGradient(colors: [AppColors.cardBackground], startPoint: .leading, endPoint: .trailing))
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 12)
    }
}

struct InstructionBar: View {
    let simulation: Int
    
    var instructions: String {
        switch simulation {
        case 0: return "Tap to plant seeds • Watch them grow"
        case 1: return "Tap clouds for rain • See water cycle in action"
        case 2: return "Tap bees to pollinate flowers • Create fruits"
        case 3: return "Add organic matter • Watch decomposition"
        default: return "Tap to interact"
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "hand.tap.fill")
                .font(.system(size: 20))
                .foregroundColor(AppColors.primaryGreen)
            
            Text(instructions)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground.opacity(0.95))
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

class PlantGrowthScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        size = view.bounds.size
        scaleMode = .resizeFill
        
        createGround()
        createSun()
        addInstructions()
    }
    
    func createGround() {
        let ground = SKSpriteNode(color: UIColor(red: 0.4, green: 0.3, blue: 0.2, alpha: 1), size: CGSize(width: size.width, height: 100))
        ground.position = CGPoint(x: size.width / 2, y: 50)
        addChild(ground)
    }
    
    func createSun() {
        let sun = SKShapeNode(circleOfRadius: 30)
        sun.fillColor = UIColor(red: 1, green: 0.84, blue: 0, alpha: 1)
        sun.strokeColor = .clear
        sun.position = CGPoint(x: size.width - 60, y: size.height - 60)
        sun.glowWidth = 10
        addChild(sun)
        
        let glow = SKShapeNode(circleOfRadius: 40)
        glow.fillColor = UIColor(red: 1, green: 0.84, blue: 0, alpha: 0.3)
        glow.strokeColor = .clear
        glow.position = sun.position
        addChild(glow)
        
        let pulse = SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 1.5),
            SKAction.scale(to: 1.0, duration: 1.5)
        ])
        glow.run(SKAction.repeatForever(pulse))
    }
    
    func addInstructions() {
        let label = SKLabelNode(text: "Tap anywhere to plant seeds")
        label.fontSize = 16
        label.fontColor = .white
        label.position = CGPoint(x: size.width / 2, y: 150)
        addChild(label)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if location.y < 150 {
            plantSeed(at: location)
        }
    }
    
    func plantSeed(at position: CGPoint) {
        let seed = SKShapeNode(circleOfRadius: 3)
        seed.fillColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)
        seed.position = position
        addChild(seed)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            seed.removeFromParent()
            self.growPlant(at: position)
        }
    }
    
    func growPlant(at position: CGPoint) {
        let stem = SKSpriteNode(color: UIColor(red: 0.2, green: 0.8, blue: 0.3, alpha: 1), size: CGSize(width: 4, height: 0))
        stem.position = position
        stem.anchorPoint = CGPoint(x: 0.5, y: 0)
        addChild(stem)
        
        let growStem = SKAction.resize(toHeight: 60, duration: 2.0)
        stem.run(growStem) {
            self.addLeaves(to: stem)
            self.addFlower(to: stem)
        }
    }
    
    func addLeaves(to stem: SKNode) {
        for i in 0..<3 {
            let leaf = SKShapeNode(ellipseOf: CGSize(width: 20, height: 10))
            leaf.fillColor = UIColor(red: 0.2, green: 0.8, blue: 0.3, alpha: 1)
            leaf.strokeColor = UIColor(red: 0.1, green: 0.6, blue: 0.2, alpha: 1)
            leaf.position = CGPoint(x: i % 2 == 0 ? -10 : 10, y: CGFloat(i) * 15 + 10)
            leaf.zRotation = i % 2 == 0 ? .pi / 6 : -.pi / 6
            stem.addChild(leaf)
            
            let sway = SKAction.sequence([
                SKAction.rotate(byAngle: 0.2, duration: 1.5),
                SKAction.rotate(byAngle: -0.2, duration: 1.5)
            ])
            leaf.run(SKAction.repeatForever(sway))
        }
    }
    
    func addFlower(to stem: SKNode) {
        let flower = SKShapeNode(circleOfRadius: 12)
        flower.fillColor = UIColor(red: 1, green: 0.2, blue: 0.4, alpha: 1)
        flower.strokeColor = .clear
        flower.position = CGPoint(x: 0, y: 60)
        stem.addChild(flower)
        
        for i in 0..<5 {
            let petal = SKShapeNode(ellipseOf: CGSize(width: 12, height: 20))
            petal.fillColor = UIColor(red: 1, green: 0.4, blue: 0.6, alpha: 1)
            petal.strokeColor = .clear
            petal.position = CGPoint(x: cos(CGFloat(i) * .pi * 2 / 5) * 15,
                                    y: sin(CGFloat(i) * .pi * 2 / 5) * 15)
            flower.addChild(petal)
        }
        
        let center = SKShapeNode(circleOfRadius: 5)
        center.fillColor = UIColor(red: 1, green: 0.84, blue: 0, alpha: 1)
        flower.addChild(center)
    }
}

class WaterCycleScene: SKScene {
    var clouds: [SKShapeNode] = []
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        size = view.bounds.size
        scaleMode = .resizeFill
        
        createOcean()
        createClouds()
        createMountains()
    }
    
    func createOcean() {
        let ocean = SKSpriteNode(color: UIColor(red: 0.2, green: 0.5, blue: 0.9, alpha: 0.7), size: CGSize(width: size.width, height: 120))
        ocean.position = CGPoint(x: size.width / 2, y: 60)
        addChild(ocean)
        
        let wave = SKAction.sequence([
            SKAction.moveBy(x: 0, y: 5, duration: 1.5),
            SKAction.moveBy(x: 0, y: -5, duration: 1.5)
        ])
        ocean.run(SKAction.repeatForever(wave))
        
        createEvaporation()
    }
    
    func createEvaporation() {
        let emitter = SKEmitterNode()
        emitter.particleTexture = SKTexture(imageNamed: "spark")
        emitter.particleBirthRate = 5
        emitter.particleLifetime = 3
        emitter.particleScale = 0.3
        emitter.particleScaleSpeed = -0.1
        emitter.particleAlpha = 0.6
        emitter.particleAlphaSpeed = -0.2
        emitter.particleColor = UIColor(red: 0.7, green: 0.9, blue: 1, alpha: 1)
        emitter.particleSpeed = 20
        emitter.particleSpeedRange = 10
        emitter.emissionAngle = .pi / 2
        emitter.emissionAngleRange = .pi / 4
        emitter.position = CGPoint(x: size.width / 2, y: 120)
        emitter.particlePositionRange = CGVector(dx: size.width, dy: 0)
        addChild(emitter)
    }
    
    func createClouds() {
        for i in 0..<3 {
            let cloud = createCloud()
            cloud.position = CGPoint(x: CGFloat(i + 1) * size.width / 4, y: size.height - 100)
            clouds.append(cloud)
            addChild(cloud)
            
            let float = SKAction.sequence([
                SKAction.moveBy(x: 20, y: 10, duration: 3),
                SKAction.moveBy(x: -20, y: -10, duration: 3)
            ])
            cloud.run(SKAction.repeatForever(float))
        }
    }
    
    func createCloud() -> SKShapeNode {
        let cloud = SKShapeNode()
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: 0, y: 0), radius: 20, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        path.addArc(center: CGPoint(x: 20, y: 0), radius: 25, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        path.addArc(center: CGPoint(x: 40, y: 0), radius: 20, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        cloud.path = path
        cloud.fillColor = UIColor(white: 1, alpha: 0.8)
        cloud.strokeColor = .clear
        return cloud
    }
    
    func createMountains() {
        let mountain = SKShapeNode()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 120))
        path.addLine(to: CGPoint(x: size.width / 3, y: 250))
        path.addLine(to: CGPoint(x: size.width / 2, y: 120))
        mountain.path = path
        mountain.fillColor = UIColor(red: 0.3, green: 0.5, blue: 0.3, alpha: 1)
        mountain.strokeColor = .clear
        addChild(mountain)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        for cloud in clouds {
            if cloud.contains(location) {
                makeItRain(from: cloud)
            }
        }
    }
    
    func makeItRain(from cloud: SKShapeNode) {
        let emitter = SKEmitterNode()
        emitter.particleTexture = SKTexture(imageNamed: "spark")
        emitter.particleBirthRate = 50
        emitter.particleLifetime = 2
        emitter.particleScale = 0.2
        emitter.particleColor = UIColor(red: 0.3, green: 0.6, blue: 1, alpha: 1)
        emitter.particleSpeed = 200
        emitter.particleSpeedRange = 50
        emitter.emissionAngle = -.pi / 2
        emitter.emissionAngleRange = .pi / 8
        emitter.position = CGPoint(x: 20, y: -20)
        emitter.particlePositionRange = CGVector(dx: 40, dy: 0)
        cloud.addChild(emitter)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            emitter.removeFromParent()
        }
    }
}

class PollinationScene: SKScene {
    var flowers: [SKNode] = []
    var bees: [SKNode] = []
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        size = view.bounds.size
        scaleMode = .resizeFill
        
        createFlowers()
        createBees()
    }
    
    func createFlowers() {
        for i in 0..<5 {
            let flower = createFlower()
            flower.position = CGPoint(x: CGFloat(i + 1) * size.width / 6, y: 150)
            flowers.append(flower)
            addChild(flower)
        }
    }
    
    func createFlower() -> SKNode {
        let container = SKNode()
        
        let stem = SKSpriteNode(color: UIColor(red: 0.2, green: 0.8, blue: 0.3, alpha: 1), size: CGSize(width: 3, height: 50))
        stem.anchorPoint = CGPoint(x: 0.5, y: 0)
        container.addChild(stem)
        
        let flowerHead = SKShapeNode(circleOfRadius: 15)
        flowerHead.fillColor = UIColor(red: 1, green: 0.6, blue: 0.8, alpha: 1)
        flowerHead.strokeColor = .clear
        flowerHead.position = CGPoint(x: 0, y: 50)
        flowerHead.name = "flowerHead"
        container.addChild(flowerHead)
        
        let center = SKShapeNode(circleOfRadius: 5)
        center.fillColor = UIColor(red: 1, green: 0.84, blue: 0, alpha: 1)
        center.name = "pollen"
        flowerHead.addChild(center)
        
        return container
    }
    
    func createBees() {
        for _ in 0..<3 {
            let bee = createBee()
            bee.position = CGPoint(x: CGFloat.random(in: 50...size.width - 50),
                                  y: size.height - 100)
            bees.append(bee)
            addChild(bee)
            
            animateBee(bee)
        }
    }
    
    func createBee() -> SKNode {
        let container = SKNode()
        
        let body = SKShapeNode(ellipseOf: CGSize(width: 20, height: 12))
        body.fillColor = UIColor(red: 1, green: 0.84, blue: 0, alpha: 1)
        body.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        body.lineWidth = 1
        container.addChild(body)
        
        for i in 0..<2 {
            let stripe = SKSpriteNode(color: .black, size: CGSize(width: 2, height: 12))
            stripe.position = CGPoint(x: CGFloat(i - 1) * 6, y: 0)
            container.addChild(stripe)
        }
        
        for i in 0..<2 {
            let wing = SKShapeNode(ellipseOf: CGSize(width: 12, height: 8))
            wing.fillColor = UIColor(white: 1, alpha: 0.5)
            wing.strokeColor = UIColor(white: 0.8, alpha: 0.8)
            wing.position = CGPoint(x: i == 0 ? -8 : 8, y: 4)
            container.addChild(wing)
            
            let flap = SKAction.sequence([
                SKAction.scaleY(to: 0.5, duration: 0.1),
                SKAction.scaleY(to: 1.0, duration: 0.1)
            ])
            wing.run(SKAction.repeatForever(flap))
        }
        
        return container
    }
    
    func animateBee(_ bee: SKNode) {
        let randomX = CGFloat.random(in: 50...size.width - 50)
        let randomY = CGFloat.random(in: 200...size.height - 100)
        
        let move = SKAction.move(to: CGPoint(x: randomX, y: randomY), duration: 3)
        let wait = SKAction.wait(forDuration: 0.5)
        
        bee.run(SKAction.sequence([move, wait])) {
            self.animateBee(bee)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        for bee in bees {
            if bee.contains(location) {
                pollinateNearestFlower(bee: bee)
            }
        }
    }
    
    func pollinateNearestFlower(bee: SKNode) {
        guard let nearestFlower = flowers.min(by: {
            let dist1 = hypot($0.position.x - bee.position.x, $0.position.y - bee.position.y)
            let dist2 = hypot($1.position.x - bee.position.x, $1.position.y - bee.position.y)
            return dist1 < dist2
        }) else { return }
        
        let move = SKAction.move(to: nearestFlower.position, duration: 1)
        bee.removeAllActions()
        bee.run(move) {
            self.createFruit(at: nearestFlower)
            self.animateBee(bee)
        }
    }
    
    func createFruit(at flower: SKNode) {
        guard let flowerHead = flower.childNode(withName: "flowerHead") else { return }
        
        let fruit = SKShapeNode(circleOfRadius: 8)
        fruit.fillColor = UIColor(red: 1, green: 0.2, blue: 0.2, alpha: 1)
        fruit.strokeColor = .clear
        fruit.position = CGPoint(x: 0, y: -10)
        flowerHead.addChild(fruit)
        
        fruit.setScale(0)
        fruit.run(SKAction.scale(to: 1, duration: 0.5))
    }
}

class CompostingScene: SKScene {
    var compostPile: SKNode!
    var decompositionLevel = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        size = view.bounds.size
        scaleMode = .resizeFill
        
        createCompostBin()
        createIngredients()
    }
    
    func createCompostBin() {
        compostPile = SKNode()
        compostPile.position = CGPoint(x: size.width / 2, y: 150)
        addChild(compostPile)
        
        let bin = SKShapeNode(rect: CGRect(x: -100, y: 0, width: 200, height: 150), cornerRadius: 10)
        bin.strokeColor = UIColor(red: 0.4, green: 0.3, blue: 0.2, alpha: 1)
        bin.lineWidth = 3
        bin.fillColor = UIColor(red: 0.3, green: 0.2, blue: 0.1, alpha: 0.3)
        compostPile.addChild(bin)
    }
    
    func createIngredients() {
        let ingredients = [
            ("leaf.fill", UIColor.green),
            ("carrot.fill", UIColor.orange),
            ("cup.and.saucer.fill", UIColor.brown)
        ]
        
        var xPos: CGFloat = 80
        
        for (icon, color) in ingredients {
            let item = createIngredientButton(icon: icon, color: color)
            item.position = CGPoint(x: xPos, y: size.height - 100)
            addChild(item)
            xPos += 100
        }
    }
    
    func createIngredientButton(icon: String, color: UIColor) -> SKNode {
        let container = SKNode()
        
        let circle = SKShapeNode(circleOfRadius: 30)
        circle.fillColor = color.withAlphaComponent(0.3)
        circle.strokeColor = color
        circle.lineWidth = 2
        circle.name = "ingredient"
        container.addChild(circle)
        
        return container
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let nodes = self.nodes(at: location)
        
        for node in nodes {
            if node.name == "ingredient" {
                addToCompost(at: location)
            }
        }
    }
    
    func addToCompost(at location: CGPoint) {
        let colors: [UIColor] = [.green, .brown, UIColor(red: 1, green: 0.6, blue: 0, alpha: 1)]
        let color = colors.randomElement() ?? .brown
        
        let item = SKShapeNode(circleOfRadius: CGFloat.random(in: 5...10))
        item.fillColor = color
        item.strokeColor = .clear
        item.position = location
        addChild(item)
        
        let targetY = compostPile.position.y + CGFloat.random(in: 20...100)
        let targetX = compostPile.position.x + CGFloat.random(in: -80...80)
        
        let move = SKAction.move(to: CGPoint(x: targetX, y: targetY), duration: 0.5)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let scale = SKAction.scale(to: 0.5, duration: 0.5)
        
        item.run(SKAction.group([move, fadeOut, scale])) {
            item.removeFromParent()
            self.decompose()
        }
    }
    
    func decompose() {
        decompositionLevel += 1
        
        if decompositionLevel % 5 == 0 {
            createSoil()
        }
    }
    
    func createSoil() {
        let soil = SKShapeNode(rect: CGRect(x: -80, y: 10, width: 160, height: 20))
        soil.fillColor = UIColor(red: 0.2, green: 0.1, blue: 0.05, alpha: 1)
        soil.strokeColor = .clear
        compostPile.addChild(soil)
        
        soil.alpha = 0
        soil.run(SKAction.fadeIn(withDuration: 1))
    }
}
