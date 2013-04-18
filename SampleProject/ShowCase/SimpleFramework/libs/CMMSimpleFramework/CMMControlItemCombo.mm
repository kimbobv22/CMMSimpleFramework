//
//  CMMControlItemCombo.mm
//  SimpleFramework
//
//  Created by Kim Jazz on 13. 4. 9..
//
//

#import "CMMControlItemCombo.h"
#import "CMMLayerMD.h"
#import "CMM9SliceBar.h"

@implementation CMMControlItemComboItem{
	CCLabelTTF *_mappingLabel;
}
@synthesize title,itemValue;

+(id)itemWithTitle:(NSString *)title_ itemValue:(id)itemValue_{
	return [[[self alloc] initWithTitle:title_ itemValue:itemValue_] autorelease];
}
-(id)initWithTitle:(NSString *)title_ itemValue:(id)itemValue_{
	if(!(self = [super init])) return self;
	
	[self setTitle:title_];
	[self setItemValue:itemValue_];
	
	return self;
}

-(void)setTitle:(NSString *)title_{
	[title release];
	title = [title_ copy];
	
	if(_mappingLabel){
		[_mappingLabel setString:(title ? title : @"")];
	}
}

-(void)dealloc{
	[title release];
	[itemValue release];
	[super dealloc];
}

@end

@interface CMMControlItemComboItem(Private)

@property (nonatomic, assign) CCLabelTTF *mappingLabel;

@end

@implementation CMMControlItemComboItem(Private)

-(void)setMappingLabel:(CCLabelTTF *)mappingLabel_{
	_mappingLabel = mappingLabel_;
}
-(CCLabelTTF *)mappingLabel{
	return _mappingLabel;
}

@end

ccColor3B CMMControlItemComboItemFontColor = ccBLACK;
GLubyte CMMControlItemComboItemFontOpacity = 255;
float CMMControlItemComboItemFontSize = 24;
CMM9SliceEdgeOffset CMMControlItemComboEdgeOffset = CMM9SliceEdgeOffset(15.0f,15.0f);

@interface CMMControlItemCombo(Private)

-(void)_callback_whenItemSelected:(CMMControlItemComboItem *)item_;

@end

@implementation CMMControlItemCombo{
	CMMLayerMD *_innerLayer;
	CCArray *_itemList;
	CMM9SliceBar *_backSprite,*_frameSprite,*_cursorSprite;
	
	ccColor3B _itemFontColor;
	GLubyte _itemFontOpacity;
	float _itemFontSize;
	
	BOOL _onSnaped,_doSnapDirectly;
	uint _snapIndex;
	
	void (^_callback_whenIndexChanged)(uint beforeIndex_, uint newIndex_);
}
@synthesize index,itemList;
@synthesize itemFontColor = _itemFontColor,itemFontOpacity = _itemFontOpacity,itemFontSize = _itemFontSize;
@synthesize stopToSnapScrollSpeed,snapSpeed,marginPerItem;
@synthesize callback_whenIndexChanged = _callback_whenIndexChanged;

