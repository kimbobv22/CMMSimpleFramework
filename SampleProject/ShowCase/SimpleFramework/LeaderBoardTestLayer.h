//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMHeader.h"

@interface PlayerItem : CMMMenuItemL{
	CCLabelTTF *_playerNameLb;
	NSString *playerID;
}

@property (nonatomic, copy) NSString *playerID,*playerName;

@end

@interface LeaderBoardTestLayer : CMMLayer{
	CMMScrollMenuV *leaderBoardScrollMenu;
	CCLabelTTF *scroeLabel,*_displayLabel;
	CMMMenuItemL *bitBtn,*reportBtn,*refreshBtn;
	float _score;
}

@end
