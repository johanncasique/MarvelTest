//
//  Dependencies.swift
//  MarvelTest
//
//  Created by johann casique on 25/10/20.
//

enum DependenciesName {
    case detail
    
    var name: Dependencies.Name {
        switch self {
        case .detail:
            return .init(name: "detail")
        }
    }
}

enum Dependencies {
    struct Name: Equatable {
        let rawValue: String
        static let defaultName = Name(name: "defaultName")
        
        init(name: String) {
            self.rawValue = name
        }
        
        static func == (lhs: Name, rhs: Name) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
    }
    
    final class Container {
        
        var dependencies: [(key: Dependencies.Name, value: Any)] = []
        static let main = Container()
        
        func register(_ dependency: Any, for key: Dependencies.Name = .defaultName) {
            dependencies.append((key: key, value: dependency))
        }
        
        func resolve<T>(_ key: Dependencies.Name = .defaultName) -> T {
            let filterValue = dependencies.filter{ return $0.key == key && $0.value is T }
            guard let firstValue = filterValue.first?.value as? T else {
                assertionFailure("failed dependency")
                fatalError()
            }
            return firstValue
        }
        
        func remove(_ key: Dependencies.Name = .defaultName) {
            dependencies.removeAll { $0.key == key }
        }
    }
}

//use the power of property wrapper used to explore new alternatives to hande dependeci injection
// inspire by this article -> https://medium.com/swlh/dependency-injection-in-swift-with-property-wrappers-c1f02f06cd51
// all related to property wrappers -> https://medium.com/swlh/dependency-injection-in-swift-with-property-wrappers-c1f02f06cd51
@propertyWrapper
struct Inject<T> {
    private let dependencyName: Dependencies.Name
    private let container: Dependencies.Container
    var wrappedValue: T {
        return container.resolve(dependencyName)
    }
    
    init(_ dependencyName: Dependencies.Name = .defaultName, on container: Dependencies.Container = .main) {
        self.dependencyName = dependencyName
        self.container = container
    }
}
