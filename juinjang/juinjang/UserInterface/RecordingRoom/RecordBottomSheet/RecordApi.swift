//
//  RecordApi.swift
//  juinjang
//
//  Created by 박도연 on 5/21/24.
//

import Foundation

struct RecordRequestDTO: Codable {
    let limjangId: Int
    let recordTime: Int
    let recordName: String
    let recordScript: String
}

struct RecordResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: RecordResult
}

struct RecordResult: Codable {
    let recordName: String
    let createdAt: String
    let updatedAt: String
    let recordScript: String
    let recordTime: Int
    let recordUrl: String
    let recordId: Int
    let limjangId: Int
}

func uploadRecording(audioURL: URL, recordRequestDTO: RecordRequestDTO, accessToken: String, completion: @escaping (Result<RecordResponse, Error>) -> Void) {
    let url = URL(string: "https://yourserver.com/api/record")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let boundary = "Boundary-\(UUID().uuidString)"
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.setValue(accessToken, forHTTPHeaderField: "accesstoken")

    let fullData = createMultipartFormData(boundary: boundary, audioURL: audioURL, recordRequestDTO: recordRequestDTO)
    request.httpBody = fullData

    let session = URLSession.shared
    session.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let data = data else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
            return
        }
        do {
            let response = try JSONDecoder().decode(RecordResponse.self, from: data)
            completion(.success(response))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}

func createMultipartFormData(boundary: String, audioURL: URL, recordRequestDTO: RecordRequestDTO) -> Data {
    var body = Data()

    // Add audio file data
    if let audioData = try? Data(contentsOf: audioURL) {
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(audioURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: audio/m4a\r\n\r\n".data(using: .utf8)!)
        body.append(audioData)
        body.append("\r\n".data(using: .utf8)!)
    }

    // Add JSON data
    let jsonData = try! JSONEncoder().encode(recordRequestDTO)
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"recordRequestDTO\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
    body.append(jsonData)
    body.append("\r\n".data(using: .utf8)!)

    // End boundary
    body.append("--\(boundary)--\r\n".data(using: .utf8)!)

    return body
}

