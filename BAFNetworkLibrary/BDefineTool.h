//
//  BDefineTool.h
//  BAFNetworkLibrary
//
//  Created by Beautilut on 16/9/5.
//  Copyright © 2016年 beautilut. All rights reserved.
//

//转换强弱引用

#define WeakObjectDef(obj) __weak typeof(obj) weak##obj = obj
#define StrongObjectDef(obj) __strong typeof(obj) strong##obj = obj


