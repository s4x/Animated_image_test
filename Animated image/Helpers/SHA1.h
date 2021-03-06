//
//  SHA1.h
//  Animated image
//
//  Created by Serge Nanaev on 29/09/2018.
//  Copyright © 2018 Serge Nanaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

NSString *
_nuke_sha1(const char *data, uint32_t length) {
    unsigned char hash[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data, (CC_LONG)length, hash);

    char utf8[2 * CC_SHA1_DIGEST_LENGTH + 1];
    char *temp = utf8;
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        snprintf(temp, 3, "%02x", hash[i]);
        temp += 2;
    }
    return [NSString stringWithUTF8String:utf8];
}
