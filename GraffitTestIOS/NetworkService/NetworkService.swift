import Foundation
import UIKit

class NetworkService {
    
    enum NetworkError: Error {
        case errorInRequest
        case noData
        case decodeError
    }
    
    func request(responseData: @escaping (Result<[ModelDataURL], NetworkError>) -> Void) {
        
        guard let url = URL(string: "https://www.breakingbadapi.com/api/characters") else { return }
        let request = URLRequest(url: url)
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error ) in
            DispatchQueue.main.async {
                if let error = error {
                    responseData(.failure(.errorInRequest))
                    print(error.localizedDescription)
                    return
                }
                
                guard let data = data else {
                    responseData(.failure(.noData))
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let decoderResult = try decoder.decode([ModelDataURL].self, from: data)
                    responseData(.success(decoderResult))
                } catch {
                    responseData(.failure(.decodeError))
                    print("failed to convert \(error)")
                }
            }
        }
        task.resume()
    }
}

