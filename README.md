# IKRouter

## What does it do?
Once you have made your `UIViewController`s conform to `Routable` you can register them with the parameters that they represent in your registered url-scheme routes. `IKRouter` is then able to create an array of `UIViewController`s for you to display when a valid url is handled. All you need to do then is display them!

`IKRouter` can also handle routes in the traditional way by simply registering a route and handling it with a funciton/closure and the two methods can also be used together.

An example route is:
```
myapp://project/:projectId/item/:itemId
```
Note that routes must include the scheme (`myapp://`), url parameters need to be prefixed with a colon (`:`) and query strings dont need to be included when registering a route as they are included when the route is matched.

## Using Routables
To use the `Routable`s to automatically create your UI stack

1. Make any `UIViewController` that can be linked to a route parameter conform to `Routable`.
2. Register these with your `IKRouter` instance.
3. Register the routes that _use_ those parameters.
4. Handle the chain of `UIViewController`s via the `routableHandler` closure/function.

## The Routable protocol
The `Routable` protocol consists of a single simple method which when give a `MatchedRoute` returns an instance of the `Routable`.

```swift
protocol Routable {
    static func instanceForRoute(route: MatchedRoute) -> Routable?
}
```

`MatchedRoute` instances provide all the details needed to pass information through to `Routables` like matched parameters and their values as well as query string.

## Routable Example
Once your `UIViewController`s are `Routable` simply do the following:

```swift
let navController = UINavigationController()
let router = IKRouter()
router
    .registerRoutableWithParameter(ProjectViewController.self, parameter: ":projectId")
    .registerRoutableWithParameter(ItemViewController.self, parameter: ":itemId")
    .registerRouteHandler("myapp://project/:projectId/item/:itemId")
    .registerRouteHandler("myapp://project/:projectId")
    .routableHandler = { match, viewControllers in
        navController.setViewControllers(viewControllers, animated: true)
    }
```

## Things to note about using Routable

* As many routes can be registered as you want in any combination as long as each one is:
    * Unique
    * Has a `Routable` registered for all parameters
* If a route comes through and there is a parameter without a `Routable` the default handler will be used (if provided)
* When registering a _route_ there is a `handler` parameter. This can be omitted when using `Routable`s.

## Non Routable Example
If you have routes which might not suit the _automatic_ functionality provided by `Routable`s you can also register individual routes with their own handlers

```swift
let router = IKRouter()
router
    .registerRouteHandler("myapp://project/:projectId/item/:itemId") { match in
        //create view controllers and show here...
        return true
    }
    .registerRouteHandler("myapp://project/:projectId/users/:userId") { match in
        //create view controllers and show here...
        return true /* return false if we didn't handle the route */
    }
```
NOTE: The handler for each route is used here (unlike above)

## UIViewController Presentation
Every app has a slightly different UI hierarchy/architecture... for this reason `IKRouter` does not provide and automatic handling of `UIViewController` presentation but instead allows you to handle that yourself. Instead I have provided a `UINavigationController` extension that you can use to display the stack in different ways.

Currently there is just a simple method that will take a stack of `UIViewController`s; push all but the last and _present_ the last item in the stack like so:

```swift
router.routableHandler = { match, viewControllers in
    navController.setViewControllersPresentingLast(viewControllers, animatedSet: true, animatedPresent: true)
}
```

If there are other means of displaying a stack you think would be useful here feel free to add an issue or pull request, both are welcome!

# The rest...
There is an included app so you can see it in action.

