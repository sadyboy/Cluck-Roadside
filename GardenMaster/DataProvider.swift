import Foundation

class DataProvider {
    static func getLessons() -> [Lesson] {
        return [
            Lesson(
                id: "lesson1",
                title: "Introduction to Gardening",
                icon: "leaf.fill",
                difficulty: .beginner,
                xpReward: 50,
                estimatedTime: "10 min",
                contentBlocks: [
                    ContentBlock(id: "1", type: .heading, content: "Welcome to Gardening"),
                    ContentBlock(id: "2", type: .text, content: "Gardening is the practice of growing and cultivating plants as part of horticulture. Gardens may be designed for aesthetic purposes, for the production of food, or for both."),
                    ContentBlock(id: "3", type: .fact, content: "Did you know? Gardens have been around for over 4,000 years!"),
                    ContentBlock(id: "4", type: .heading, content: "Why Garden?"),
                    ContentBlock(id: "5", type: .text, content: "Gardening provides fresh produce, improves mental health, creates habitats for wildlife, and helps combat climate change by absorbing CO2."),
                    ContentBlock(id: "6", type: .formula, content: "Healthy Garden = Good Soil + Water + Sunlight + Care"),
                    ContentBlock(id: "7", type: .heading, content: "Types of Gardens"),
                    ContentBlock(id: "8", type: .text, content: "Common types include vegetable gardens, flower gardens, herb gardens, container gardens, and raised bed gardens."),
                    ContentBlock(id: "9", type: .fact, content: "Container gardens are perfect for beginners and small spaces!"),
                    ContentBlock(id: "10", type: .text, content: "Each type of garden has unique requirements and benefits. Choose based on your space, time, and goals."),
                ]
            ),
            Lesson(
                id: "lesson2",
                title: "Understanding Soil",
                icon: "mountain.2.fill",
                difficulty: .beginner,
                xpReward: 50,
                estimatedTime: "12 min",
                contentBlocks: [
                    ContentBlock(id: "1", type: .heading, content: "Soil Basics"),
                    ContentBlock(id: "2", type: .text, content: "Soil is the foundation of any garden. It provides nutrients, water, and support for plant roots. Understanding your soil type is crucial for success."),
                    ContentBlock(id: "3", type: .heading, content: "Soil Types"),
                    ContentBlock(id: "4", type: .text, content: "The three main soil types are clay, sand, and loam. Clay retains water but drains poorly. Sand drains quickly but holds few nutrients. Loam is the ideal balance."),
                    ContentBlock(id: "5", type: .formula, content: "Loam = 40% Sand + 40% Silt + 20% Clay"),
                    ContentBlock(id: "6", type: .fact, content: "One tablespoon of soil contains more organisms than there are people on Earth!"),
                    ContentBlock(id: "7", type: .heading, content: "Soil pH"),
                    ContentBlock(id: "8", type: .text, content: "pH measures acidity or alkalinity on a scale of 0-14. Most vegetables prefer slightly acidic soil (pH 6.0-7.0)."),
                    ContentBlock(id: "9", type: .text, content: "You can test soil pH with inexpensive kits from garden centers. Adjust pH by adding lime (raise) or sulfur (lower)."),
                    ContentBlock(id: "10", type: .fact, content: "Blueberries love acidic soil with pH 4.5-5.5!"),
                    ContentBlock(id: "11", type: .heading, content: "Improving Soil"),
                    ContentBlock(id: "12", type: .text, content: "Add organic matter like compost, aged manure, or leaf mold to improve any soil type. This increases nutrients, improves structure, and supports beneficial microorganisms."),
                ]
            ),
            Lesson(
                id: "lesson3",
                title: "Watering Techniques",
                icon: "drop.fill",
                difficulty: .intermediate,
                xpReward: 75,
                estimatedTime: "15 min",
                contentBlocks: [
                    ContentBlock(id: "1", type: .heading, content: "Water Fundamentals"),
                    ContentBlock(id: "2", type: .text, content: "Water is essential for photosynthesis, nutrient transport, and plant structure. However, both overwatering and underwatering can harm plants."),
                    ContentBlock(id: "3", type: .formula, content: "Most vegetables need 1-2 inches of water per week"),
                    ContentBlock(id: "4", type: .heading, content: "When to Water"),
                    ContentBlock(id: "5", type: .text, content: "Early morning is the best time to water. This reduces evaporation and allows foliage to dry before nightfall, preventing disease."),
                    ContentBlock(id: "6", type: .fact, content: "Watering at night can promote fungal diseases!"),
                    ContentBlock(id: "7", type: .heading, content: "Watering Methods"),
                    ContentBlock(id: "8", type: .text, content: "Drip irrigation delivers water directly to roots, reducing waste. Soaker hoses are great for rows. Sprinklers work for large areas but waste more water."),
                    ContentBlock(id: "9", type: .text, content: "Hand watering gives you control and lets you inspect plants, but it's time-consuming for large gardens."),
                    ContentBlock(id: "10", type: .fact, content: "Drip irrigation can save up to 50% more water than sprinklers!"),
                    ContentBlock(id: "11", type: .heading, content: "Signs of Water Stress"),
                    ContentBlock(id: "12", type: .text, content: "Wilting, yellow leaves, and stunted growth indicate problems. Check soil moisture 2 inches deep before watering."),
                ]
            ),
            Lesson(
                id: "lesson4",
                title: "Composting Mastery",
                icon: "arrow.3.trianglepath",
                difficulty: .intermediate,
                xpReward: 75,
                estimatedTime: "14 min",
                contentBlocks: [
                    ContentBlock(id: "1", type: .heading, content: "What is Composting?"),
                    ContentBlock(id: "2", type: .text, content: "Composting is the natural process of recycling organic matter into nutrient-rich soil amendment. It reduces waste and creates 'black gold' for your garden."),
                    ContentBlock(id: "3", type: .formula, content: "Compost = Greens (Nitrogen) + Browns (Carbon) + Air + Water"),
                    ContentBlock(id: "4", type: .heading, content: "Greens vs Browns"),
                    ContentBlock(id: "5", type: .text, content: "Greens include fresh grass clippings, vegetable scraps, and coffee grounds. Browns include dry leaves, straw, and cardboard."),
                    ContentBlock(id: "6", type: .fact, content: "The ideal carbon to nitrogen ratio is 30:1!"),
                    ContentBlock(id: "7", type: .heading, content: "Building Your Pile"),
                    ContentBlock(id: "8", type: .text, content: "Layer greens and browns in roughly equal volumes. Keep the pile as moist as a wrung-out sponge. Turn every 1-2 weeks to add oxygen."),
                    ContentBlock(id: "9", type: .text, content: "A hot compost pile (140-160°F) will break down in 4-6 weeks. Cold composting takes 6-12 months but requires less effort."),
                    ContentBlock(id: "10", type: .fact, content: "Hot composting kills weed seeds and pathogens!"),
                    ContentBlock(id: "11", type: .heading, content: "Using Finished Compost"),
                    ContentBlock(id: "12", type: .text, content: "Compost is ready when it's dark, crumbly, and smells earthy. Use it as mulch, mix into planting holes, or make compost tea for liquid fertilizer."),
                ]
            ),
            Lesson(
                id: "lesson5",
                title: "Pest Management",
                icon: "ant.fill",
                difficulty: .intermediate,
                xpReward: 75,
                estimatedTime: "13 min",
                contentBlocks: [
                    ContentBlock(id: "1", type: .heading, content: "Integrated Pest Management"),
                    ContentBlock(id: "2", type: .text, content: "IPM uses multiple strategies to control pests while minimizing harm to beneficial insects and the environment."),
                    ContentBlock(id: "3", type: .heading, content: "Prevention First"),
                    ContentBlock(id: "4", type: .text, content: "Healthy plants resist pests better. Use proper spacing, rotate crops, choose resistant varieties, and maintain soil health."),
                    ContentBlock(id: "5", type: .fact, content: "Companion planting can naturally repel pests!"),
                    ContentBlock(id: "6", type: .heading, content: "Beneficial Insects"),
                    ContentBlock(id: "7", type: .text, content: "Ladybugs eat aphids, lacewings consume many soft-bodied pests, and ground beetles eat slugs and caterpillars."),
                    ContentBlock(id: "8", type: .text, content: "Attract beneficials by planting flowers like yarrow, dill, and sweet alyssum. Avoid broad-spectrum pesticides that kill all insects."),
                    ContentBlock(id: "9", type: .fact, content: "One ladybug can eat 50 aphids per day!"),
                    ContentBlock(id: "10", type: .heading, content: "Organic Controls"),
                    ContentBlock(id: "11", type: .text, content: "Hand-picking works for large pests. Neem oil controls many insects. Diatomaceous earth creates a barrier against soft-bodied pests."),
                    ContentBlock(id: "12", type: .formula, content: "Best Defense = Prevention + Monitoring + Targeted Action"),
                ]
            ),
            Lesson(
                id: "lesson6",
                title: "Seasonal Planning",
                icon: "calendar",
                difficulty: .advanced,
                xpReward: 100,
                estimatedTime: "18 min",
                contentBlocks: [
                    ContentBlock(id: "1", type: .heading, content: "Understanding Seasons"),
                    ContentBlock(id: "2", type: .text, content: "Successful gardening requires planning around your local climate and frost dates. Know your USDA hardiness zone and first/last frost dates."),
                    ContentBlock(id: "3", type: .formula, content: "Growing Season = Days between Last Spring Frost and First Fall Frost"),
                    ContentBlock(id: "4", type: .heading, content: "Spring Planting"),
                    ContentBlock(id: "5", type: .text, content: "Start cool-season crops like lettuce, peas, and broccoli 2-4 weeks before last frost. Warm-season crops like tomatoes and peppers go out after frost danger passes."),
                    ContentBlock(id: "6", type: .fact, content: "Some seeds can be started indoors 6-8 weeks before transplanting!"),
                    ContentBlock(id: "7", type: .heading, content: "Summer Maintenance"),
                    ContentBlock(id: "8", type: .text, content: "Focus on watering, weeding, and harvesting. Start succession planting for continuous harvests. Plant fall crops in mid to late summer."),
                    ContentBlock(id: "9", type: .text, content: "Mulch heavily to conserve moisture and suppress weeds. Provide shade for heat-sensitive crops during extreme temperatures."),
                    ContentBlock(id: "10", type: .heading, content: "Fall Extension"),
                    ContentBlock(id: "11", type: .text, content: "Use row covers, cold frames, or greenhouses to extend the season. Many crops taste better after light frost."),
                    ContentBlock(id: "12", type: .fact, content: "Kale and Brussels sprouts become sweeter after frost!"),
                ]
            ),
            Lesson(
                id: "lesson7",
                title: "Advanced Propagation",
                icon: "leaf.arrow.circlepath",
                difficulty: .advanced,
                xpReward: 100,
                estimatedTime: "16 min",
                contentBlocks: [
                    ContentBlock(id: "1", type: .heading, content: "Propagation Methods"),
                    ContentBlock(id: "2", type: .text, content: "Propagation is creating new plants from existing ones. Methods include seeds, cuttings, division, layering, and grafting."),
                    ContentBlock(id: "3", type: .heading, content: "Seed Saving"),
                    ContentBlock(id: "4", type: .text, content: "Save seeds from open-pollinated or heirloom varieties, not hybrids. Allow fruits to fully ripen, extract seeds, dry thoroughly, and store in cool, dark, dry conditions."),
                    ContentBlock(id: "5", type: .fact, content: "Some seeds remain viable for over 10 years when stored properly!"),
                    ContentBlock(id: "6", type: .heading, content: "Stem Cuttings"),
                    ContentBlock(id: "7", type: .text, content: "Take 4-6 inch cuttings from healthy plants. Remove lower leaves, dip in rooting hormone, and place in moist growing medium. Keep humid until roots develop."),
                    ContentBlock(id: "8", type: .text, content: "Softwood cuttings (spring) root fastest. Hardwood cuttings (winter) work for woody plants."),
                    ContentBlock(id: "9", type: .fact, content: "Many herbs root easily in just a glass of water!"),
                    ContentBlock(id: "10", type: .heading, content: "Division"),
                    ContentBlock(id: "11", type: .text, content: "Divide perennials every 3-5 years to maintain vigor. Dig up the plant, separate into sections with roots, and replant immediately."),
                    ContentBlock(id: "12", type: .formula, content: "Best Time to Divide = Early Spring or Fall"),
                ]
            ),
            Lesson(
                id: "lesson8",
                title: "Permaculture Principles",
                icon: "globe.americas.fill",
                difficulty: .advanced,
                xpReward: 100,
                estimatedTime: "20 min",
                contentBlocks: [
                    ContentBlock(id: "1", type: .heading, content: "What is Permaculture?"),
                    ContentBlock(id: "2", type: .text, content: "Permaculture designs sustainable human habitats by following nature's patterns. It creates productive ecosystems with diversity, stability, and resilience."),
                    ContentBlock(id: "3", type: .formula, content: "Permaculture = Permanent + Agriculture + Culture"),
                    ContentBlock(id: "4", type: .heading, content: "Core Ethics"),
                    ContentBlock(id: "5", type: .text, content: "The three ethics are: Care for Earth, Care for People, and Fair Share. These guide all design decisions."),
                    ContentBlock(id: "6", type: .heading, content: "Design Principles"),
                    ContentBlock(id: "7", type: .text, content: "Observe and interact with your site. Capture and store energy. Obtain a yield. Apply self-regulation. Use renewable resources. Produce no waste."),
                    ContentBlock(id: "8", type: .fact, content: "A permaculture garden can produce more food per square foot than conventional farming!"),
                    ContentBlock(id: "9", type: .heading, content: "Zones and Sectors"),
                    ContentBlock(id: "10", type: .text, content: "Zone 0 is your home. Zone 1 includes herbs and salads needing daily care. Zone 5 is wild nature. Place elements based on frequency of use."),
                    ContentBlock(id: "11", type: .text, content: "Sectors map external energies like sun, wind, and water flow. Design to capture beneficial energies and deflect harmful ones."),
                    ContentBlock(id: "12", type: .fact, content: "Guild planting mimics natural plant communities for mutual benefit!"),
                ]
            ),
        ]
    }
    