+(id)controlItemComboWithFrameSize:(CGSize)frameSize_ backFrame:(CCSpriteFrame *)backFrame_ frame:(CCSpriteFrame *)frame_ cursorFrame:(CCSpriteFrame *)cursorFrame_{
	return [[[self alloc] initWithFrameSize:frameSize_ backFrame:backFrame_ frame:frame_ cursorFrame:cursorFrame_] autorelease];
}
+(id)controlItemComboWithFrameSize:(CGSize)frameSize_ frameSeq:(uint)frameSeq_{
	return [[[self alloc] initWithFrameSize:frameSize_ frameSeq:frameSeq_] autorelease];
}
-(id)initWithFrameSize:(CGSize)frameSize_ backFrame:(CCSpriteFrame *)backFrame_ frame:(CCSpriteFrame *)frame_ cursorFrame:(CCSpriteFrame *)cursorFrame_{
	if(!(self = [super initWithFrameSize:frameSize_])) return self;
	
	_itemFontColor = CMMControlItemComboItemFontColor;
	_itemFontOpacity = CMMControlItemComboItemFontOpacity;
	_itemFontSize = CMMControlItemComboItemFontSize;
	
	stopToSnapScrollSpeed = 10.0f;
	snapSpeed = 10.0f;
	index = 0;
	_snapIndex = NSNotFound;
	_onSnaped = _doSnapDirectly = NO;
	marginPerItem = 10.0f;
	
	_innerLayer = [CMMLayerMD layerWithColor:ccc4(0, 0, 0, 0) width:frameSize_.width height:frameSize_.height];
	[_innerLayer setPosition:CGPointZero];
	[_innerLayer setCanDragX:NO];
	[_innerLayer setCanDragY:YES];
	[[_innerLayer scrollbarY] setOpacity:0];
	
	_backSprite = [CMM9SliceBar sliceBarWithTexture:[backFrame_ texture] targetRect:[backFrame_ rect] edgeOffset:CMMControlItemComboEdgeOffset];
	_frameSprite = [CMM9SliceBar sliceBarWithTexture:[frame_ texture] targetRect:[frame_ rect] edgeOffset:CMMControlItemComboEdgeOffset];
	_cursorSprite = [CMM9SliceBar sliceBarWithTexture:[cursorFrame_ texture] targetRect:[cursorFrame_ rect]];
	
	[self addChild:_cursorSprite z:NSIntegerMax];
	[self addChild:_frameSprite z:2];
	[self addChild:_innerLayer z:1];
	[self addChild:_backSprite z:0];
	
	_itemList = [[CCArray alloc] init];
	[self redraw];
	
	return self;
}
-(id)initWithFrameSize:(CGSize)frameSize_ frameSeq:(uint)frameSeq_{
	CMMDrawingManagerItem *drawingItem_ = [[CMMDrawingManager sharedManager] drawingItemAtIndex:frameSeq_];
	if(!drawingItem_){
		[self release];
		return nil;
	}
	
	CCSpriteFrame *backFrame_ = [[drawingItem_ otherFrames] spriteFrameForKeyFormatter:CMMDrawingManagerItemFormatter_ComboBack];
	CCSpriteFrame *frame_ = [[drawingItem_ otherFrames] spriteFrameForKeyFormatter:CMMDrawingManagerItemFormatter_ComboFrame];
	CCSpriteFrame *cursorFrame_ = [[drawingItem_ otherFrames] spriteFrameForKeyFormatter:CMMDrawingManagerItemFormatter_ComboCursor];
	return [self initWithFrameSize:frameSize_ backFrame:backFrame_ frame:frame_ cursorFrame:cursorFrame_];
}

-(void)setEnable:(BOOL)enable_{
	[super setEnable:enable_];
	[_backSprite setColor:(enable?ccWHITE:disabledColor)];
}

-(void)setIndex:(uint)newIndex_{
	uint beforeIndex_ = index;
	index = newIndex_;
	if(beforeIndex_ != index && _callback_whenIndexChanged){
		_callback_whenIndexChanged(beforeIndex_,index);
	}
	_onSnaped = NO;
	_snapIndex = index;
}
-(CCArray *)itemList{
	return [CCArray arrayWithArray:_itemList];
}

-(void)addItem:(CMMControlItemComboItem *)item_{
	[_itemList addObject:item_];
	
	CCLabelTTF *mappingLabel_ = [CMMFontUtil labelWithString:[item_ title]];
	[item_ setMappingLabel:mappingLabel_];
	[_innerLayer addChildToInner:mappingLabel_];
	[self setDoRedraw:YES];
}
-(CMMControlItemComboItem *)addItemWithTitle:(NSString *)title_ itemValue:(id)itemValue_{
	CMMControlItemComboItem *item_ = [CMMControlItemComboItem itemWithTitle:title_ itemValue:itemValue_];
	[self addItem:item_];
	return item_;
}

-(void)removeItemAtIndex:(uint)index_{
	if(index_ == NSNotFound) return;
	
	CMMControlItemComboItem *item_ = [self itemAtIndex:index_];
	[_innerLayer removeChildFromInner:[item_ mappingLabel] cleanup:YES];
	[item_ setMappingLabel:nil];
	[_itemList removeObjectAtIndex:index_];
	[self setDoRedraw:YES];
}
-(void)removeItem:(CMMControlItemComboItem *)item_{
	[self removeItemAtIndex:[self indexOfItem:item_]];
}

-(CMMControlItemComboItem *)itemAtIndex:(uint)index_{
	if(index_ == NSNotFound) return nil;
	return [_itemList objectAtIndex:index_];
}
-(uint)indexOfItem:(CMMControlItemComboItem *)item_{
	return [_itemList indexOfObject:item_];
}

