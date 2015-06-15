//
//  RdioInstance.h
//  SongDecider
//
//  Created by Aaron Williams on 2015-06-15.
//  Copyright (c) 2015 Aaron Williams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Rdio/Rdio.h>

@interface RdioManager : NSObject {

    Rdio *rdioInstance;
}

@property (nonatomic) Rdio *rdioInstance;

+(id)sharedRdio;

@end
