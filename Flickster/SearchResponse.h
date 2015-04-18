//
//  SearchResponse.h
//  Flickster
//
//  Created by Francesco Georg on 18/04/15.
//  Copyright (c) 2015 Wooga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResponse : NSObject

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger perpage;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSArray *photo;

@end
