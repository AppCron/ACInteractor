import Foundation

public class MutableInteractorError: InteractorError {
    
    private var mutableMessage: String
    private var mutableCode: Int
    private var mutableDict: [String : Any]
    
    // MARK: - Init
    
    public init(message: String, code: Int, dict: [String: Any]) {
        mutableMessage = message
        mutableCode = code
        mutableDict = dict
        super.init(domain: "com.appcron.acinteractor", code: code, userInfo: nil)
    }
    
    public convenience init(message: String, code: Int) {
        self.init(message: message, code: code, dict: [String: Any]())
    }
    
    public convenience init(message: String) {
        self.init(message: message, code: 0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(error: NSError) {
        mutableMessage = error.localizedDescription
        mutableCode = error.code
        mutableDict = error.dict
        super.init(domain: error.domain, code: error.code, userInfo: error.userInfo)
    }
    
    // MARK: - Getter & Setter
    
    public override var message: String {
        get {
            return mutableMessage
        }
        set {
            mutableMessage = newValue
        }
    }
    
    public override var code: Int {
        get {
            return mutableCode
        }
        set {
            mutableCode = newValue
        }
    }
    
    public override var dict: [String : Any] {
        get {
            return mutableDict
        }
        set {
            mutableDict = newValue
        }
    }
    
    
}
