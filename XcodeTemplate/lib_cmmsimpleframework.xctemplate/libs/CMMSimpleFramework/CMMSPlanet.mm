//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSPlanet.h"
#import "CMMStage.h"

@implementation CMMSPlanet
@synthesize gravity,gravityRadius;

+(id)planetWithGravity:(float)gravity_ gravityRadius:(float)gravityRadius_{
	return [[[self alloc] initPlanetWithGravity:gravity_ gravityRadius:gravityRadius_] autorelease];
}

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated{
	if(!(self = [super initWithTexture:texture rect:rect rotated:rotated])) return self;
	
	gravity = -9.8f;
	gravityRadius = 80.0f;
	_curDrawRadius = 0;
	b2CMask = CMMb2ContactMaskMake(0x1003,-1,-1,1);
	
	return self;
}
-(id)initPlanetWithGravity:(float)gravity_ gravityRadius:(float)gravityRadius_{
	if(!(self = [self initWithFile:@"IMG_STG_planet.png"])) return self;
	
	gravity = gravity_;
	gravityRadius = gravityRadius_;
	_curDrawRadius = 0;
	
	return self;
}

-(void)visit{
	[super visit];
	
	_curDrawRadius += gravity>=0?1:-1;
	if(_curDrawRadius>gravityRadius)
		_curDrawRadius = 0;
	else if(_curDrawRadius<0)
		_curDrawRadius = gravityRadius;
	
	glLineWidth(2.0f);
	ccDrawColor4F(0.0f, 0.6f, 0.5f, 0.1f);
	ccDrawCircle(self.position, gravityRadius, 0, 20, NO);
	
	glLineWidth(1.0f);
	ccDrawColor4F(0.0f, 0.3f, 1.0f, 0.05f);
	ccDrawCircle(self.position, _curDrawRadius, 0, 20, NO);
}

-(void)update:(ccTime)dt_{
	[super update:dt_];
	ccArray *objectData_ = stage.world.object_list->data;
	int count_ = objectData_->num;
	for(uint index_=0;index_<count_;++index_){
		CMMSObject *object_ = objectData_->arr[index_];
		CGPoint diffPoint_ = ccpSub(object_.position, self.position);
		float ditance_ = ccpLength(diffPoint_);
		if(object_ == self || ccpLength(diffPoint_)> gravityRadius) continue;
		
		CGPoint objectDiffPoint_ = ccpMult(ccpForAngle(ccpToAngle(diffPoint_)), gravity*(ditance_/gravityRadius));
		b2Body *objectBody_ = object_.body;
		objectBody_->ApplyForceToCenter(objectBody_->GetMass()*b2Vec2(objectDiffPoint_.x,objectDiffPoint_.y));
	}
}

@end

@implementation CMMSPlanet(Box2d)

-(void)buildupBody{
	body = [stage.world createBody:b2_staticBody point:position_ angle:rotationX_];
	body->SetUserData(self);
	
	b2CircleShape bodyBox_;
	bodyBox_.m_radius = (contentSize_.width/2.0f)/PTM_RATIO;
	b2FixtureDef fixtureDef_;
	fixtureDef_.density = 0.5f;
	fixtureDef_.restitution = 0.1f;
	fixtureDef_.shape = &bodyBox_;
	
	body->CreateFixture(&fixtureDef_)->SetUserData(&b2CMask);
	body->SetFixedRotation(true);
}

@end