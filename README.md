#CMMSimpleFramework

CMMSimpleframework which coded based on the cocos2d 2.x will be helpful to develop your cocos2d project!<br>
cocos2d 2.x 기반으로 짜여진 CMMSimpleframework는 당신의 cocos2d 프로젝트 개발에 도움이 될 것입니다!

##How to use

	// 1. Import "CMMGLView.h" and replace CCGLView to CMMGLView at AppDelegate.mm.
	// 1. AppDelegate.mm에 "CMMGLView.h"를 임포트하고, CCGLView를 CMMGLView로 교체합니다.
    
	CMMGLView *glView = [CMMGLView viewWithFrame:[window_ bounds]
					pixelFormat:kEAGLColorFormatRGB565
					depthFormat:0
					preserveBackbuffer:NO
					sharegroup:nil
					multiSampling:NO
					numberOfSamples:0];
					
	// 2. Import "CMMScene.h" and replace Intro layer that made by CCScene to CMMScene intro layer at AppDelegate.mm.
	// 2. "CMMScene.h"를 임포트하고, CMMScene 인트로 레이어로 CCScene로 만든 인트로 레이어를 교체합니다.
	
	[director_ pushScene:[CMMScene sharedScene]];
	[[CMMScene sharedScene] pushLayer:(CMMLayer *)];
	
	//3. The class that can be used to "CMMScene scene transition" is only CMMLayer or a class that inherited CMMLayer.
	//   You can use all features of CMMSimpleFramework through importing "CMMHeader.h"!
	//3. CMMScene의 화면전환으로 사용할 수 있는 클래스는 CMMLayer나, CMMLayer를 상속받은 것만 가능합니다.
	//   해당 클래스에서 "CMMHeader.h" 를 상속받음으로 CMMSimpleFramework의 모든 기능을 사용하세요!
	
	#import "CMMHeader.h"

	@interface HelloWorldLayer : CMMLayer{
	}
	@end

<br>
    
##Class List - Common

>The classes in "Common" required for running of CMMSimpleFramework.<br>
>"Common"의 클래스는 CMMSimpleFramework를 실행하기 위해 필요합니다.

<br>

###1.Common

#####CMMHeader
#####CMMType
#####CMMMacro
#####CMMGLView

###2.View

#####CMMScene

>CMMSimpleFramework only supports the transition between layers(CMMLayer) by CMMScene.<br>
>CMMSimpleFramework는 레이어(CMMLayer)간 전환만 지원합니다.

    [[CMMScene sharedScene] pushLayer:(CMMLayer *)];

<br>
>Support Pop-up window. <br>
>팝업창을 지원합니다.

    [[CMMScene sharedScene] openPopup:(CMMLayerPopup *) delegate:(id<CMMPopupDispatcherDelegate>)];
    [[CMMScene sharedScene] openPopupAtFirst:(CMMLayerPopup *) delegate:(id<CMMPopupDispatcherDelegate>)];

