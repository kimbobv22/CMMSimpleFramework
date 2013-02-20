##Version 1.2.1
* [FIX] add default block variable to `CMMScrollMenuV`
* [NEW] add variable `cleanupWhenAllSequencesEnded` to `CMMSequencer`
* [FIX] update `CMMSObjectBatchNode`
	* deprecated method `-(CMMSObject *)createObjectWithRect:(CGRect)rect_`
	* deprecated method `-(CMMSObject *)createObjectWithSpriteFrame:(CCSpriteFrame *)spriteFrame_`
	* deprecated method `-(CMMSObject *)createObject`
	* deprecated method `+(id)batchNodeWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_`
	* deprecated method `-(id)initWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_`
	* deprecated variable `fileName`
	* deprecated variable `isInDocument`
	* deprecated variable `objectClass`
* [FIX] update `CMMSObject`
	* change method `-(void)buildupBody` to `-(void)buildupBodyWithWorld:(CMMStageWorld *)world_`
	* deprecated variable `addToBatchNode`
* [FIX] update `CMMStageWorld`
	* deprecated method `-(CMMSObjectBatchNode *)addObatchNodeWithFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_`
	* deprecated method `-(void)removeObatchNodeAtFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_`
	* deprecated method `-(CMMSObjectBatchNode *)obatchNodeAtFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_`
	* deprecated method `-(int)indexOfObatchNodeFileName:(NSString *)fileName_ isInDocument:(BOOL)isInDocument_`
	* add method `-(void)addObject:(CMMSObject *)object_ buildInObatchNode:(BOOL)buildInObatchNode_`
* [FIX] `CMMSPlanet` class file merged to `CMMSObject_test` class file.