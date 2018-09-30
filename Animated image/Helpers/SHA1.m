//
//  SHA1.m
//  Animated image
//
//  Created by Serge Nanaev on 29/09/2018.
//  Copyright © 2018 Serge Nanaev. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Produces 160-bit hash value using SHA-1 algorithm.
/// - returns: String containing 160-bit hash value expressed as a 40 digit
/// hexadecimal number.
extern NSString *
_nuke_sha1(const char *data, uint32_t length);
