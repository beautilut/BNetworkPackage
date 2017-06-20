//
//  ViewController.m
//  BAFNetworkLibrary
//
//  Created by Beautilut on 16/7/12.
//  Copyright © 2016年 beautilut. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "TestProvider.h"
#import "BAFRequestManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString * path = NSHomeDirectory();
    
    
    TestProvider * testProvider = [[TestProvider alloc] init];
//    testProvider.baseValue = @"1";
    testProvider.test = @"2";
    testProvider.testValue2 = @"3";
    
    [testProvider requestWithCompletionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",response);
    }];
    
//    [[BAFRequestManager manager] operateWithProvider:testProvider];

//    NSDictionary * dic = [testProvider parameters];
//    NSLog(@"%@",dic);
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//GET 方法
-(void)get
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager GET:@"" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

//POST 方法
-(void)post
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];//@{@"":@"",@"":@""};
    
    [manager POST:@"" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//创建下载任务
-(void)downloadTask
{
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager * manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL * URL = [NSURL URLWithString:@"http://example.com/download.zip"];
    NSURLRequest * request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask * downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL * documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"file downloaded to %@",filePath);
    }];
    [downloadTask resume];
}

//创建上传任务
-(void)uploadTask
{
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager * manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL * URL = [NSURL URLWithString:@"http://example.com/upload"];
    NSURLRequest * request = [NSURLRequest requestWithURL:URL];
    
    NSURL * filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
    NSURLSessionUploadTask * uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error : %@" , error);
        } else {
            NSLog(@"Success : %@ %@",response,responseObject);
        }
    }];
    [uploadTask resume];
}

-(void)TaskForMultiRequest
{
    NSMutableURLRequest * request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://example.com/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    
    AFURLSessionManager * manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask * uploadTask ;
    uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"ERROR : %@", error);
        } else {
            NSLog(@"%@ %@",response , responseObject);
        }
    }];
    [uploadTask resume];
}

-(void)dataTask
{
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager * manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL * URL = [NSURL URLWithString:@"http://httpbin.org/get"];
    NSURLRequest * request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask * dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"ERROR: %@",error);
        }else {
            NSLog(@"%@ %@",response , responseObject);
        }
    }];
    [dataTask resume];
}
@end
