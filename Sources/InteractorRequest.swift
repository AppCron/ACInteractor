import Foundation

public class InteractorRequest<CompletionType> {
    
    var onComplete:(CompletionType -> Void)?
    
}
