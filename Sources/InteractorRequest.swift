import Foundation

public class ErrorRequest {
    var onError:(InteractorError -> Void)?
}

public class InteractorRequest<Response>: ErrorRequest {
    var onComplete:(Response -> Void)?
}
