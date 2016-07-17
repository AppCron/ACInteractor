# ACInteractor
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://raw.githubusercontent.com/appcron/acinteractor/master/LICENSE)

Swift Package for a Use Case centric architecture as proposed by Robert C. Martin and others.

## Overview
ACInteractor is a Swift Package that supports a Use Case centric architecture and TDD in Swift projects. The basic idea is that one Use Case, and only one Use Case, is executed by a single class. As proposed by Robert C. Martin, these kind of classes are called Interactors.
- Each Interactor has a Request model.
- Each Interactor has a Response model.
- Each Interactor has a Execute function that takes the Request model an returns the Response model.

``` Swift
class LoginViewController: UIViewController {
    ...
    func login() {
        let request = LoginIntactor.Request()
        
        request.email = "first.last@appcron.com"
        request.password = "1234"
        
        request.onComplete = { (response: LoginIntactor.Response) in
            self.userLabel.text = response.username
        }
        
        request.onError = { (error: InteractorError) in
            self.displayError(error.message)
        }
        
        Logic.executer.execute(request)
    }
}
```

Consumers, like ViewControllers, can easily execute **InteractorRequests** with the help of the **InteractorExecuter**. Therefore an initialized instance of each Interactor has to be registerd on the **InteractorExecuter**. Interactors should be stateless, since all Requests of a given Interactor are handeled by the same instance of that Interactor.

ACInteractor adds no constraints to dependency management.  It's up to you how initialze the Interactor instances. I'd recommend [Dependency Injection with a custom initializer](https://www.natashatherobot.com/swift-dependency-injection-with-a-custom-initializer/). More details can be found at the section "Dependency Injection".

ACInteractor was build with TDD in mind. Each Interactor has a single execution function, a definied request and response, a statless implemention and injected dependencies. This helps writing isolated Unit Tests for each Interactor. See section "Unit Testing" for more details about writing tests.

### License
[Apache License, Version 2.0, January 2004](http://www.apache.org/licenses/LICENSE-2.0)

### Must watch
If you're new to *Clean Code* and **TDD**, [Robert C. Martin's Talk at Ruby Midwest](https://www.youtube.com/watch?v=WpkDN78P884) is highly recommended. It's fun to watch and worth the time. The entire architecture around ACInteractor and the goals of it are based on this talk.

### Content
ACInteractor currently consists of the following files:
```
ACInteractor
├── LICENSE
├── README.md
├── Sources     // The source files
├── Tests       // The unit test files
└── Xcode       // The Xcode project to run the test
```

## Setup
Since Swift 3 and Swift Package are not available with an stable Xcode release, just add the Files of the **Sources** folder to your project.

### via Git Submodule
At the moment it's recommended to add the entire ACInteractor project as a [Git Submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules) to your repository.

0. Navigate to the root directory of your Git repository in Terminal.
0. Run the following command:  
  ```
  git submodule add https://github.com/AppCron/ACInteractor.git
  ```
0. Add the files of the **Sources** folder to your project.

### via Download
Alternatively you can just download the files directly from Github and add the files of the *Sources* folder to your project.

## Writing Intactors
``` Swift
class LoginIntactor: Interactor {
    class Request: InteractorRequest<Response> {...}
    class Response {...}
    
    func execute(request: Request) {...}
}
```
Let's write our first Intactor. It should handle a user login and accepts all logins as long as the user provides a password.

Each Interactor has to implement the **Interactor** protocol, which requires the Intactor to have an **execute()** function. Since each Interactor handles excatly one Use Case, only one execute function is neccessary.

Usually it contains two nested classes. The Request and the Response.

### The Request
``` Swift
class LoginIntactor: Interactor {
    class Request: InteractorRequest<Response> {
      var email: String?
      var password: String?
    }
    ...
}
```

The Request contains all the parameters that are neccessary to execute it. In our case the email and the password. 

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
The Response is the result of the Use Case. In our example it contains the username and a session token.

The Response can be of any type, as long as it is the same type the **InteractorRequest** is typed with. It can even be common type like **String** or **Bool**.

### The Execute Function
``` Swift
class LoginIntactor: Interactor {
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
    
    static let executer = InteractorExecuter()
    
    static func registerInteractors() {
        let loginInteractor = LoginIntactor()
        let loginRequest = LoginIntactor.Request()
        
        executer.registerInteractor(loginInteractor, request: loginRequest)
    }

}
```
To enable consumers, like ViewControllers, to easily execute **InteractorRequests** it's neccessary to register the corresponding Interactor first.

In our case we use a helper class called **Logic**. It contains a static function **registerInteractors()** that creates a **LoginInteractor** instance an registers it with the corresponding **Request** at the **InteractorExecuter**.

Besides that, the **Logic** contains a static property with a global **Executer** instance. This makes it easier for the consumer to access the given instance.

## Executing Requests
``` Swift
class LoginViewController: UIViewController {
    ...
    func login() {
        let request = LoginIntactor.Request()
        
        request.email = "first.last@appcron.com"
        request.password = "1234"
        
        request.onComplete = { (response: LoginIntactor.Response) in
            self.userLabel.text = response.username
        }
        
        Logic.executer.execute(request)
    }
}
```
To execute an *Request* you can simply call the **executeMethod()** on the **InteractorExecuter**. Just make sure you have registered the that Interactor class with its Request on the same **InteractorExecuter** instance.

In our example this instance is stored in the static **executer** property on the Logic class, as shown above.

## Error Handling
Basic error handling is already part of ACInteractor. Each **InteractorRequest** has an **onError** property that stores a closure for the error handling. 

### On the Interactor Implementation
``` Swift
class LoginIntactor: Interactor {
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
        let request = LoginIntactor.Request()
        
		...
        
        request.onError = { (error: InteractorError) in
            self.displayError(error.message)
        }
        
        Logic.executer.execute(request)
    }
}
```
When executing an request make sure to set an closure for error handling on its **onError** property.

## Extended Completion Handlers
It is not necessary to use the default completion and error handlers. You can add custom completion closures, like **onUpdate(UpdateResponse)**, or custom error closures, like **onExtendedError(ExtendedError)**. This can be either done by adding them as poperties to specific request or by subclassing **InteractorRequest**.

**Be aware when adding custom error handlers.** ACInteractor uses the default **onError** closure to report internal errors, like not finding an Interactor for a given request. See section "Troubleshooting" for Details.

## Asynchronous Requests
Since ACInteractor uses closures for result handling, you can easily switch between synchronous and asychronous behavior without the need to adjust your Interactor's interface. 

When making asychronous callbacks from your Interactor, it's recommend to dispatch your **onCompletion** and **onError** closure calls to the thread the Interactor's **execute()** method has been called from. Whether to use background threads and when and how to dispatch back to the caller's thread is a technical detail of your Interactor, that should be hidden from the caller. It is not the responsibility of a ViewController to disptach your asynchronous stuff back on the main thread. Maybe it can by done with `dispatch_async`, maybe `dispatch_sync` is neccessary, the ViewController can't know.

## Dependency Injection

## Unit-Testing

## Troubleshooting
