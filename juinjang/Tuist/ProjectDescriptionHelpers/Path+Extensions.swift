import ProjectDescription

public extension Path {
    enum plist {
        public static let googleServiceInfoDebug = Path.relativeToRoot("Projects/App/Resources/Firebase/PRD/GoogleService-Info.plist")
    }
    
    enum config {
        public static let sharedConfig = Path.relativeToRoot("Projects/App/XCConfig/Shared.xcconfig")
    }
}
