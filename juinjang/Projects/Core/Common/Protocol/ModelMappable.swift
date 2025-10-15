public protocol DomainMappable {
    public associatedtype Model
    public func toDomain() -> Model 
}

public protocol PresentationMappable {
    public associatedtype Model
    public func toPresentation() -> Model
}
