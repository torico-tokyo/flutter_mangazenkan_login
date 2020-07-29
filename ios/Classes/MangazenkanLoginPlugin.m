#import "MangazenkanLoginPlugin.h"
#if __has_include(<mangazenkan_login/mangazenkan_login-Swift.h>)
#import <mangazenkan_login/mangazenkan_login-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "mangazenkan_login-Swift.h"
#endif

@implementation MangazenkanLoginPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMangazenkanLoginPlugin registerWithRegistrar:registrar];
}
@end
