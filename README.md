[![996.icu](https://img.shields.io/badge/link-996.icu-red.svg)](https://996.icu)
[![LICENSE](https://img.shields.io/badge/license-Anti%20996-blue.svg)](https://github.com/996icu/996.ICU/blob/master/LICENSE)

# NavigationTransition

Some categories that can be used to customize your navigation transition.

- customize transition animate
- customize navigation bar when transition
- support fullscreen interactive pop gesture
- support Storyboard

## Install

Add the followwing line to your Podfile:

```
pod 'NavigationTransition'
```

## Usage

Set the navigationTransitionStyle property for UINavigationController to customize the transition for all view controllers in the navigation.

```
DemoViewController *vc = [[DemoViewController alloc] init];
UINavigationController *nav = [[UINavigationController alloc] initWithNavigationBarClass:STMNavigationBar.class toolbarClass:nil];
nav.viewControllers = @[vc];
nav.navigationTransitionStyle = STMNavigationTransitionStyleSystem;
[self presentViewController:nav animated:YES completion:nil];

```

You can also set the navigationTransitionStyle property for a single UIViewController to customize the only one vc.

```
DemoViewController *vc = [[DemoViewController alloc] init];
if (self.navigationController.viewControllers.count == 3) {
	vc.navigationTransitionStyle = STMNavigationTransitionStyleResignLeft;
}
[self.navigationController pushViewController:vc animated:YES];
```

And you can customize a transition use yourself Class.

```
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
  CustomTransition *transition = [[CustomTransition alloc] init];
  transition.operation = operation;
  return transition;
}
```


Download the project and see the detail.

## Blog

https://douking.github.io/2018/01/01/navigation-transition/

## License

See file `LICENSE.MIT` and `LICENSE.NPL`.