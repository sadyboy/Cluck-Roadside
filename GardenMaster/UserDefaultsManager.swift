import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let userKey = "savedUser"
    
    private init() {}
    
    func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }
    
    func loadUser() -> User {
        if let data = UserDefaults.standard.data(forKey: userKey),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            return user
        }
        return User()
    }
}
