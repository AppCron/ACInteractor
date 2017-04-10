import Foundation

open class InteractorError: Error {
    
    open var message: String
    open var errorCode = 0
    open var nsError: NSError?
    
    public init(message:String) {
        self.message = message
    }
    
    public init(error:NSError) {
        self.message = error.localizedDescription
        self.errorCode = error.code
        self.nsError = error
    }
    
}