    static func getFlashcards() -> [Flashcard] {
        return [
            Flashcard(id: "1", term: "Photosynthesis", definition: "The process by which plants use sunlight, water, and carbon dioxide to produce oxygen and energy in the form of sugar.", category: "Plant Biology", icon: "sun.max.fill"),
            Flashcard(id: "2", term: "Germination", definition: "The process by which a plant grows from a seed into a seedling.", category: "Growth", icon: "leaf.fill"),
            Flashcard(id: "3", term: "Mulch", definition: "A layer of material applied to the soil surface to conserve moisture, improve fertility, reduce weeds, and regulate temperature.", category: "Soil", icon: "rectangle.stack.fill"),
            Flashcard(id: "4", term: "Hardening Off", definition: "Gradually exposing seedlings started indoors to outdoor conditions before transplanting.", category: "Techniques", icon: "arrow.left.arrow.right"),
            Flashcard(id: "5", term: "Nitrogen", definition: "An essential nutrient for leafy growth, part of chlorophyll, and crucial for photosynthesis.", category: "Nutrients", icon: "n.circle.fill"),
            Flashcard(id: "6", term: "Companion Planting", definition: "Growing different plants together for mutual benefit, such as pest control or improved growth.", category: "Techniques", icon: "person.2.fill"),
            Flashcard(id: "7", term: "Loam", definition: "The ideal soil type with balanced mixture of sand, silt, and clay, providing good drainage and nutrient retention.", category: "Soil", icon: "mountain.2.fill"),
            Flashcard(id: "8", term: "Frost Date", definition: "The average date of the last spring frost or first fall frost in your area, used for planting timing.", category: "Seasons", icon: "thermometer.snowflake"),
            Flashcard(id: "9", term: "Pollination", definition: "The transfer of pollen from male to female flower parts, necessary for fruit and seed production.", category: "Plant Biology", icon: "sparkles"),
            Flashcard(id: "10", term: "Heirloom", definition: "Open-pollinated plant varieties passed down through generations, breeding true from seed.", category: "Varieties", icon: "gift.fill"),
            Flashcard(id: "11", term: "Bolting", definition: "When a plant prematurely produces flowers and seeds, often triggered by heat or stress.", category: "Growth", icon: "arrow.up"),
            Flashcard(id: "12", term: "pH", definition: "A measure of soil acidity or alkalinity on a scale of 0-14, affecting nutrient availability.", category: "Soil", icon: "chart.bar.fill"),
            Flashcard(id: "13", term: "Deadheading", definition: "Removing spent flowers to encourage more blooms and prevent seed formation.", category: "Maintenance", icon: "scissors"),
            Flashcard(id: "14", term: "Compost", definition: "Decomposed organic matter used to enrich soil with nutrients and beneficial microorganisms.", category: "Soil", icon: "arrow.3.trianglepath"),
            Flashcard(id: "15", term: "Transpiration", definition: "The process of water movement through a plant and its evaporation from leaves, stems, and flowers.", category: "Plant Biology", icon: "drop.fill"),
            Flashcard(id: "16", term: "Succession Planting", definition: "Planting crops at intervals for continuous harvest throughout the growing season.", category: "Techniques", icon: "calendar"),
            Flashcard(id: "17", term: "Rootbound", definition: "When a plant's roots circle the container and have no room to grow, restricting development.", category: "Growth", icon: "arrow.turn.down.right"),
            Flashcard(id: "18", term: "Humus", definition: "The dark, organic material in soil formed from decomposed plant and animal matter.", category: "Soil", icon: "circle.fill"),
            Flashcard(id: "19", term: "Chlorophyll", definition: "The green pigment in plants that absorbs light energy for photosynthesis.", category: "Plant Biology", icon: "paintbrush.fill"),
            Flashcard(id: "20", term: "Microclimate", definition: "A small area with climate conditions different from the surrounding area, affecting what you can grow.", category: "Environment", icon: "cloud.sun.fill"),
            Flashcard(id: "21", term: "Perennial", definition: "A plant that lives for more than two years, returning each growing season.", category: "Varieties", icon: "infinity"),
            Flashcard(id: "22", term: "Annual", definition: "A plant that completes its life cycle in one growing season.", category: "Varieties", icon: "1.circle.fill"),
            Flashcard(id: "23", term: "Tilth", definition: "The physical condition of soil in relation to its ease of cultivation and plant growth.", category: "Soil", icon: "hand.raised.fill"),
        ]
    }
    
