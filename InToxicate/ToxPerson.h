//
//  ToxPerson.h
//  
//
//  Created by Christoph Krautz on 23.09.13.
//
//

#import <Foundation/Foundation.h>

@protocol ToxPerson <NSObject>
@required
@property (nonatomic, readonly) NSString *name;

@end

