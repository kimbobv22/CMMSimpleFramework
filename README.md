#CMMSimpleFramework

CMMSimpleframework which coded based on the cocos2d 2.x will be helpful to develop your cocos2d project!<br>
cocos2d 2.x 기반으로 짜여진 CMMSimpleframework는 당신의 cocos2d 프로젝트 개발에 도움이 될 것입니다!

##How to use

    // Just import.
    #import "CMMHeader.h"
    
##Class List - Common

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
>support Pop-up window. <br>
>팝업창을 지원합니다.

    [[CMMScene sharedScene] openPopup:(CMMLayerPopup *) delegate:(id<CMMPopupDispatcherDelegate>)];
    [[CMMScene sharedScene] openPopupAtFirst:(CMMLayerPopup *) delegate:(id<CMMPopupDispatcherDelegate>)];

<br>
>support Notifications window.<br>
>공지창을 지원합니다.

    // 1. Set a template for notification window firstly.(reusable)
    // 1. 먼저 공지창의 템플릿을 설정합니다.
    [[CMMScene sharedScene] noticeDispatcher].noticeTemplate = [(CMMNoticeDispatcherTemplate *) templateWithNoticeDispatcher:(CMMNoticeDispatcher *)];

    // 2. Open notification window.
    // 2. 공지창을 띄웁니다.
    [[[CMMScene sharedScene] noticeDispatcher] addNoticeItemWithTitle:(NSString *) subject:(NSString *)];
    [[[CMMScene sharedScene] noticeDispatcher] addNoticeItemWithTitle:(NSString *) subject:(NSString *)];
    ...(loadable)

<br>
>support Multi-touch Management and Separation.(Refer the CMMTouchDispatcher)<br>
>멀티터치 관리 및 분리를 지원합니다.(CMMTouchDipatcher 참고)

<br>

#####CMMLayer

>CMMLayer는 CMMSimpleFramework에서 최상위 레이어 노드입니다.
>모든 CMMLayer는 독립적으로 멀티터치(최대멀티터치수 등)를 관리할 수 있습니다.

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
>CMMLayerMaskDrag는 CMMLayerMask에서 드래그기능이 추가되었습니다.

	// How to allow dragging
	// 드래그 허용하는 방법
	[(CMMLayerMaskDrag *) setIsCanDragX:(BOOL)] //X-Axis X축
	[(CMMLayerMaskDrag *) setIsCanDragY:(BOOL)] //Y-Axis Y축
	
<br>	

>스크롤바의 디자인을 제약적으로 변경할 수 있습니다.

<br>

#####CMMLayerPinchZoom

>CMMLayerPinchZoom는 핀치줌이 가능합니다.

<br>

#####CMMLayerPopup

>팝업창을 위한 레이어입니다. CMMLayerPopup를 상속받아 독창적인 팝업창을 제작할 수 있습니다.

<br>

#####CMMSprite

>CMMSprite는 CMMSimpleFramework에서 터치를 입력받을 수 있는 스프라이트 노드입니다.

<br>

###3.Dispatcher

#####CMMTouchDispatcher

>support Multi-touch Management and Separation.<br>
>멀티터치 관리 및 분리를 지원합니다.

    // How to set max count of multi-touch.(default : 4)
    // 최대멀티터치수 설정하는 방법 
    [(CMMTouchDispatcher *) setMaxMultiTouchCount:(int)]
    
<br>
    
#####CMMPopupDispatcher

>CMMScene에서 팝업을 관리할 수 있도록 디자인되었습니다.

<br>

#####CMMMotionDispatcher

>가속도센서를 관리할 수 있도록 디자인되었습니다.
>CMMLayer을 등록하여 사용할 수 있습니다.

<br>

#####CMMNoticeDispatcher

>CMMScene에서 공지를 관리할 수 있도록 디자인되었습니다.

<br>

###4.Util

#####CMMDrawingUtil

>CCRenderTexture를 사용하여 이미지를 그리거나, 수정할 수 있도록 디자인되었습니다.

<br>

#####CMMFileUtil

>파일 불러오기, 검증 등을 할 수 있도록 디자인되었습니다.

<br>

#####CMMFontUtil

>CCLabelTTF 객체를 보다 쉽게 만들 수 있도록 디자인되었습니다.

<br>

#####CMMStringUtil

>파일경로를 NSString 형식으로 변환해주거나, 다른 NSString 을 변경할 수 있도록 디자인되었습니다.

<br>

#####CMMTouchUtil

>터치좌표를 구하거나, 터치안에 있는 노드를 쉽게 찾을 수 있도록 디자인되었습니다.

<br>

#####CMMLoadingObject

>로딩을 보다 쉽게 구현할 수 있도록 디자인되었습니다.

<br>

##Class List - Component

###1.Manager

#####CMMDrawingManager

###2.Stage

#####CMMStage
#####CMMTilemapStage
#####CMMSSpec
#####CMMSSpecStage
#####CMMSParticle
#####CMMSObject
#####CMMSSpecObject
#####CMMSStateObject

###3.menu

#####CMMMenuItem
#####CMMScrollMenu
#####CMMScrollMenuH
#####CMMScrollMenuV

###4.control

#####CMMControlItem
#####CMMControlItemSwitch
#####CMMControlItemSlider
#####CMMControlItemText

###5.customUI

#####CMMCustomUI
#####CMMCustomUIJoypad