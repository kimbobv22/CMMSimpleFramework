//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface PlayerItem : CMMMenuItemLabelTTF{
	CCLabelTTF *_playerNameLb;
	NSString *playerID;
}

@property (nonatomic, copy) NSString *playerID,*playerName;

@end

@interface LeaderBoardTestLayer : CMMLayer<CMMSceneLoadingProtocol,CMMGameKitLeaderBoardDelegate>{
	CMMScrollMenuV *leaderBoardScrollMenu;
	CCLabelTTF *scroeLabel,*_displayLabel;
	CMMMenuItemLabelTTF *bitBtn,*reportBtn,*refreshBtn;
	float _score;
}

@end
