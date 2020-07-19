//
//  main.m
//  JavaScriptCoreDemo
//
//  Created by dacaiguoguo on 2020/7/19.
//  Copyright © 2020 dacaiguoguo. All rights reserved.
//

#import <Foundation/Foundation.h>
@import JavaScriptCore;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *res = @"json_parse({\"code\":200,\"data\":{\"base64Str\":\"YmFzZTY0U3Ry\"},\"msg\":\"Request Success！\"})";
        // 建立JS运行环境
        JSContext *context = [[JSContext alloc] init];
        // 设置异常捕获方法
        context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
            NSLog(@"JS Error: %@", exception);
        };
        // 注入js同名方法`json_parse`
        [context evaluateScript:@"function json_parse(jsonstring) {return JSON.stringify(jsonstring, null, 4);}"];
        // 用js环境执行返回的js代码。接口只返回了方法调用，方法的实现就是上一步注入的
        JSValue *value = [context evaluateScript:res];
        // 判断执行结果
        if (value.isString) {
            NSString *toStr = value.toString;
            if (toStr) {
                NSData *data = [toStr dataUsingEncoding:NSUTF8StringEncoding];
                // json解析
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"%@", dic);
            }
        }
    }
    return 0;
}
