//
//  CMMControlItemCheckbox.mm
//  SimpleFramework
//
//  Created by Kim Jazz on 13. 3. 4..
//
//

#import "CMMControlItemCheckbox.h"

@implementation CMMControlItemCheckbox{
	CMMMenuItem *_backSprite;
	CCSprite *_checkSprite;
}
@synthesize checked,callback_whenChanged;

+(id)controlItemCheckboxWithBackFrame:(CCSpriteFrame *)backFrame_ checkFrame:(CCSpriteFrame *)checkFrame_{
	return [[[self alloc] initWithBackFrame:backFrame_ checkFrame:checkFrame_] autorelease];
}
+(id)controlItemCheckboxWithFrameSeq:(uint)frameSeq_{
	return [[[self alloc] initWithFrameSeq:frameSeq_] autorelease];
}

-(id)initWithBackFrame:(CCSpriteFrame *)backSprite_ checkFrame:(CCSpriteFrame *)checkFrame_{
	CGSize frameSize_ = [backSprite_ rect].size;
	if(!(self = [super initWithFrameSize:frameSize_])) return self;
	[touchDispatcher setMaxMultiTouchCount:0];
	
	_backSprite = [CMMMenuItem spriteWithTexture:[backSprite_ texture] rect:[backSprite_ rect]];
	[_backSprite setCallback_pushup:^(id item_) {
		[self setChecked:!checked];
	}];
	[_backSprite setPosition:cmmFunc_positionIPN(self, _backSprite)];
	
	_checkSprite = [CCSprite spriteWithSpriteFrame:checkFrame_];
	[_checkSprite setVisible:NO];
	[_checkSprite setPosition:cmmFunc_positionIPN(self, _checkSprite)];
	
	[self addChild:_backSprite z:1];
	[self addChild:_checkSprite z:2];
	
	[self setChecked:NO];
	[self redraw];
	
	return self;
}
-(id)initWithFrameSeq:(uint)frameSeq_{
	CMMDrawingManagerItem *drawingItem_ = [[CMMDrawingManager sharedManager] drawingItemAtIndex:frameSeq_];
	if(!drawingItem_){
		[self release];
		return nil;
	}
	
	CCSpriteFrame *backFrame_ = [[drawingItem_ otherFrames] spriteFrameForKeyFormatter:CMMDrawingManagerItemFormatter_CheckboxBack];
	CCSpriteFrame *checkFrame_ = [[drawingItem_ otherFrames] spriteFrameForKeyFormatter:CMMDrawingManagerItemFormatter_CheckboxCheck];
	return [self initWithBackFrame:backFrame_ checkFrame:checkFrame_];
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
