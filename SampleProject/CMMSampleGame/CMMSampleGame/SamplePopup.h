//
//  SamplePopup.h
//  CMMSampleGame
//
//  Created by Kim Jazz on 13. 3. 15..
//  Copyright (c) 2013년 Kim Jazz. All rights reserved.
//

#import "CMMHeader.h"

@interface SamplePopupLoading : CMMPopupLayer
@end

@interface SamplePopupNotice : CMMPopupLayer{
	CCLabelTTF *_labelNotice;
	CMMMenuItemL *_btnClose;
}

+(id)noticeWithNotice:(NSString *)notice_;
-(id)initWithNotice:(NSString *)notice_;

@property (nonatomic, copy) NSString *notice;

@end
