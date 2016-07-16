import Foundation

public class ErrorRequest {
    var onError:(ErrorType -> Void)?
}


public class InteractorRequest<Response>: ErrorRequest {
    
    var onComplete:(Response -> Void)?
}
