import Foundation

typealias InteractorError = NSError

public extension InteractorError {
    
    public convenience init(message: String, code: Int = 0) {
        var infoDict = [String : Any]()
        infoDict[NSLocalizedDescriptionKey] = message
        self.init(domain: "com.appcron.acinteractor", code: code, userInfo: infoDict)
    }
    
    public var message: String {
        get {
            return userInfo[NSLocalizedDescriptionKey] as? String ?? ""
        }
    }
    
}
