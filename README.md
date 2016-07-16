# ACInteractor
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://raw.githubusercontent.com/appcron/acinteractor/master/LICENSE)

Swift Package for a use case centric architecture as proposed by Robert C. Martin and others.

## Current Status
Work in progress … 🐳

## Overview
ACIntactor is a Swift Package that supports a use case centric architecture in Swift projects.

### License
[Apache License, Version 2.0, January 2004](http://www.apache.org/licenses/LICENSE-2.0)

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
Alternativly you can just download the files directly from Github and add the files of the *Sources* folder to your project.

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
tbd

## Executing Requests
tbd

## Error Handling
tbd

## Dependency Injection

## Unit-Testing

## Troubleshooting
tbd