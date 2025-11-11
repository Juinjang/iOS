public enum CheckListVersion: Int {
    case limjang = 0
    case nonLimjang = 1
    
    public init(from string: String) {
        switch string.uppercased() {
        case "LIMJANG": self = .limjang
        case "NON_LIMJANG": self = .nonLimjang
        default: self = .limjang
        }
    }
}
