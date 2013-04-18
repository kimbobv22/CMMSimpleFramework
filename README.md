##Overview 개요
CMMSimpleframework which coded based on Cocos2d v2.1-rc0 will be helpful to develop your cocos2d project!<br>
cocos2d v2.1-rc0 기반으로 짜여진 CMMSimpleframework는 당신의 cocos2d 프로젝트 개발에 도움이 될 

###features
* wirte soon...

##How to use 사용법
1. required Cocos2d v2.1-rc1 library<br>
Cocos2d v2.1-rc1 라이브러리 필요
2. Download template files.<br>
템플릿 파일 다운로드.
3. copy files to `${USER}/Library/Developer/Xcode/Templates/cocos2d v2.x/`<br>
`${USER}/Library/Developer/Xcode/Templates/cocos2d v2.x/` 로 파일을 복사합니다.

**write soon!**

##Migration with exists project 기존프로젝트와 병합
1. copy and add CMMSimpleFramework library to exists project.<br>
CMMSimpleFramework 라이브러리를 기존프로젝트에 복사하고 추가합니다.
2. modify code at `ViewController( : UINavigationController)`<br>
`ViewController( : UINavigationController)`에 코드를 수정합니다.

		@implementation YourViewController
			-(NSUInteger)supportedInterfaceOrientations{…}
			-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{…}
			-(void)directorDidReshapeProjection:(CCDirector*)director_{
				if([director_ runningScene] == nil){
					//touch configuration
					CCGLView *glView_ = (CCGLView *)[director_ view];
					[glView_ setMultipleTouchEnabled:YES];
					[glView_ setTouchDelegate:[CMMScene sharedScene]];
		
					//push scene(only once)
					[director_ pushScene:[CMMScene sharedScene]];
		
					//push layer
					[[CMMScene sharedScene] pushLayer:[HelloWorldLayer node]];
				}
			}
		@end

**write soon!**

##**[Channel Log](https://github.com/kimbobv22/CMMSimpleFramework/blob/master/CHANNELLOG.md)**
