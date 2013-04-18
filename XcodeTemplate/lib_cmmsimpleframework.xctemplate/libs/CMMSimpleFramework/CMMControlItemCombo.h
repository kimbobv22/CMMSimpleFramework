//
//  CMMControlItemCombo.h
//  SimpleFramework
//
//  Created by Kim Jazz on 13. 4. 9..
//
//

#import "CMMControlItemCheckbox.h"
#import "CMM9SliceBar.h"

@interface CMMControlItemComboItem : NSObject{
	NSString *title;
	id itemValue;
}

+(id)itemWithTitle:(NSString *)title_ itemValue:(id)itemValue_;
-(id)initWithTitle:(NSString *)title_ itemValue:(id)itemValue_;

@property(nonatomic, copy) NSString *title;
@property(nonatomic, retain) id itemValue;

@end

extern ccColor3B CMMControlItemComboItemFontColor;
extern GLubyte CMMControlItemComboItemFontOpacity;
extern float CMMControlItemComboItemFontSize;
extern CMM9SliceEdgeOffset CMMControlItemComboEdgeOffset;

@interface CMMControlItemCombo : CMMControlItem{
	uint index;
	float stopToSnapScrollSpeed,snapSpeed;
	float marginPerItem;
}

+(id)controlItemComboWithFrameSize:(CGSize)frameSize_ backFrame:(CCSpriteFrame *)backFrame_ frame:(CCSpriteFrame *)frame_ cursorFrame:(CCSpriteFrame *)cursorFrame_;
+(id)controlItemComboWithFrameSize:(CGSize)frameSize_ frameSeq:(uint)frameSeq_;

-(id)initWithFrameSize:(CGSize)frameSize_ backFrame:(CCSpriteFrame *)backFrame_ frame:(CCSpriteFrame *)frame_ cursorFrame:(CCSpriteFrame *)cursorFrame_;
-(id)initWithFrameSize:(CGSize)frameSize_ frameSeq:(uint)frameSeq_;

-(void)addItem:(CMMControlItemComboItem *)item_;
-(CMMControlItemComboItem *)addItemWithTitle:(NSString *)title_ itemValue:(id)itemValue_;

-(void)removeItemAtIndex:(uint)index_;
-(void)removeItem:(CMMControlItemComboItem *)item_;

-(CMMControlItemComboItem *)itemAtIndex:(uint)index_;
-(uint)indexOfItem:(CMMControlItemComboItem *)item_;

@property (nonatomic, readwrite) uint index;
@property (nonatomic, readonly) CCArray *itemList;
@property (nonatomic, readwrite) ccColor3B itemFontColor;
@property (nonatomic, readwrite) GLubyte itemFontOpacity;
@property (nonatomic, readwrite) float itemFontSize;
@property (nonatomic, readwrite) float stopToSnapScrollSpeed,snapSpeed;
@property (nonatomic, readwrite) float marginPerItem;
@property (nonatomic, copy) void (^callback_whenIndexChanged)(uint beforeIndex_, uint newIndex_);

-(void)setCallback_whenIndexChanged:(void (^)(uint beforeIndex_, uint newIndex_))block_;

@end

@interface CMMControlItemCombo(Configuration)

+(void)setDefaultItemFontColor:(ccColor3B)color_;
+(void)setDefaultItemFontOpacity:(GLubyte)opacity_;
+(void)setDefaultItemFontSize:(float)size_;
+(void)setDefaultEdgeOffset:(CMM9SliceEdgeOffset)edgeOffset_;

@end
