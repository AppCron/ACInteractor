# ACInteractor
[![License](https://img.shields.io/badge/swift-4.0-orange.svg)](https://swift.org)
[![License](https://img.shields.io/badge/license-Apache_2.0-blue.svg)](https://raw.githubusercontent.com/appcron/acinteractor/master/LICENSE)

Swift Package for a Use Case centric architecture as proposed by Robert C. Martin and others.

## Overview
ACInteractor is a [Swift Package](https://swift.org/package-manager/) that supports a Use Case centric architecture and TDD in Swift projects. The basic idea is that one Use Case, and only one Use Case, is executed by a single class. As proposed by Robert C. Martin, these kind of classes are called Interactors.
- Each Interactor has a Request model.
- Each Interactor has a Response model.
- Each Interactor has an Execute function that takes the Request model and returns the Response model.

``` Swift
class LoginViewController: UIViewController {
    ...
    func login() {
        let request = LoginUserInteractor.Request()
        
        request.email = "first.last@appcron.com"
        request.password = "1234"
        
        request.onComplete = { response in
            self.userLabel.text = response.username
        }
        
        request.onError = { error in
            self.displayError(error.message)
        }
        
        Logic.executor.execute(request)
    }
}
```

Consumers, like ViewControllers, can easily execute **InteractorRequests** with the help of the **InteractorExecutor**. Therefore an initialized instance of each Interactor has to be registered on the **InteractorExecutor**. Interactors should be stateless, since all Requests of a given Interactor are handled by the same instance of that Interactor.

ACInteractor adds no constraints to dependency management.  It's up to you how to initialize your Interactor instances. I'd recommend [Dependency Injection with a custom initializer](https://www.natashatherobot.com/swift-dependency-injection-with-a-custom-initializer/). More details can be found at the section "Dependency Injection".

ACInteractor was built with TDD in mind. Each Interactor has a single execution function, a defined request and response, a stateless implementation and injected dependencies. This helps writing isolated Unit Tests for each Interactor. See section "Unit Testing" for more details about writing tests.

### License
[Apache License, Version 2.0, January 2004](http://www.apache.org/licenses/LICENSE-2.0)

### Must watch
If you're new to **Clean Code** and **TDD**, [Robert C. Martin's Talk at Ruby Midwest](https://www.youtube.com/watch?v=WpkDN78P884) is highly recommended. It's fun to watch and worth the time. The entire architecture around ACInteractor and the goals of it are based on this talk.

### Content
ACInteractor currently consists of the following files:
```
ACInteractor
├── LICENSE
├── Package.swift   // The Swift Package description
├── README.md
├── Sources         // The source files
└── Tests           // The unit test files
```

## Setup
Since [Swift Package](https://swift.org/package-manager/) is not supporting iOS Xcode projects yet, it's recommended to add the files of the **Sources/ACInteractor** folder directly to your project.

### via Git Submodule
You can add the entire ACInteractor project as a [Git Submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules) to your repository.

1. Navigate to the root directory of your Git repository in Terminal.
2. Run the following command:  
  ```
  git submodule add https://github.com/AppCron/ACInteractor.git
  ```
3. Add the files of the **Sources/ACInteractor** folder to your project.

### via Download
Alternatively you can just download the files directly from Github and add the files of the **Sources** folder to your project.

### as Swift Package Dependency
You can also add it as [Swift Package](https://swift.org/package-manager/) Dependency to another Swift Package.
``` Swift
dependencies: [
    .Package(url: "https://github.com/AppCron/ACInteractor.git", majorVersion: 0)
]
```

### Terminal Commands
You can run the tests directly from the command line with `swift test`.  
To create an Xcode project use `swift package generate-xcodeproj`.

## Writing Interactors
``` Swift
class LoginUserInteractor: Interactor {
    class Request: InteractorRequest<Response> {...}
    class Response {...}
    
    func execute(request: Request) {...}
}
```
Let's write our first Interactor. It should handle a user login and accepts all logins as long as the user provides a password.

Each Interactor has to implement the **Interactor** protocol, which requires the Interactor to have an **execute()** function. Since each Interactor handles exactly one Use Case, only one execute function is necessary.

Usually, it contains two nested classes. The Request and the Response.

### The Request
``` Swift
class LoginUserInteractor: Interactor {
    class Request: InteractorRequest<Response> {
      var email: String?
      var password: String?
    }
    ...
}
```

The Request contains all the parameters that are necessary to execute it. In our case the email and the password. 

It has to be derived from the generic `InteractorRequest<ResponseType>` and should by typed with the **ResponseType** of the Interactor. This will help us execute the Request later. See section "The Execute Function" for details.

### The Response
``` Swift
class LoginIntactor: Interactor {
    ...
    class Response {
    	var username: String?
    	var sessionToken: String?
	}
    ...
}
```
The Response is the result of the Use Case. In our example, it contains the username and a session token.

The Response can be of any type, as long as it is the same type the **InteractorRequest** is typed with. It can even be a common type like **String** or **Bool**.

### The Execute Function
``` Swift
class LoginUserInteractor: Interactor {
	...
    func execute(request: Request) {
        if (request.password?.characters.count > 0) {
            
            // Create Response
            let response = Response()
            
            // Set values
            response.username = request.email?.componentsSeparatedByString("@").first
            response.sessionToken = "123456910"
            
            // Call completion handler
            request.onComplete?(response)
            
        } else {
            // Do error handling
        }
    }
}
```
The Execute Function is the part where the business logic of the Use Case is implemented. It takes the **Request** as an argument and returns the **Response** to the completion handler.

The **onComplete** closure is already defined in the **InteractorRequest** and already typed with the Response. That's why the **Request** has to be a subclass of **InteractorRequest**.

## Registering Interactors
``` Swift
class Logic {
    
    static let executor = InteractorExecutor()
    
    static func registerInteractors() {
        let loginInteractor = LoginUserInteractor()
        let loginRequest = LoginUserInteractor.Request()
        
        executor.registerInteractor(loginInteractor, request: loginRequest)
    }

}
```
To enable consumers, like ViewControllers, to easily execute **InteractorRequests** it's necessary to register the corresponding Interactor first.

In our case we use a helper class called **Logic**. It contains a static function **registerInteractors()** that creates a **LoginInteractor** instance and registers it with the corresponding **Request** at the **InteractorExecutor**.

Besides that, the **Logic** contains a static property with a global **Executor** instance. This makes it easier for the consumer to access the given instance.

## Executing Requests
``` Swift
class LoginViewController: UIViewController {
    ...
    func login() {
        let request = LoginUserInteractor.Request()
        
        request.email = "first.last@appcron.com"
        request.password = "1234"
        
        request.onComplete = { (response: LoginUserInteractor.Response) in
            self.userLabel.text = response.username
        }
        
        Logic.executor.execute(request)
    }
}
```
To execute a **Request** you can simply call the **executeMethod()** on the **InteractorExecutor**. Just make sure you have registered the that Interactor class with its Request on the same **InteractorExecutor** instance.

In our example this instance is stored in the static **executor** property on the Logic class, as shown above.

## Error Handling
Basic error handling is already part of ACInteractor. Each **InteractorRequest** has an **onError** property that stores a closure for the error handling. 

### On the Interactor Implementation
``` Swift
class LoginUserInteractor: Interactor {
	...
    func execute(request: Request) {
        if (request.password?.characters.count > 0) {
            ...        
        } else {
            let error = InteractorError(message: "Empty password!")
            request.onError?(error)
        }
    }
}
```
On the Interactor all you have to do is create an instance of **InteractorError**, supply an error message and call the error handler with the error object.

### On the Execute Call
``` Swift
class LoginViewController: UIViewController {
    ...
    func login() {
        let request = LoginUserInteractor.Request()
        
		...
        
        request.onError = { (error: InteractorError) in
            self.displayError(error.message)
        }
        
        Logic.executor.execute(request)
    }
}
```
When executing a request make sure to set a closure for error handling on its **onError** property.

## Extended Completion Handlers
It is not necessary to use the default completion and error handlers. You can add custom completion closures, like **onUpdate(UpdateResponse)**, or custom error closures, like **onExtendedError(ExtendedError)**. This can be either done by adding them as properties to a specific request or by subclassing **InteractorRequest**.

**Be aware when adding custom error handlers.** ACInteractor uses the default **onError** closure to report internal errors, like not finding an Interactor for a given request. See section "Troubleshooting" for Details.

## Asynchronous Requests
Since ACInteractor uses closures for result handling, you can easily switch between synchronous and asynchronous behavior without the need to adjust your Interactor's interface. 

When making asynchronous callbacks from your Interactor, it's recommended to dispatch your **onCompletion** and **onError** closure calls to the thread the Interactor's **execute()** method has been called from. Whether to use background threads and when or how to dispatch back to the caller's thread is an implementation detail of your Interactor, that should be hidden from the caller. It is not the responsibility of a ViewController to dispatch your asynchronous stuff back on the main thread. Maybe it can be done with `dispatch_async`, maybe `dispatch_sync` is necessary, the ViewController can't know.

## Dependency Injection
In a real world example the LoginInteractor would call a webservice to verify the login credentials and store the session token in a local database. Since we don't want all these technical details in our Interactor we encapsulate them in two separate classes.
``` Swift
protocol WebservicePlugin
class HttpWebservicePlugin: WebservicePlugin { }

protocol UserEntityGateway
class UserCoreDataGateway: UserEntityGateway { }
```
The **WebservicePlugin** handles the webservice calls and calls the onCompletion closure once finished.

The **UserEntityGateway** has functions to create new users and to save users. It is responsible for creating and saving new entities. So our **LoginInteractor** does not need to now how we persist data. It can be a CoreData-, a Realm- or just an In-Memory-Database.

Additionally it is useful to define a protocol for each dependency. This lets us replace them easily with mocks when writing unit tests.

### On the Interactor Implementation
``` Swift
class LoginUserInteractor: Interactor {
	let webservicePlugin: WebservicePlugin
	let userGateway: UserEntityGateway

	init(webservicePlugin: WebservicePlugin, userGateway: UserEntityGateway) {
		self.webservicePlugin = webservicePlugin
		self.userGateway = userGateway
	}

    func execute(request: Request) {
    	...
    	self.webservicePlugin.doStuff()
    	self.userEntityGateway.doStudd()
    	...
    }
}
```
On the Interactor we need a custom **init** function that takes the dependencies as parameters and stores them in properties. We can then use them in the *execute* function.

### Register with Dependencies
``` Swift
class Logic {
    
    static let executor = InteractorExecutor()
    
    static func registerInteractors() {
    	let webservicePlugin = HttpWebservicePlugin()
    	let userGateway = UserCoreDataGateway()

        let loginInteractor = LoginUserInteractor(webservicePlugin: webservicePlugin, userGateway: userGateway)
        let loginRequest = LoginUserInteractor.Request()
        
        executor.registerInteractor(loginInteractor, request: loginRequest)
    }
}
```
When registering the **LoginInteractor** we use the custom **init** method to supply the matching implementations. At this point you can easily replace the concrete implementations of the Plugin and the Gateway with other implementations as long as they conform to the specified protocols. For example the **UserCoreDataEntityGateway** could be replaced with an **UserInMemoryGateway**.

### On the Execute Call
``` Swift
class LoginViewController: UIViewController {
    ...
    func login() {
        let request = LoginUserInteractor.Request()
       	...
        Logic.executor.execute(request)
    }
}
```
Nothing changes :) The Interactor is still executed with the same Request on the **InteractorExecutor**. This means you can easily refactor Interactors behind the scenes and extract technical details in EntityGateways and Plugins without breaking the API that is used by the caller.

## Unit Testing
ACInteractor was build with TDD in mind. Each Interactor has a single execution function, a defined request and response, a stateless implementation and injected dependencies. This helps writing isolated Unit Tests for each Interactor. 

If you use the Dependency Injection approach described above you can easily mock the dependencies in your Unit Tests. For example this means you don't need to execute a real webservice call or setup a real database to run your tests. The mocks can just return the values that support you current test. Mocks can also help you to test edge cases that would be otherwise hard to 
simulate, like a long taking webservice request or a full database.

## Troubleshooting
1. I can not register my Interactor at the InteractorExecutor. I get a Compiler Error.
   * Make sure the `interactor` implements the `Interactor` protocol
   * Make sure the `request` is a subclass of `InteractorRequest<Response>` and is correctly typed.
   * Make sure the `request` is an initialized object instance.

1. Calling execute on the InteractorExecutor does not call the execute method of my Interactor.
   * Make sure you have registered the Interactor with the corresponding InteractoRequest by calling the `registerInteractor()` function on the `InteractorExecutor`.
   * Make sure you have called the `registerInteractor()` and the `execute()` function on the **same** instance of `InteractorExecutor`.
   * Make sure you have set an `onError` closure on the `request`. It might provide additional details in the error message about what went wrong.

## Credits
Special thanks from [Florian Rieger](https://github.com/florieger) to the people that helped getting ACInteractor together.
- [Andreas Hager](https://github.com/casid) for inspiring me with the wonderful [JUsecase](https://github.com/casid/jusecase) and helping with an initial Swift version of it.
- [Victoria Teufel](https://teufel-it.de) for evaluating the Interactor-based architecture in several Objective-C and Swift projects.
- [Aleksandar Damjanovic](https://github.com/codejanovic) for introducing me to the Github workflow.

Happy Coding 🐳
