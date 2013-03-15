//
//  CMMControlItemCheckbox.mm
//  SimpleFramework
//
//  Created by Kim Jazz on 13. 3. 4..
//
//

#import "CMMControlItemCheckbox.h"

@implementation CMMControlItemCheckbox
@synthesize checked,callback_whenChanged;

+(id)controlItemCheckboxWithBackSprite:(CCSprite *)backSprite_ checkSprite:(CCSprite *)checkSprite_{
	return [[[self alloc] initWithBackSprite:backSprite_ checkSprite:checkSprite_] autorelease];
}
+(id)controlItemCheckboxWithFrameSeq:(int)frameSeq_{
	return [[[self alloc] initWithFrameSeq:frameSeq_] autorelease];
}

-(id)initWithBackSprite:(CCSprite *)backSprite_ checkSprite:(CCSprite *)checkSprite_{
	CGSize frameSize_ = [backSprite_ contentSize];
	if(!(self = [super initWithFrameSize:frameSize_])) return self;
	[touchDispatcher setMaxMultiTouchCount:0];
	
	_backSprite = [CMMMenuItem spriteWithTexture:[backSprite_ texture] rect:[backSprite_ textureRect]];
	[_backSprite setCallback_pushup:^(id item_) {
		[self setChecked:!checked];
	}];
	[_backSprite setPosition:cmmFunc_positionIPN(self, _backSprite)];
	
	_checkSprite = checkSprite_;
	[_checkSprite setVisible:NO];
	[_checkSprite setPosition:cmmFunc_positionIPN(self, _checkSprite)];
	
	[self addChild:_backSprite z:1];
	[self addChild:_checkSprite z:2];
	
	[self setChecked:NO];
	
	return self;
}
-(id)initWithFrameSeq:(int)frameSeq_{
	CMMDrawingManagerItem *drawingItem_ = [[CMMDrawingManager sharedManager] drawingItemAtIndex:0];
	if(!drawingItem_){
		[self release];
		return nil;
	}
	
	CCSprite *backSprite_ = [CCSprite spriteWithSpriteFrame:[drawingItem_ spriteFrameForKey:CMMDrawingManagerItemKey_checkbox_back]];
	CCSprite *checkSprite_ = [CCSprite spriteWithSpriteFrame:[drawingItem_ spriteFrameForKey:CMMDrawingManagerItemKey_checkbox_check]];
	return [self initWithBackSprite:backSprite_ checkSprite:checkSprite_];
}

-(void)setEnable:(BOOL)enable_{
	[super setEnable:enable_];
	[_backSprite setEnable:enable_];
	[_checkSprite setColor:(enable?ccWHITE:disabledColor)];
}

-(void)setCheckedDirectly:(BOOL)checked_{
	checked = checked_;
	[self redraw];
}
-(void)setChecked:(BOOL)checked_{
	if(checked == checked_) return;
	[self setCheckedDirectly:checked_];
	
	if(callback_whenChanged){
		callback_whenChanged(checked);
	}
}
-(void)redraw{
	[super redraw];
	[_checkSprite setVisible:checked];
}

-(void)cleanup{
	[super cleanup];
	[self setCallback_whenChanged:nil];
}

-(void)dealloc{
	[callback_whenChanged release];
	[super dealloc];
}

@end