    static func getTests() -> [Test] {
        return [
            Test(
                id: "test1",
                title: "Gardening Basics",
                category: "Fundamentals",
                icon: "book.fill",
                questions: [
                    Question(id: "q1", question: "What are the three main soil types?", options: ["Clay, Sand, Loam", "Dirt, Mud, Rocks", "Black, Brown, Red", "Wet, Dry, Medium"], correctAnswer: 0),
                    Question(id: "q2", question: "When is the best time to water plants?", options: ["Noon", "Early morning", "Late evening", "Midnight"], correctAnswer: 1),
                    Question(id: "q3", question: "What does pH measure in soil?", options: ["Water content", "Nutrient levels", "Acidity or alkalinity", "Temperature"], correctAnswer: 2),
                    Question(id: "q4", question: "How much water do most vegetables need per week?", options: ["1-2 inches", "5-6 inches", "10 inches", "No specific amount"], correctAnswer: 0),
                    Question(id: "q5", question: "What is the ideal soil type for most gardens?", options: ["Pure clay", "Pure sand", "Loam", "Gravel"], correctAnswer: 2),
                ],
                passingScore: 3
            ),
            Test(
                id: "test2",
                title: "Composting Knowledge",
                category: "Soil Health",
                icon: "arrow.3.trianglepath",
                questions: [
                    Question(id: "q1", question: "What is the ideal carbon to nitrogen ratio in compost?", options: ["10:1", "20:1", "30:1", "50:1"], correctAnswer: 2),
                    Question(id: "q2", question: "Which is considered a 'green' compost material?", options: ["Dry leaves", "Cardboard", "Grass clippings", "Straw"], correctAnswer: 2),
                    Question(id: "q3", question: "How long does hot composting typically take?", options: ["1-2 weeks", "4-6 weeks", "6 months", "1 year"], correctAnswer: 1),
                    Question(id: "q4", question: "What temperature range indicates hot composting?", options: ["60-80°F", "140-160°F", "200-220°F", "32-40°F"], correctAnswer: 1),
                    Question(id: "q5", question: "How moist should a compost pile be?", options: ["Bone dry", "Like a wrung-out sponge", "Soaking wet", "Slightly damp"], correctAnswer: 1),
                ],
                passingScore: 3
            ),
            Test(
                id: "test3",
                title: "Plant Biology",
                category: "Science",
                icon: "leaf.fill",
                questions: [
                    Question(id: "q1", question: "What is photosynthesis?", options: ["Plants drinking water", "Plants creating energy from sunlight", "Plants growing roots", "Plants flowering"], correctAnswer: 1),
                    Question(id: "q2", question: "What is germination?", options: ["Flower production", "Seed sprouting", "Leaf falling", "Fruit ripening"], correctAnswer: 1),
                    Question(id: "q3", question: "What is transpiration?", options: ["Water movement through plants", "Seed dispersal", "Root growth", "Photosynthesis"], correctAnswer: 0),
                    Question(id: "q4", question: "What gives plants their green color?", options: ["Water", "Chlorophyll", "Oxygen", "Carbon dioxide"], correctAnswer: 1),
                    Question(id: "q5", question: "What is pollination?", options: ["Watering plants", "Transfer of pollen", "Pruning flowers", "Planting seeds"], correctAnswer: 1),
                ],
                passingScore: 3
            ),
            Test(
                id: "test4",
                title: "Pest Management",
                category: "Plant Health",
                icon: "ant.fill",
                questions: [
                    Question(id: "q1", question: "What does IPM stand for?", options: ["Insect Pest Management", "Integrated Pest Management", "Immediate Pest Mitigation", "Indoor Plant Maintenance"], correctAnswer: 1),
                    Question(id: "q2", question: "Which is a beneficial insect?", options: ["Aphid", "Ladybug", "Cabbage worm", "Japanese beetle"], correctAnswer: 1),
                    Question(id: "q3", question: "How many aphids can one ladybug eat per day?", options: ["5", "15", "50", "100"], correctAnswer: 2),
                    Question(id: "q4", question: "What is companion planting used for?", options: ["Looking pretty", "Natural pest control", "Wasting space", "Confusing gardeners"], correctAnswer: 1),
                    Question(id: "q5", question: "Which is an organic pest control method?", options: ["Chemical pesticides", "Neem oil", "Bleach", "Gasoline"], correctAnswer: 1),
                ],
                passingScore: 3
            ),
            Test(
                id: "test5",
                title: "Seasonal Planning",
                category: "Planning",
                icon: "calendar",
                questions: [
                    Question(id: "q1", question: "What defines your growing season?", options: ["Days between frosts", "Summer months", "When it's warm", "January to December"], correctAnswer: 0),
                    Question(id: "q2", question: "When should warm-season crops be planted?", options: ["Before last frost", "After frost danger passes", "In winter", "Anytime"], correctAnswer: 1),
                    Question(id: "q3", question: "Which crop tastes better after frost?", options: ["Tomatoes", "Kale", "Cucumbers", "Peppers"], correctAnswer: 1),
                    Question(id: "q4", question: "When is the best time to plant cool-season crops?", options: ["Mid-summer", "2-4 weeks before last frost", "December", "After first frost"], correctAnswer: 1),
                    Question(id: "q5", question: "What extends the growing season?", options: ["Ignoring frost", "Row covers", "Doing nothing", "Planting less"], correctAnswer: 1),
                ],
                passingScore: 3
            ),
            Test(
                id: "test6",
                title: "Advanced Techniques",
                category: "Expert Level",
                icon: "graduationcap.fill",
                questions: [
                    Question(id: "q1", question: "What is propagation?", options: ["Watering", "Creating new plants", "Harvesting", "Weeding"], correctAnswer: 1),
                    Question(id: "q2", question: "How often should perennials be divided?", options: ["Every year", "Every 3-5 years", "Never", "Every 10 years"], correctAnswer: 1),
                    Question(id: "q3", question: "What are the three permaculture ethics?", options: ["Dig, Plant, Water", "Care for Earth, People, Fair Share", "Buy, Sell, Trade", "Work, Rest, Play"], correctAnswer: 1),
                    Question(id: "q4", question: "What is Zone 0 in permaculture?", options: ["Wild nature", "Your home", "The compost", "The street"], correctAnswer: 1),
                    Question(id: "q5", question: "What type of cuttings root fastest?", options: ["Hardwood", "Softwood", "Medium wood", "No wood"], correctAnswer: 1),
                ],
                passingScore: 3
            ),
        ]
    }
    
