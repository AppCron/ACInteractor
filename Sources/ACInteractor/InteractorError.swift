import Foundation

public typealias InteractorError = NSError

public extension InteractorError {
    
    private static let dictKey = "InteractorErrorDictKey"
    
    // MARK: - Init
    
    convenience init(message: String, code: Int, dict: [String: Any]) {
        var infoDict = [String : Any]()
        infoDict[NSLocalizedDescriptionKey] = message
        infoDict[InteractorError.dictKey] = dict
        self.init(domain: "com.appcron.acinteractor", code: code, userInfo: infoDict)
    }
    
    convenience init(message: String, code: Int) {
        self.init(message: message, code: code, dict: [String: Any]())
    }
    
    convenience init(message: String) {
        self.init(message: message, code: 0)
    }
    
    // MARK: - Message
    
    var message: String {
        get {
            // Use localizedDescription instead in infoDict,
            // since some CoreData error have a localizedDescription but no entry in the dictionary.
            return localizedDescription
        }
    }
    
    // MARK: - Error Dict
    
    var dict: [String: Any] {
        get {
            guard let dict = userInfo[InteractorError.dictKey] as? [String: Any] else {
                return [String: Any]()
            }
            return dict
        }
    }
    
}
