package;

import Achievements;
import animateatlas.HelperEnums.LoopMode;
import editors.MasterEditorMenu;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
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
import flixel.util.FlxGradient;
import lime.app.Application;

using StringTools;
#if desktop
import Discord.DiscordClient;
#end
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

class ChangeArtCredits extends MusicBeatState
{
    public static var daArt:Bool = false;
    var daTextArt:String = '';

    public static var daArray:Array<String> = ['Default', 'OnlyKato'];
    public static var curSelected:Int = 0;

    var background:FlxSprite;
    private var daFolder:String = 'backgrounds';
    public static var daBGShit:Array<String> = [
		'Desat', 
		'BG', 
		'Magenta', 
		'Purple'
	];
    var daText:FlxText;
    var daArtText:FlxText;
    var daTween:FlxTween;

    var descBox:AttachedSprite;

    override function create()
    {
        // Updating Discord Rich Presence
		DiscordClient.changePresence("In the Credits", null);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
		persistentUpdate = persistentDraw = true;
		FlxG.mouse.visible = false;

        background = new FlxSprite();
		background = new FlxSprite(-80).loadGraphic(Paths.image('$daFolder/${daBGShit[0]}'));
        background.color = (FlxColor.fromHSB(FlxG.random.int(0, 359), FlxG.random.float(0, 0.8), FlxG.random.float(0.3, 1)));
		background.scrollFactor.set();
		background.updateHitbox();
		background.visible = true;
		background.active = true;
		background.antialiasing = ClientPrefs.globalAntialiasing;
		add(background);
		background.screenCenter();

        descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		add(descBox);

        daText = new FlxText(0, 0, FlxG.width, (""), 32);
		daText.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		daText.setBorderStyle(OUTLINE, FlxColor.BLACK, 2.42, 1);
		daText.scrollFactor.set();
		add(daText);
		daText.active = true;
		daText.visible = true;
		daText.screenCenter(Y);
        descBox.sprTracker = daText;
		daText.antialiasing = ClientPrefs.globalAntialiasing;

        var text:String = ("Change the art of the icons in the credits"); // This text is in Spanish
        daArtText = new FlxText(0, daText.x + 125, FlxG.width, (text), 32);
        daArtText.setFormat(Paths.font("vcr.ttf"), 36, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		daArtText.setBorderStyle(OUTLINE, FlxColor.BLACK, 2, 1);
		daArtText.scrollFactor.set();
		add(daArtText);
		daArtText.active = true;
		daArtText.visible = true;
		daArtText.antialiasing = ClientPrefs.globalAntialiasing;

        daTextArt = daArray[0];
        daText.text = '< $daTextArt >';
        checkLanguage();

        descBox.setGraphicSize(Std.int(daText.width + 20), Std.int(daText.height + 25));
		descBox.updateHitbox();
    }

    function checkLanguage():Void
    {
        daText.text = '< $daTextArt >';

        if (daArt == false) { // 0
            curSelected = 0;
            daTextArt = daArray[curSelected];
        }
        if (daArt == true) { // 1
            curSelected = 1;
            daTextArt = daArray[curSelected];
        }
    }

    function daTextTween(daTextX:Float, daTextY:Float):Void
    {
        if(daTween != null) {
            daTween.cancel();
        }
        daText.scale.x = daTextX;
        daText.scale.y = daTextY;
        daTween = FlxTween.tween(daText.scale, {x: 1, y: 1}, 0.2, {
            onComplete: function(twn:FlxTween) {
                daTween = null;
            }
        });
    }

    var selectedSomethin:Bool = false;

	@:dox(hide) override function update(elapsed:Float)
    {
        checkLanguage();

        var accepted:Bool = controls.ACCEPT;
        var ui_leftP:Bool = controls.UI_LEFT_P;
        var ui_rightP:Bool = controls.UI_RIGHT_P;

        if (!selectedSomethin)
        {
            if (ui_leftP) {
                daArt = true;
			    FlxG.sound.play(Paths.sound('scrollMenu'));
                checkLanguage();
                daTextTween(1.075, 1.075);
                trace(curSelected);
		    }
		    if (ui_rightP) 
            {
                daArt = false;
			    FlxG.sound.play(Paths.sound('scrollMenu'));
                checkLanguage();
                daTextTween(1.075, 1.075);
                trace(curSelected);
		    }

            if (accepted) 
            {
                selectedSomethin = true;
                FlxG.sound.play(Paths.sound('confirmMenu'));
                daText.color = (FlxColor.YELLOW);

                var daChoice:String = daArray[curSelected];
                switch (daChoice){
                    case 'Default':
                        daArt = false;
                        CreditsState.daNumFolder = 
                        1;
                        MusicBeatState.switchState(new CreditsState());
                    case 'OnlyKato':
                        daArt = true;
                        CreditsState.daNumFolder = 4;
                        MusicBeatState.switchState(new CreditsState());
                }
                trace(daTextArt);
            }

            if (controls.BACK) 
            {
                selectedSomethin = true;
                FlxG.sound.play(Paths.sound('cancelMenu'));
                MusicBeatState.switchState(new MainMenuState());
            }
        }
		super.update(elapsed); 
    }
}