    static func getExperts() -> [Expert] {
        return [
            Expert(
                id: "expert1",
                name: "Luther Burbank",
                yearBorn: "1849",
                yearDied: "1926",
                biography: "Luther Burbank was an American botanist, horticulturist, and pioneer in agricultural science. He developed more than 800 strains and varieties of plants over his 55-year career. Burbank's work had a significant impact on agricultural practices and plant breeding. He believed that plants could be improved through selective breeding and hybridization, applying scientific principles to horticulture in revolutionary ways. His contributions to agriculture continue to influence modern plant breeding and genetic research.",
                contributions: [
                    "Developed over 800 plant varieties and strains",
                    "Created the Russet Burbank potato, still widely grown today",
                    "Pioneered scientific plant breeding techniques",
                    "Improved many fruit trees including plums and berries",
                    "Advanced understanding of plant genetics before modern genetics existed"
                ],
                discoveries: [
                    Discovery(id: "d1", title: "Russet Burbank Potato", year: "1902", description: "Created the most commercially successful potato variety in America, known for its disease resistance and excellent baking qualities."),
                    Discovery(id: "d2", title: "Shasta Daisy", year: "1890s", description: "Developed this popular ornamental flower by crossing multiple daisy species to create larger, more vibrant blooms."),
                    Discovery(id: "d3", title: "Santa Rosa Plum", year: "1906", description: "Bred this sweet, flavorful plum variety that became one of the most popular cultivars in California.")
                ],
                quote: "I shall be content if, because of me, there shall be better fruits and fairer flowers.",
                icon: "leaf.fill"
            ),
            Expert(
                id: "expert2",
                name: "George Washington Carver",
                yearBorn: "1864",
                yearDied: "1943",
                biography: "George Washington Carver was an American agricultural scientist and inventor who promoted alternative crops to cotton and methods to prevent soil depletion. Born into slavery, he became one of the most prominent scientists of his time. Carver's research on peanuts, sweet potatoes, and other crops helped poor Southern farmers diversify their crops and improve their livelihoods. He developed hundreds of products from peanuts and sweet potatoes, demonstrating the economic potential of these crops and helping to revolutionize Southern agriculture.",
                contributions: [
                    "Developed 300+ products from peanuts",
                    "Promoted crop rotation to restore soil nutrients",
                    "Created 100+ products from sweet potatoes",
                    "Advanced sustainable agricultural practices",
                    "Helped Southern farmers overcome cotton dependency"
                ],
                discoveries: [
                    Discovery(id: "d1", title: "Crop Rotation Benefits", year: "1900s", description: "Demonstrated how alternating crops like peanuts and sweet potatoes with cotton could restore soil nitrogen and improve yields."),
                    Discovery(id: "d2", title: "Peanut Products", year: "1910s", description: "Invented over 300 uses for peanuts including dyes, plastics, gasoline, and cosmetics."),
                    Discovery(id: "d3", title: "Sweet Potato Innovations", year: "1920s", description: "Created more than 100 products from sweet potatoes including flour, vinegar, and rubber.")
                ],
                quote: "Where there is no vision, there is no hope.",
                icon: "star.fill"
            ),
            Expert(
                id: "expert3",
                name: "Masanobu Fukuoka",
                yearBorn: "1913",
                yearDied: "2008",
                biography: "Masanobu Fukuoka was a Japanese farmer and philosopher who developed natural farming methods that inspired the permaculture movement. After working as a soil scientist, he rejected modern agricultural practices and spent decades perfecting a 'do-nothing' farming approach. His philosophy emphasized working with nature rather than against it, avoiding tillage, fertilizers, and pesticides while achieving impressive yields. Fukuoka's books, especially 'The One-Straw Revolution,' influenced organic farming and sustainable agriculture movements worldwide.",
                contributions: [
                    "Pioneered natural farming techniques",
                    "Developed no-till farming methods",
                    "Inspired the global permaculture movement",
                    "Wrote influential books on sustainable agriculture",
                    "Demonstrated that nature-based farming could be productive"
                ],
                discoveries: [
                    Discovery(id: "d1", title: "Natural Farming Philosophy", year: "1940s", description: "Developed a farming system requiring no tillage, no fertilizers, no weeding, and no pesticides."),
                    Discovery(id: "d2", title: "Clay Seed Balls", year: "1950s", description: "Invented nendo dango (clay seed balls) for broadcasting seeds without plowing."),
                    Discovery(id: "d3", title: "The One-Straw Revolution", year: "1975", description: "Published his groundbreaking book describing natural farming methods and philosophy.")
                ],
                quote: "The ultimate goal of farming is not the growing of crops, but the cultivation and perfection of human beings.",
                icon: "globe.americas.fill"
            ),
            Expert(
                id: "expert4",
                name: "Beatrix Farrand",
                yearBorn: "1872",
                yearDied: "1959",
                biography: "Beatrix Farrand was America's first female landscape architect and one of the founding members of the American Society of Landscape Architects. She designed over 200 gardens for private estates, universities, and public spaces. Farrand combined artistic vision with extensive botanical knowledge, creating landscapes that were both beautiful and ecologically sound. Her designs at Dumbarton Oaks in Washington D.C. are considered masterpieces of American garden design. She influenced landscape architecture by demonstrating that gardens should reflect their natural settings while serving human needs.",
                contributions: [
                    "First female landscape architect in America",
                    "Designed over 200 significant gardens and landscapes",
                    "Founded member of American Society of Landscape Architects",
                    "Advanced ecological landscape design principles",
                    "Mentored the next generation of landscape architects"
                ],
                discoveries: [
                    Discovery(id: "d1", title: "Dumbarton Oaks Gardens", year: "1921-1947", description: "Created her masterwork garden in Washington D.C., blending formal and naturalistic styles."),
                    Discovery(id: "d2", title: "Princeton University Campus", year: "1912-1943", description: "Designed campus landscapes that integrated buildings with natural surroundings."),
                    Discovery(id: "d3", title: "Ecological Design Approach", year: "1920s", description: "Pioneered using native plants and respecting natural site conditions in landscape design.")
                ],
                quote: "A garden is a series of pictures, each of which should be considered from the point of view of the picture maker.",
                icon: "paintbrush.fill"
            ),
            Expert(
                id: "expert5",
                name: "Liberty Hyde Bailey",
                yearBorn: "1858",
                yearDied: "1954",
                biography: "Liberty Hyde Bailey was an American horticulturist, botanist, and cofounder of the American Society for Horticultural Science. He revolutionized horticultural education and research, writing over 65 books and editing the influential 'Standard Cyclopedia of Horticulture.' Bailey believed in the educational and moral value of gardening and nature study. He promoted the idea that everyone should have access to gardens and green spaces. His work established horticulture as a serious academic discipline and influenced agricultural education throughout the 20th century.",
                contributions: [
                    "Founded modern horticultural science",
                    "Wrote over 65 books on horticulture and botany",
                    "Established Cornell's College of Agriculture",
                    "Promoted nature study in education",
                    "Advanced scientific classification of cultivated plants"
                ],
                discoveries: [
                    Discovery(id: "d1", title: "Standard Cyclopedia of Horticulture", year: "1914-1917", description: "Edited this comprehensive reference work with over 4,000 pages on cultivated plants."),
                    Discovery(id: "d2", title: "Nature-Study Movement", year: "1890s", description: "Promoted hands-on learning about nature in schools, influencing environmental education."),
                    Discovery(id: "d3", title: "Cultivated Plant Taxonomy", year: "1920s", description: "Developed systematic approaches to classifying garden plants and crop varieties.")
                ],
                quote: "A garden requires patient labor and attention. Plants do not grow merely to satisfy ambitions or to fulfill good intentions. They thrive because someone expended effort on them.",
                icon: "book.fill"
            ),
            Expert(
                id: "expert6",
                name: "Eliot Coleman",
                yearBorn: "1938",
                yearDied: nil,
                biography: "Eliot Coleman is a pioneering American farmer, author, and agricultural researcher who has been instrumental in developing modern organic farming techniques, particularly for small-scale operations. He has spent decades perfecting methods for year-round vegetable production in cold climates without artificial heating. Coleman's innovations in season extension, mobile greenhouses, and hand-tool cultivation have made organic farming more accessible and profitable. His books and demonstrations have educated thousands of farmers worldwide on sustainable, efficient growing methods.",
                contributions: [
                    "Pioneered winter growing techniques for cold climates",
                    "Developed efficient small-scale farming tools and methods",
                    "Wrote influential books on organic farming",
                    "Advanced season extension technology",
                    "Mentored generations of organic farmers"
                ],
                discoveries: [
                    Discovery(id: "d1", title: "Four-Season Harvest", year: "1992", description: "Published techniques for year-round vegetable production in northern climates using simple technologies."),
                    Discovery(id: "d2", title: "Mobile Greenhouse System", year: "1980s", description: "Developed movable hoop houses for crop rotation and season extension."),
                    Discovery(id: "d3", title: "Deep Organic Methods", year: "1970s-present", description: "Refined soil-building techniques for highly productive organic vegetable growing.")
                ],
                quote: "The best fertilizer is the gardener's shadow.",
                icon: "sun.max.fill"
            ),
        ]
    }
    