-(void)redraw{
	[super redraw];
	
	ccArray *data_ = _itemList->data;
	float stackHeight_ = _contentSize.height*0.5f;
	for(int index_=data_->num-1;index_>=0;--index_){
		CMMControlItemComboItem *sItem_ = data_->arr[index_];
		CCLabelTTF *mappingLabel_ = [sItem_ mappingLabel];
		[mappingLabel_ setColor:_itemFontColor];
		[mappingLabel_ setOpacity:_itemFontOpacity];
		[mappingLabel_ setFontSize:_itemFontSize];
		
		CGSize labelSize_ = [mappingLabel_ contentSize];
		[mappingLabel_ setPosition:ccp(_contentSize.width*0.5f,stackHeight_+labelSize_.height*0.5f)];
		stackHeight_ += labelSize_.height;
		if(index_ > 0)
			stackHeight_ += marginPerItem;
	}
	CGSize targetSize_ = CGSizeMake(_contentSize.width, MAX(stackHeight_+_contentSize.height*0.5f + marginPerItem,_contentSize.height));
	[[_innerLayer innerLayer] setContentSize:targetSize_];
	
	[_backSprite setContentSize:_contentSize];
	[_frameSprite setContentSize:_contentSize];
	
	[_cursorSprite setContentSize:CGSizeMake(_contentSize.width, _itemFontSize+10.0f)];
	
	[_backSprite setPosition:cmmFunc_positionIPN(self, _backSprite)];
	[_frameSprite setPosition:cmmFunc_positionIPN(self, _frameSprite)];
	[_cursorSprite setPosition:cmmFunc_positionIPN(self, _cursorSprite)];
	
	_snapIndex = index;
	_onSnaped = NO;
	_doSnapDirectly = YES;
}

-(void)update:(ccTime)dt_{
	[super update:dt_];
	if([touchDispatcher touchCount] > 0) return;
	
	if(!_onSnaped){
		if(_snapIndex == NSNotFound && ABS([_innerLayer currentScrollSpeedY]) <= stopToSnapScrollSpeed){
			[_innerLayer setCurrentScrollSpeedY:0.0f];
			
			CGPoint centerPoint_ = [[_innerLayer innerLayer] convertToNodeSpace:[self convertToWorldSpace:ccp(_contentSize.width*0.5f,_contentSize.height*0.5f)]];
			uint minimumIndex_ = 0;
			float minimumDistance_ = [[_innerLayer innerLayer] contentSize].height;
			
			ccArray *data_ = _itemList->data;
			uint count_ = data_->num;
			for(uint index_=0;index_<count_;++index_){
				CMMControlItemComboItem *item_ = data_->arr[index_];
				float itemDistance_ = ccpDistance([[item_ mappingLabel] position], centerPoint_);
				if(itemDistance_ < minimumDistance_){
					minimumDistance_ = itemDistance_;
					minimumIndex_ = index_;
				}
			}
			
			_snapIndex = minimumIndex_;
			
		}else if(_snapIndex != NSNotFound){
			CMMControlItemComboItem *item_ = [_itemList objectAtIndex:_snapIndex];
			CGPoint centerPoint_ = [self convertToWorldSpace:ccp(_contentSize.width*0.5f,_contentSize.height*0.5f)];
			CGPoint itemPoint_ = [[_innerLayer innerLayer] convertToWorldSpace:[[item_ mappingLabel] position]];
			CGPoint diffPoint_ = ccpSub(itemPoint_, centerPoint_);
			diffPoint_.x = 0.0f;
			if(!_doSnapDirectly){
				diffPoint_.y *= snapSpeed*dt_;
			}
			
			CGPoint targetPoint_ = ccpSub([[_innerLayer innerLayer] position], diffPoint_);
			[_innerLayer setInnerPosition:targetPoint_ applyScrolling:NO];
			if(ABS(diffPoint_.y) <= 0.1f){
				[self setIndex:_snapIndex];
				_snapIndex = NSNotFound;
				_onSnaped = YES;
				_doSnapDirectly = NO;
			}
		}
	}
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchBegan:touch_ event:event_];
	_onSnaped = YES;
	_snapIndex = NSNotFound;
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchEnded:touch_ event:event_];
	_onSnaped = NO;
}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{
	[super touchDispatcher:touchDispatcher_ whenTouchCancelled:touch_ event:event_];
	_onSnaped = NO;
}

-(void)cleanup{
	[self setCallback_whenIndexChanged:nil];
	[super cleanup];
}
-(void)dealloc{
	[_callback_whenIndexChanged release];
	[_itemList release];
	[super dealloc];
}

@end

@implementation CMMControlItemCombo(Private)

-(void)_callback_whenItemSelected:(CMMControlItemComboItem *)item_{
	uint targetIndex_ = [self indexOfItem:item_];
	[self setIndex:targetIndex_];
}

@end

@implementation CMMControlItemCombo(Configuration)

+(void)setDefaultItemFontColor:(ccColor3B)color_{
	CMMControlItemComboItemFontColor = color_;
}
+(void)setDefaultItemFontOpacity:(GLubyte)opacity_{
	CMMControlItemComboItemFontOpacity = opacity_;
}
+(void)setDefaultItemFontSize:(float)size_{
	CMMControlItemComboItemFontSize = size_;
}
+(void)setDefaultEdgeOffset:(CMM9SliceEdgeOffset)edgeOffset_{
	CMMControlItemComboEdgeOffset = edgeOffset_;
}

@end
