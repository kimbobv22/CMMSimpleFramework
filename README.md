#CMMSimpleFramework

CMMSimpleframework which coded based on the cocos2d 2.x will be helpful to develop your cocos2d project.

##How to use
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

    [[CMMScene sharedScene] pushLayer:(CMMLayer *)];
    
support Pop-up. 

    [[CMMScene sharedScene] openPopup:(CMMLayerPopup *) delegate:(id<CMMPopupDispatcherDelegate>)];
    
    or
    
    [[CMMScene sharedScene] openPopupAtFirst:(CMMLayerPopup *) delegate:(id<CMMPopupDispatcherDelegate>)];

support Notifications layer. 
support Multi-touch Management and Separation. 

#####CMMLayer
#####CMMLayerMask

CMMLayerMask supports mask for children. also you can change inner size of layer arbitrarily.

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