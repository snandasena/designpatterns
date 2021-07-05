/// Composite Design Pattern
///
/// Intent: Lets you compose objects into tree structures and then work with
/// these structures as if they were individual objects.

import XCTest

/// The base Component class declares common operations for both simple and
/// complex objects of a composition.
protocol Component {

    /// The base Component may optionally declare methods for setting and
    /// accessing a parent of the component in a tree structure. It can also
    /// provide some default implementation for these methods.
    var parent: Component? { get set }

    /// In some cases, it would be beneficial to define the child-management
    /// operations right in the base Component class. This way, you won't need
    /// to expose any concrete component classes to the client code, even during
    /// the object tree assembly. The downside is that these methods will be
    /// empty for the leaf-level components.
    func add(component: Component)
    func remove(component: Component)

    /// You can provide a method that lets the client code figure out whether a
    /// component can bear children.
    func isComposite() -> Bool

    /// The base Component may implement some default behavior or leave it to
    /// concrete classes.
    func operation() -> String
}

extension Component {

    func add(component: Component) {}
    func remove(component: Component) {}
    func isComposite() -> Bool {
        return false
    }
}

/// The Leaf class represents the end objects of a composition. A leaf can't
/// have any children.
///
/// Usually, it's the Leaf objects that do the actual work, whereas Composite
/// objects only delegate to their sub-components.
class Leaf: Component {

    var parent: Component?

    func operation() -> String {
        return "Leaf"
    }
}

/// The Composite class represents the complex components that may have
/// children. Usually, the Composite objects delegate the actual work to their
/// children and then "sum-up" the result.
class Composite: Component {

    var parent: Component?

    /// This fields contains the conponent subtree.
    private var children = [Component]()

    /// A composite object can add or remove other components (both simple or
    /// complex) to or from its child list.
    func add(component: Component) {
        var item = component
        item.parent = self
        children.append(item)
    }

    func remove(component: Component) {
        // ...
    }

    func isComposite() -> Bool {
        return true
    }

    /// The Composite executes its primary logic in a particular way. It
    /// traverses recursively through all its children, collecting and summing
    /// their results. Since the composite's children pass these calls to their
    /// children and so forth, the whole object tree is traversed as a result.
    func operation() -> String {
        let result = children.map({ $0.operation() })
        return "Branch(" + result.joined(separator: " ") + ")"
    }
}

class Client {

    /// The client code works with all of the components via the base interface.
    static func someClientCode(component: Component) {
        print("Result: " + component.operation())
    }

    /// Thanks to the fact that the child-management operations are also
    /// declared in the base Component class, the client code can work with both
    /// simple or complex components.
    static func moreComplexClientCode(leftComponent: Component, rightComponent: Component) {
        if leftComponent.isComposite() {
            leftComponent.add(component: rightComponent)
        }
        print("Result: " + leftComponent.operation())
    }
}

/// Let's see how it all comes together.
class CompositeConceptual: XCTestCase {

    func testCompositeConceptual() {

        /// This way the client code can support the simple leaf components...
        print("Client: I've got a simple component:")
        Client.someClientCode(component: Leaf())

        /// ...as well as the complex composites.
        let tree = Composite()

        let branch1 = Composite()
        branch1.add(component: Leaf())
        branch1.add(component: Leaf())

        let branch2 = Composite()
        branch2.add(component: Leaf())
        branch2.add(component: Leaf())

        tree.add(component: branch1)
        tree.add(component: branch2)

        print("\nClient: Now I've got a composite tree:")
        Client.someClientCode(component: tree)

        print("\nClient: I don't need to check the components classes even when managing the tree:")
        Client.moreComplexClientCode(leftComponent: tree, rightComponent: Leaf())
    }
}
