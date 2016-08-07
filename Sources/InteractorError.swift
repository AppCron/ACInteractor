import Foundation

public class InteractorError: ErrorType {
    
    public var message: String
    public var errorCode = 0
    public var nsError: NSError?
    
    public init(message:String) {
        self.message = message
    }
    
    public init(error:NSError) {
        self.message = error.localizedDescription
        self.errorCode = error.code
        self.nsError = error
    }
    
}
