
import Foundation

class NetWorkImageRequest {
    
    static let shared = NetWorkImageRequest()
    private init() {}
    
    func requestData(id: String, completion: @escaping (Result<Data, Error>) -> Void) {
//        let key = "622506d857f61426ac4243bf52e58da4"

        let urlString = "https://openweathermap.org/img/wn/\(id)@2x.png"
        
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }
        .resume()
    }
}
