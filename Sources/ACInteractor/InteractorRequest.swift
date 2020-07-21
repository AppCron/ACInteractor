import Foundation

public protocol InteractorRequestProtocol {
    associatedtype Response
    var onComplete: ((Result<Response, InteractorError>) -> Void)? {get set}
}

open class InteractorRequest<T>: InteractorRequestProtocol {
    public typealias Response = T
    public init() {}
    public var onComplete: ((Result<Response, InteractorError>) -> Void)?
}
