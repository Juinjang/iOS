
import ProjectDescription

public enum Environment {
    public static let deploymentTargets: DeploymentTargets = .iOS("16.0")
    public static let destinations: Destinations = [.iPhone]
    public static let organizationName = "com.juinjangteam.Juinjang"
    public static let appVersion = "2.0.1"
    public static let buildNumber = "1"
    
    public static let baseSetting: SettingsDictionary = SettingsDictionary()
        .marketingVersion(appVersion)
        .currentProjectVersion(buildNumber)
        .otherLinkerFlags(["-ObjC"])
    public static let configurations: [Configuration] = [.debug(name: .debug), .release(name: .release)]
}
