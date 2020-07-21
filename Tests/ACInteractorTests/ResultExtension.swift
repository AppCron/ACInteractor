import Foundation

extension Result {

    func isSuccess() -> Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }

    func getSuccess() -> Success? {
        return try? self.get()
    }

    func getFailure() -> Failure? {
        if case .failure(let error) = self {
            return error
        }
        return nil
    }

}
