
import Foundation

class NetworkRequest {
    
    static let shared = NetworkRequest()
    private init() {}
    //http://api.openweathermap.org/data/2.5/weather?lat=46.8462427&lon=29.4673806&appid=622506d857f61426ac4243bf52e58da4
    func requestData(completion: @escaping (Result<Data, Error>) -> Void) {
        let key = "622506d857f61426ac4243bf52e58da4"
        let latitude = 47.023747
        let longitude = 28.861438

        let urlString =
        "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(key)"
        
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
