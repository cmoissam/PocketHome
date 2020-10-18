# WeatherApp

Sample application display wheater details by city, support online and offline mode.

## Requirement

Xcode 11 / iOS11 / Swift 5.0

## Project setup

Clone project
```
git clone (remote rerpo)
```

Run and Go !

## Documentation

### External Frameworks

[RxSwift] (https://github.com/ReactiveX/RxSwift)

### Architecture

This Application use a "MVVM  + coordinator" architecture.

#### OverView

<img src="./documentation/architecture.png" width="50%">

#### Components

##### UIViewController

Representation of a view.
Must not contains business logic which should be delegated to viewModel, same for navigation
which should be delegated to Coordinator.

##### ViewModel

ViewModel are responsible for UI state representation and formatting logic.
Each ViewController UI update should be triggered by a ViewModel using RxSwift.
ViewModel call Service for store updates.

##### Service

Service do business logic and update store, that notify viewModel for changes

##### Dependencies

For dependencies we use a simple class **SharedAppDependencies** all viewcontroller *must* be created there to don't pollute application code with dependencies configuration.

For the usage only one instance of AppDependencies must be used during application lifetime, so all coordinator should have one reference of it to handle his view controller construction.

## Give feedback

email: issam.lanouari@gmail.com

## Authors

**Lanouari Issam** - *Cmoissam*
