import Foundation

open class ErrorRequest {
    var onError:((InteractorError) -> Void)?
}

open class InteractorRequest<Response>: ErrorRequest {
    var onComplete:((Response) -> Void)?
}
