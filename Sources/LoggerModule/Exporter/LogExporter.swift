
import Foundation

public protocol LogExporter {
    func export(completion: @escaping (Result<Data, Error>) -> Void)
}