    static func getTimelineEvents() -> [TimelineEvent] {
        return [
            TimelineEvent(id: "1", year: "10,000 BCE", title: "Agricultural Revolution", description: "Humans began domesticating plants, transitioning from hunter-gatherers to farmers. This marked the beginning of agriculture and permanent settlements.", expertId: nil, category: "Ancient"),
            TimelineEvent(id: "2", year: "1500s", title: "Columbian Exchange", description: "Plants, animals, and agricultural techniques were exchanged between the Old World and New World, transforming global agriculture and diets.", expertId: nil, category: "Exploration"),
            TimelineEvent(id: "3", year: "1849", title: "Birth of Luther Burbank", description: "Luther Burbank was born, who would go on to develop over 800 plant varieties through selective breeding.", expertId: "expert1", category: "People"),
            TimelineEvent(id: "4", year: "1858", title: "Birth of Liberty Hyde Bailey", description: "Liberty Hyde Bailey was born, later founding modern horticultural science and promoting nature study in education.", expertId: "expert5", category: "People"),
            TimelineEvent(id: "5", year: "1902", title: "Russet Burbank Potato", description: "Luther Burbank developed the Russet Burbank potato, which became the most commercially successful potato variety in America.", expertId: "expert1", category: "Discovery"),
            TimelineEvent(id: "6", year: "1914", title: "Standard Cyclopedia Published", description: "Liberty Hyde Bailey completed his comprehensive reference work on cultivated plants, establishing horticulture as a serious academic discipline.", expertId: "expert5", category: "Publication"),
            TimelineEvent(id: "7", year: "1940s", title: "Natural Farming Begins", description: "Masanobu Fukuoka developed his revolutionary 'do-nothing' natural farming methods in Japan, later inspiring permaculture.", expertId: "expert3", category: "Innovation"),
            TimelineEvent(id: "8", year: "1975", title: "The One-Straw Revolution", description: "Fukuoka published his groundbreaking book describing natural farming philosophy and techniques, influencing organic farming worldwide.", expertId: "expert3", category: "Publication"),
            TimelineEvent(id: "9", year: "1992", title: "Four-Season Harvest", description: "Eliot Coleman published techniques for year-round vegetable production in cold climates, revolutionizing winter growing.", expertId: "expert6", category: "Publication"),
        ]
    }
    
