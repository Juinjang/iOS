import Foundation

// MARK: - URL 설정
/// 환경별 Base URL을 관리합니다.
/// App 모듈의 Info.plist에서 값을 가져옵니다.

public enum URLConfiguration {

    /// 메인 API Base URL
    public static var baseURL: String {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            #if DEBUG
            // 디버그 환경에서는 fallback URL 제공
            return "https://api.dev.example.com"
            #else
            fatalError("❌ BASE_URL not found in Info.plist")
            #endif
        }
        return baseURL
    }

    /// 지역코드 API URL
    public static var areaURL: String {
        guard let areaURL = Bundle.main.object(forInfoDictionaryKey: "AREA_CODE_URL") as? String else {
            #if DEBUG
            return "https://area.dev.example.com"
            #else
            fatalError("❌ AREA_CODE_URL not found in Info.plist")
            #endif
        }
        return areaURL
    }
}
