
import ProjectDescription

public enum Environment {
    public static let deploymentTargets: DeploymentTargets = .iOS("17.0")
    public static let destinations: Destinations = [.iPhone]
    public static let organizationName = "com.juinjangteam.Juinjang"
    public static let appVersion = "3.0.0"
    public static let buildNumber = "1"
    public static let swiftVersion = "6.0"
    
    public static let baseSetting: SettingsDictionary = SettingsDictionary()
        .marketingVersion(appVersion)
        .currentProjectVersion(buildNumber)
        .otherLinkerFlags(["-ObjC"])
        .swiftVersion(swiftVersion)
    public static let configurations: [Configuration] = [.debug(name: .debug), .release(name: .release)]
}
