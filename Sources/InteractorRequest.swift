import Foundation

public class InteractorRequest<Response> {
    
    var onComplete:(Response -> Void)?
    
}
