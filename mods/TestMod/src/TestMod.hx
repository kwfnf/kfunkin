package;

import kfunkin.objects.Lane;
import kfunkin.formats.data.ChartNote;
import kfunkin.objects.notes.NoteSingle;
import kfunkin.modding.Mod;
import kfunkin.modding.ModData;
import kfunkin.modding.ClassRegistry;

class TestModNoteSingle extends NoteSingle {

	public function new() {
		super();
	}

	override function getX(time:Float, lane:Lane, note:ChartNote):Float {
		return lane.x + Math.sin((note.time - time) * .01) * 50;
	}

}

class TestMod extends Mod {

	public static function main() new TestMod();

	public function new() {
		ClassRegistry.overwriteClass(NoteSingle, TestModNoteSingle);

		super(
			new ModData('Test Mod', 'MKI')
		);
	}

}
