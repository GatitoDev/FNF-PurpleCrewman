package;

import Achievements;
import editors.MasterEditorMenu;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;

#if desktop
import Discord.DiscordClient;
#end
using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.5.2h'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	private var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

	private var menuItem:FlxSprite;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'awards',
		'credits',
		'options'
	];

	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	public static var debugKeys:Array<FlxKey>;

	private var daFolder:String = 'backgrounds';
	var daBackground:FlxSprite;
	var background:FlxSprite;

	public static var daBGShit:Array<String> = [
		'Desat', 
		'BG', 
		'Magenta', 
		'Purple'
	];

	var selectedSomethin:Bool = false;
	private var scale:Float = 1;

	private var versionShit:FlxText;
	var logoBeat:FlxSprite;

	var daFolderLogo:String = 'logo' + '/' + 'anim';
	private  var daLogo:Array<String> = ['logoBumpin', 'logoCrew'];
	private var daAnimLogo:Array<String> = ['logo bumpin', 'logo crew'];

	override function create()
	{
		WeekData.loadTheFirstEnabledMod();

		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		/*camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;*/

		FlxG.cameras.reset(camGame);
		//FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];
		//FlxG.cameras.setDefaultDrawTarget(camGame, true);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
		persistentUpdate = persistentDraw = true;
		FlxG.mouse.visible = false;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		background = new FlxSprite(-80).loadGraphic(Paths.image(daFolder + '/' + daBGShit[3]));
		background.setGraphicSize(Std.int(background.width * 1.175));
		background.scrollFactor.set(0, yScroll);
		background.updateHitbox();
		background.screenCenter();
		background.visible = true;
		background.active = true;
		background.antialiasing = ClientPrefs.globalAntialiasing;
		add(background);

		daBackground = new FlxSprite(-80).loadGraphic(Paths.image(daFolder + '/' + daBGShit[1]));
		daBackground.setGraphicSize(Std.int(daBackground.width * 1.175));
		daBackground.scrollFactor.set(0, yScroll);
		daBackground.updateHitbox();
		daBackground.screenCenter();
		daBackground.visible = false;
		daBackground.active = true;
		daBackground.antialiasing = ClientPrefs.globalAntialiasing;
		add(daBackground);
		addMenuItems(menuItem);
		addVersionShit(true);//You can remove this if you want.

		logoBeat = new FlxSprite(100, 100);
		logoBeat.frames = Paths.getSparrowAtlas(daFolderLogo + '/' + daLogo[1]);
		logoBeat.animation.addByPrefix('beat', daAnimLogo[1], 24, true);
		logoBeat.setGraphicSize(Std.int(logoBeat.width * 0.5));
		logoBeat.animation.play('beat', true);
		logoBeat.updateHitbox();
		logoBeat.active = true;
		logoBeat.visible = true;
		logoBeat.scrollFactor.set();
		logoBeat.antialiasing = ClientPrefs.globalAntialiasing;
		//add(logoBeat);

		FlxG.camera.follow(camFollowPos, null, 1);
		changeItem();

		super.create();
	}

	private var purpleVersion:String = "V. 1.0";

	private function addVersionShit(visible:Bool):Void {
		versionShit = new FlxText(12, FlxG.height - 46, 0, "Vs. Purple Crewman " + purpleVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, true);
		versionShit.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.26, 1);
		versionShit.borderSize = 2;
		versionShit.visible = visible;
		add(versionShit);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionShit.borderSize = 1.24;
		versionShit.visible = visible;
		//add(versionShit);
	}

	private function addMenuItems(sprite:FlxSprite):Void {
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length){
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 130)  + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');

			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);

			menuItem.y += 45;

			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			menuItem.setGraphicSize(Std.int(menuItem.width * 0.75));
			menuItem.updateHitbox();
		}
	}

	//Do not ask why this was created.
	private function cameraTween(float:Float, duration:Float):Void {
		FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + float}, duration, {ease: FlxEase.circInOut});
	}

	//I borrowed it from TitlteState
	override function beatHit():Void {
		super.beatHit();

		logoBeat.animation.play('beat', true);
		/*if(logoBeat != null){
			logoBeat.animation.play('beat', true);
		}*/
	}

	private function daChangeState(state:Int):Void {
		var daState:Int = state;
		switch (daState){
            case 0://Story Mode
				MusicBeatState.switchState(new StoryMenuState());
			case 1://Free Play
				MusicBeatState.switchState(new FreeplayState());
            case 2://Credits
				MusicBeatState.switchState(new ChangeArtCredits());
            case 3://Options
				LoadingState.loadAndSwitchState(new options.OptionsState());
            case 4://Achievements
				MusicBeatState.switchState(new AchievementsMenuState());
            case 5://Title
				MusicBeatState.switchState(new TitleState());
        }
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8) FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P){
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P){
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK){
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT){
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				if(ClientPrefs.flashing) FlxFlicker.flicker(daBackground, 1.1, 0.15, false);
				cameraTween(0.12, 0.6);

				menuItems.forEach(function(spr:FlxSprite){
					if (curSelected != spr.ID){
						FlxTween.tween(spr, {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween){
								spr.kill();
							}
						});
					} else {
						FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker){
							var daChoice:String = optionShit[curSelected];

							switch (daChoice){
								case 'story_mode':
									daChangeState(0);
								case 'freeplay':
									daChangeState(1);
								case 'awards':
									daChangeState(4);
								case 'credits':
									daChangeState(2);
								case 'options':
									daChangeState(3);
							}
						});
					}
				});
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys)){
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		//Position Spr
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);//Default Position
			/*//var daSprX:Float = 340;
			//spr.x = 400 + daSprX;*/
			spr.x += 330;//It's better this way
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
