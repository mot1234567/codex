#if canImport(Combine)
import Combine
#else
import Foundation

public protocol ObservableObject: AnyObject {}

@propertyWrapper
public struct Published<Value> {
    public init(wrappedValue: Value) { self.wrappedValue = wrappedValue }
    public var wrappedValue: Value
    public var projectedValue: Published<Value> { self }
}
#endif
