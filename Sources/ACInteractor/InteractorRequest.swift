import Foundation

public protocol ErrorRequestProtocol {
    var onError:((InteractorError) -> Void)? {get set}
}

public protocol InteractorRequestProtocol: ErrorRequestProtocol {
    associatedtype Response
    var onComplete: ((Result<Response, InteractorError>) -> Void)? {get set}
}

open class InteractorRequest<T>: InteractorRequestProtocol {
    public typealias Response = T
    public var onError:((InteractorError) -> Void)?
    public var onComplete: ((Result<Response, InteractorError>) -> Void)?
}
