
import ProjectDescription

public extension Path {
    enum plist {
        public static let googleServiceInfoDebug = Path.relativeToRoot("Projects/App/Resources/Firebase/PRD/GoogleService-Info.plist")
        
        public static let appInfo = Path.relativeToRoot("Projects/App/InfoPlists/Info.plist")
        
        public static let appInfoDev = Path.relativeToRoot("Projects/App/InfoPlists/Info-dev.plist")
    }
    
    enum config {
        public static let sharedConfig = Path.relativeToRoot("Projects/XCConfig/Shared.xcconfig")
    }
}
