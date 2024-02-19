package states.stages;

import states.stages.objects.*;

class StageWeek1 extends BaseStage
{	
	override function create()
	{
		var bg:BGSprite = new BGSprite('stageback', -600, -200, 0.9, 0.9);
		add(bg);
		
		var fuck:BGSprite = new BGSprite('bgFreaks', 100, 100, 1, 1);
		add(fuck);
	}
}