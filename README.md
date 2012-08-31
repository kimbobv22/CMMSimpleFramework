#CMMSimpleFramework

CMMSimpleframework which coded based on the cocos2d 2.x will be helpful to develop your cocos2d project.

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

CMMSimpleFramework only supports the transition between layers by CMMScene.

CMMSimpleFramework는 레이어간 전환만 지원합니다.

    [[CMMScene sharedScene] pushLayer:(CMMLayer *)];
    
support Pop-up window. 

팝업창을 지원합니다.

    [[CMMScene sharedScene] openPopup:(CMMLayerPopup *) delegate:(id<CMMPopupDispatcherDelegate>)];
    [[CMMScene sharedScene] openPopupAtFirst:(CMMLayerPopup *) delegate:(id<CMMPopupDispatcherDelegate>)];

support Notifications window.

공지창을 지원합니다.

    // 1. Set a template for notification window firstly.(reusable)
    // 1. 먼저 공지창의 템플릿을 설정합니다.
    [[CMMScene sharedScene] noticeDispatcher].noticeTemplate = [(CMMNoticeDispatcherTemplate *) templateWithNoticeDispatcher:(CMMNoticeDispatcher *)];

    // 2. Open notification window.
    // 2. 공지창을 띄웁니다.
    [[[CMMScene sharedScene] noticeDispatcher] addNoticeItemWithTitle:(NSString *) subject:(NSString *)];
    [[[CMMScene sharedScene] noticeDispatcher] addNoticeItemWithTitle:(NSString *) subject:(NSString *)];
    ...(loadable)
    
support Multi-touch Management and Separation.

멀티터치 관리 및 분리를 지원합니다.

    // How to set max count of multi-touch.(default : 4)
    // 최대멀티터치수 설정하는 방법 
    [(CMMTouchDispatcher *) setMaxMultiTouchCount:(int)]


#####CMMLayer

#####CMMLayerMask

CMMLayerMask supports mask for children. also you can change size,position,color,opacity of inner layer.

CMMLayerMask 는 자식들의 마스크기능을 제공합니다. 또한 내부레이어의 크기,위치,색,투명도 를 설정할 수 있습니다.
    
	// How to set property inner layer
	// 내부레이어의 속성을 설정하는 방법
	[(CMMLayerMask *) setInnerColor:(ccColor3B)];
	[(CMMLayerMask *) setInnerOpacity:(GLubyte)];
	[(CMMLayerMask *) setInnerPosition:(CGPoint):];
	[(CMMLayerMask *) setInnerSize:(CGSize)];

#####CMMLayerMaskDrag
#####CMMLayerPinchZoom
#####CMMLayerPopup
#####CMMSprite

###3.Dispatcher

#####CMMTouchDispatcher
#####CMMPopupDispatcher
#####CMMMotionDispatcher
#####CMMNoticeDispatcher

###4.Util

#####CMMDrawingUtil
#####CMMFileUtil
#####CMMFontUtil
#####CMMStringUtil
#####CMMTouchUtil
#####CMMLoadingObject

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