    static func getAchievements() -> [Achievement] {
        return [
            Achievement(id: "first_steps", title: "First Steps", description: "Complete your first lesson", icon: "1.circle.fill", rarity: .common, xpReward: 10, requirement: 1, progress: 0),
            Achievement(id: "scholar", title: "Scholar", description: "Complete 5 lessons", icon: "book.fill", rarity: .rare, xpReward: 50, requirement: 5, progress: 0),
            Achievement(id: "master_gardener", title: "Master Gardener", description: "Complete all lessons", icon: "graduationcap.fill", rarity: .legendary, xpReward: 200, requirement: 8, progress: 0),
            Achievement(id: "test_taker", title: "Test Taker", description: "Pass your first test", icon: "checkmark.circle.fill", rarity: .common, xpReward: 10, requirement: 1, progress: 0),
            Achievement(id: "test_master", title: "Test Master", description: "Pass 3 different tests", icon: "star.circle.fill", rarity: .rare, xpReward: 50, requirement: 3, progress: 0),
            Achievement(id: "perfectionist", title: "Perfectionist", description: "Score 100% on any test", icon: "sparkles", rarity: .epic, xpReward: 100, requirement: 1, progress: 0),
            Achievement(id: "rising_star", title: "Rising Star", description: "Reach level 5", icon: "arrow.up.circle.fill", rarity: .rare, xpReward: 50, requirement: 5, progress: 0),
            Achievement(id: "expert_level", title: "Expert", description: "Reach level 10", icon: "crown.fill", rarity: .epic, xpReward: 150, requirement: 10, progress: 0),
            Achievement(id: "xp_collector", title: "XP Collector", description: "Earn 500 total XP", icon: "gift.fill", rarity: .rare, xpReward: 50, requirement: 500, progress: 0),
            Achievement(id: "memory_master", title: "Memory Master", description: "Master 10 flashcards", icon: "brain.head.profile", rarity: .common, xpReward: 20, requirement: 10, progress: 0),
            Achievement(id: "flashcard_expert", title: "Flashcard Expert", description: "Master 50 flashcards", icon: "rectangle.stack.fill", rarity: .epic, xpReward: 100, requirement: 50, progress: 0),
            Achievement(id: "consistent", title: "Consistent", description: "Maintain a 3-day streak", icon: "flame.fill", rarity: .rare, xpReward: 30, requirement: 3, progress: 0),
            Achievement(id: "dedicated", title: "Dedicated", description: "Maintain a 7-day streak", icon: "bolt.fill", rarity: .epic, xpReward: 70, requirement: 7, progress: 0),
            Achievement(id: "historian", title: "Historian", description: "View 5 expert profiles", icon: "person.2.fill", rarity: .rare, xpReward: 40, requirement: 5, progress: 0),
        ]
    }
}

struct TimelineEvent: Identifiable, Codable {
    var id: String
    var year: String
    var title: String
    var description: String
    var expertId: String?
    var category: String
}