<br>
>Support Notifications window. (Refer CMMNoticeDispatcher><br>
>알림창을 지원합니다. (CMMNoticeDispatcher 참고)

<br>

>Support Multi-touch management and separation.(Refer CMMTouchDispatcher)<br>
>멀티터치 관리 및 분리를 지원합니다.(CMMTouchDipatcher 참고)

<br>

#####CMMLayer

>CMMLayer is "Top layer node" in CMMSimpleFramework.<br>
>CMMLayer는 CMMSimpleFramework에서 "최상위 레이어 노드"입니다.

>CMMLayer can manage Multi-touch(Max Multi-touch count, etc...) Individually.(Refer CMMTouchDispatcher)<br>
>CMMLayer는 독립적으로 멀티터치(최대멀티터치수 등...)를 관리할 수 있습니다.(CMMTouchDispatcher 참고)

<br>

#####CMMLayerMask

>CMMLayerMask supports mask for children. also you can change size,position,color,opacity of inner layer.<br>
>CMMLayerMask 는 자식들의 마스크기능을 제공합니다. 또한 내부레이어의 크기,위치,색,투명도 를 설정할 수 있습니다.
    
	// How to set property inner layer
	// 내부레이어의 속성을 설정하는 방법
	[(CMMLayerMask *) setInnerColor:(ccColor3B)];
	[(CMMLayerMask *) setInnerOpacity:(GLubyte)];
	[(CMMLayerMask *) setInnerPosition:(CGPoint):];
	[(CMMLayerMask *) setInnerSize:(CGSize)];

<br>

#####CMMLayerMaskDrag

>CMMLayerMaskDrag is that from CMMLayerMask added dragging feature.<br>
>CMMLayerMaskDrag는 CMMLayerMask에서 드래그기능을 추가한 것 입니다.

	// How to allow dragging
	// 드래그 허용하는 방법
	[(CMMLayerMaskDrag *) setIsCanDragX:(BOOL)]; //X-Axis X축
	[(CMMLayerMaskDrag *) setIsCanDragY:(BOOL)]; //Y-Axis Y축
	
<br>	

>You can change the design of the scrollbar conditionally.<br>
>스크롤바의 디자인을 제약적으로 변경할 수 있습니다.

	// How to change design of scrollbar
	// 스크롤바 디자인 변경방법
	[(CMMLayerMaskDrag *) setScrollbarDesign:(CMMScrollbarDesign)];

<br>

#####CMMLayerPinchZoom

>CMMLayerPinchZoom is available Pinch-Zoom.<br>
>CMMLayerPinchZoom는 핀치줌이 가능합니다.

<br>

#####CMMLayerPopup

>Layer for Pop-up. You can create creative Pop-up window by inheriting CMMLayerPopup.<br>
>팝업창을 위한 레이어입니다. CMMLayerPopup를 상속받아 독창적인 팝업창을 제작할 수 있습니다.

<br>

#####CMMSprite

>CMMSprite is "the Sprite node that can be received the touch input" in CMMSimpleFramework.<br>
>CMMSprite는 CMMSimpleFramework에서 터치를 입력받을 수 있는 스프라이트 노드입니다.

<br>

###3.Dispatcher

#####CMMTouchDispatcher

>Support Multi-touch Management and Separation.<br>
>멀티터치 관리 및 분리를 지원합니다.

    // How to set max count of multi-touch.(default : 4)
    // 최대멀티터치수 설정하는 방법 
    [(CMMTouchDispatcher *) setMaxMultiTouchCount:(int)]
    
<br>
    
#####CMMPopupDispatcher

>Designed for Pop-up management in CMMScene. (Refer the CMMScene)<br>
>CMMScene에서 팝업을 관리할 수 있도록 디자인되었습니다. (CMMScene 참고)

<br>

#####CMMMotionDispatcher

>designed for Accelerometer management. Supported in CMMLayer.<br>
>가속도계를 관리할 수 있도록 디자인되었습니다. CMMLayer에서 사용가능합니다.

	[(CMMLayer *) setIsAccelerometerEnabled:(BOOL)];
	
	//and add syntax in class
	//그리고 클래스에 구문을 추가합니다.
	-(void)motionDispatcher:(CMMMotionDispatcher *)motionDispatcher_ updateMotion:(CMMMotionState)state_{}

<br>

#####CMMNoticeDispatcher

>Designed for Notification management in CMMScene.<br>
>CMMScene에서 알림를 관리할 수 있도록 설계되었습니다.

	// 1. First, set a template for notification window.(reusable 재사용가능)
	// 1. 먼저 공지창의 템플릿을 설정합니다.
	[(CMMNoticeDispatcher *).noticeTemplate = [(CMMNoticeDispatcherTemplate *) templateWithNoticeDispatcher:(CMMNoticeDispatcher *)];

	// 2. Open notification window.
	// 2. 공지창을 띄웁니다.
	[(CMMNoticeDispatcher *) addNoticeItemWithTitle:(NSString *) subject:(NSString *)];
	[(CMMNoticeDispatcher *) addNoticeItemWithTitle:(NSString *) subject:(NSString *)];
	...(loadable 적재가능)

<br>

###4.Util

#####CMMDrawingUtil

>Designed for Image Drawing & Modify by using CCRenderTexture.<br>
>CCRenderTexture를 사용하여 이미지를 그리거나, 수정할 수 있도록 디자인되었습니다.

<br>

#####CMMFileUtil

>Designed for File Loading & Checking & etc....<br>
>파일 불러오기, 검증 등을 할 수 있도록 디자인되었습니다.

<br>

#####CMMFontUtil

>Designed for Creating CCLabelTTF easily.<br>
>CCLabelTTF 객체를 쉽게 만들 수 있도록 디자인되었습니다.

<br>

#####CMMStringUtil

>Designed for Converting to NSString from Filepath, Modify other NSString.<br>
>파일경로를 NSString으로 변환하거나, 다른 NSString을 수정할 수 있도록 디자인되었습니다.

<br>

#####CMMTouchUtil

>Designed for Finding touch point &Finding node that contacting with the touch.<br>
>터치좌표를 구하거나, 터치와 접촉하는 노드를 쉽게 찾을 수 있도록 디자인되었습니다.

<br>

#####CMMLoadingObject

>Designed for implementing loading feature easily.<br>
>로딩을 쉽게 구현할 수 있도록 디자인되었습니다.

<br>

>Perform Loading through "Loading formatter". for example, "Loading formatter" is "test%03d", and the method "test000","test001","test002","test003" is existed in the target class.
 "Loading object" call the method sequentially. "test000","test001","test002","test003".
 when ended loading , call the callback method through delegate class
><br>
><br>
>"Loading formatter"를 통해 로딩을 수행합니다. 예를 들어 "Loading formatter"가 @"test%03d", 해당 클래스에 메소드 "test000","test001","test002","test003"
가 존재합니다. "Loading object"는 순차적으로 "test000","test001","test002","test003"를 호출합니다. 로딩이 끝나면, delegate 클래스를 통해 callback 함수를 호출합니다.

	CMMLoadingObject *loadingObject_ = [CMMLoadingObject loadingObject];
	loadingObject_.delegate = (id<CMMLoadingObjectDelegate>)(id);
	
	 // Default Loading formatter (@"loadingProcess%03d")
	 // 기본 Loading formatter (@"loadingProcess%03d")
	[loadingObject_ startLoading];
	
	// Custom Loading formatter
	// 커스텀 Loading formatter
	[loadingObject_ startLoadingWithMethodFormatter:(NSString *)];
	
	// Custom Loading formatter & custom target class
	// 커스텀 Loading formatter & 임의 해당 클래스
	[loadingObject_ startLoadingWithMethodFormatter:(NSString *) target:(id)];

<br>

##Class List - Component

>The classes in "Component" not required for running of CMMSimpleFramework essentially.<br>
>but, You can design the Menu that has powerful features easily through them.
><br>
><br>
>"Component"의 클래스는 CMMSimpleFramework를 실행하기 위해 반드시 필요하지는 않습니다.<br>
>하지만, 이것들을 통해 강력한 기능을 가진 메뉴를 쉽게 설계할 수 있습니다.

<br>

###1.Manager

#####CMMDrawingManager

>CMMDrawingManager can load Specified size frame through Sprite frame predesigned.<br>
>also, It can be prevented memory leak because loaded frame managed by storing.
><br>
><br>
>CMMDrawingManager는 미리 설계한 Sprite frame을 통해, 지정된 크기의 프레임을 가져올 수 있습니다.<br>
>또한, 불러온 프레임을 적재하여 관리하기 때문에, 메모리 낭비를 막을 수 있습니다.

<br>

###2.Stage

#####CMMStage

>CMSStage including Box2d 2D physics engine is easy to manage Creating & Deleting the object.<br>
>Provide variety delegate method & Great extensible.
><br>
><br>
>Box2d 2D 물리엔진이 포함된 CMMStage는 오브젝트 생성 및 삭제 관리가 용이합니다.<br>
>다양한 delegate method 제공 & 뛰어난 확장성.

<br>

#####CMMTilemapStage

>TMX파일을 분석하여 Box2d 맵을 만들어 냅니다.

<br>

#####CMMSSpec
#####CMMSSpecStage
#####CMMSParticle
#####CMMSObject
#####CMMSSpecObject
#####CMMSStateObject

###3.menu

#####CMMMenuItem

>CMMMenuItem는 메뉴, 버튼 등 다양한 용도로 사용할 수 있습니다.

<br>

#####CMMScrollMenu

>CMMSimpleFramework에는 수직,수평 스크롤이 가능한 메뉴를 제공합니다.

#####CMMScrollMenuV
#####CMMScrollMenuH

###4.control

#####CMMControlItem
#####CMMControlItemSwitch
#####CMMControlItemSlider
#####CMMControlItemText

###5.customUI

#####CMMCustomUI
#####CMMCustomUIJoypad