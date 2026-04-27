import Foundation

// MARK: - Multipart Data
/// AF.upload(multipartFormData:)에 그대로 매핑되는 multipart 페이로드.

public struct MultipartData: Sendable {
    public let parts: [Part]

    public init(parts: [Part]) {
        self.parts = parts
    }

    public struct Part: Sendable {
        public let data: Data
        public let name: String
        public let fileName: String?
        public let mimeType: String?

        public init(
            data: Data,
            name: String,
            fileName: String? = nil,
            mimeType: String? = nil
        ) {
            self.data = data
            self.name = name
            self.fileName = fileName
            self.mimeType = mimeType
        }
    }
}
