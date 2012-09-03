#import "GLES-Render.h"

#define PTM_RATIO 32.0f

typedef uint16 CMMb2FixtureType;

typedef int cmmMaskBit;

struct CMMb2ContactMask{
	CMMb2ContactMask(){
		fixtureType = 0x1001;
		maskBit1 = -1;
		maskBit2 = -1;
		checkBit = 1;
		parentBit = -1;
	}
	CMMb2ContactMask(CMMb2FixtureType fixtureType_, cmmMaskBit maskBit1_, cmmMaskBit maskBit2_, cmmMaskBit checkBit_) : fixtureType(fixtureType_), maskBit1(maskBit1_), maskBit2(maskBit2_), checkBit(checkBit_){}
	
	int GetBitCount(const CMMb2ContactMask *otherMask_){
		int totalCount_ = 0;
		
		if(maskBit1>=0 && otherMask_->maskBit1>=0 && maskBit1 == otherMask_->maskBit1)
			totalCount_++;
		if(maskBit2>=0 && otherMask_->maskBit2>=0 && maskBit2 == otherMask_->maskBit2)
			totalCount_++;
		
		return totalCount_;
	}
	bool IsContact(const CMMb2ContactMask *otherMask_){
		if((parentBit>=0 && parentBit == otherMask_->maskBit1)
		   || (otherMask_->parentBit>=0 && otherMask_->parentBit == maskBit1)) return false;
		
		int bitCount_ = GetBitCount(otherMask_);
		return (bitCount_<checkBit || bitCount_<otherMask_->checkBit);
	}
	
	CMMb2FixtureType fixtureType;
	cmmMaskBit maskBit1;
	cmmMaskBit maskBit2;
	cmmMaskBit checkBit;
	cmmMaskBit parentBit;
};

static b2Vec2 b2Vec2Fromccp(float x_, float y_,float divValue_){
	return b2Vec2(x_/divValue_,y_/divValue_);
}
static b2Vec2 b2Vec2Fromccp(float x_, float y_){
	return b2Vec2Fromccp(x_, y_, PTM_RATIO);
}
static b2Vec2 b2Vec2Fromccp(CGPoint point_, float divValue_){
	return b2Vec2Fromccp(point_.x,point_.y, divValue_);
}
static b2Vec2 b2Vec2Fromccp(CGPoint point_){
	return b2Vec2Fromccp(point_.x,point_.y);
}

static CGPoint ccpFromb2Vec2(float x_, float y_,float multValue_){
	return ccp(x_*multValue_,y_*multValue_);
}
static CGPoint ccpFromb2Vec2(float x_, float y_){
	return ccpFromb2Vec2(x_,y_,PTM_RATIO);
}
static CGPoint ccpFromb2Vec2(b2Vec2 vector_, float multValue_){
	return ccpFromb2Vec2(vector_.x,vector_.y,multValue_);
}
static CGPoint ccpFromb2Vec2(b2Vec2 vector_){
	return ccpFromb2Vec2(vector_.x,vector_.y);
}

@protocol CMMSContactProtocol <NSObject>

@required
-(void)whenContractWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_;
-(void)doContractWithFixtureType:(CMMb2FixtureType)fixtureType_ otherObject:(id<CMMSContactProtocol>)otherObject_ otherFixtureType:(CMMb2FixtureType)otherFixtureType_ contactPoint:(CGPoint)contactPoint_ interval:(ccTime)interval_;

@end