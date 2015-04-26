//
//  AppDelegate.m
//  PhpGenerate
//
//  Created by Xinqi Chan on 4/26/15.
//  Copyright (c) 2015 Xinqi Chan. All rights reserved.
//

#import "AppDelegate.h"
#import "ObjectPhpResult.h"

@interface AppDelegate (){
    int objecCount;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    objecCount = 0;
    
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"source"
                                                     ofType:@"txt"];
    NSData* contentData = [NSData dataWithContentsOfFile:path];
    
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingAllowFragments error:NULL];
    
    
    NSString * phpStringHeader = @"\r\n<?php\r\nerror_reporting(0);\r\nheader('Content-Type: application/json');\r\n";
    NSString * phpStringConetnt = @"";
    NSString * phpStringEnd = @"echo json_encode($object0, JSON_PRETTY_PRINT);\r\n?>";
    phpStringConetnt = ((ObjectPhpResult*)[self phpContentString:dict]).resultString;
    
    NSString * result = [[phpStringHeader stringByAppendingString:phpStringConetnt] stringByAppendingString:phpStringEnd];
    
    NSLog(@"%@", result);
    
    return YES;
}


- (ObjectPhpResult *)phpContentString:(id)source{
    
    NSString * resultString = @"";
    NSString *objectString = [NSString stringWithFormat:@"$object%i", objecCount];
    ObjectPhpResult * phpResult = [ObjectPhpResult new];
    if ([source isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dict = (NSDictionary*)source;
        for (NSString * key in [dict allKeys]) {
            id  value = [dict objectForKey:key];
            if ([value isKindOfClass:[NSString class]]) {
                NSString * phpString = [NSString stringWithFormat:@"%@->%@=\"%@\";\r\n",objectString,key,value];
                resultString = [resultString stringByAppendingString:phpString];
            }else{
                objecCount ++;
                ObjectPhpResult * objectPR = [self phpContentString:value];
                resultString = [resultString stringByAppendingString:objectPR.resultString];
                
                NSString * objectFormat;
                if ([value isKindOfClass:[NSDictionary class]]) {
                    objectFormat = [NSString stringWithFormat:@"%@->%@=%@;\r\n",objectString,key,objectPR.objectName];
                }else{
                    objectFormat = [NSString stringWithFormat:@"%@->%@=%@;\r\n",objectString,key,objectPR.arrayName];
                }
                
                resultString = [resultString stringByAppendingString:objectFormat];
                
            }
            
        }
    }else if([source isKindOfClass:[NSArray class]]){
        NSDate * date = [NSDate date];
        NSString * dateString = [NSString stringWithFormat:@"%f",[date timeIntervalSince1970]];
        dateString = [dateString stringByReplacingOccurrencesOfString:@"."
                                                           withString:@""];
        NSString * arrayName = [NSString stringWithFormat:@"$array%@", dateString];
        phpResult.arrayName = arrayName;
        NSString * arrayDeclareString = [NSString stringWithFormat:@"%@ = array();\r\n",arrayName];
        resultString = [resultString stringByAppendingString:arrayDeclareString];
        NSArray * souceArray = (NSArray*)source;
        for (id value in souceArray) {
            if ([value isKindOfClass:[NSString class]]) {
                NSString * phpString = [NSString stringWithFormat:@"array_push(%@, \"%@\");\r\n",arrayName,value];
                resultString = [resultString stringByAppendingString:phpString];
            }else{
                objecCount ++;
                ObjectPhpResult * objectPR = [self phpContentString:value];
                resultString = [resultString stringByAppendingString:objectPR.resultString];
                NSString * phpString = [NSString stringWithFormat:@"array_push(%@, %@);\r\n",phpResult.arrayName,objectPR.objectName];
                resultString = [resultString stringByAppendingString:phpString];
            }
        }
    }
    
    phpResult.objectName = objectString;
    phpResult.resultString = resultString;
    
    return phpResult;
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
