import QtQuick 2.1

import qb.components 1.0
import qb.base 1.0

MenuItem {
	id: newsreaderMenu
	label: qsTr("Newsreader")
	image: "qrc:/tsc/newsreaderTray.png"
	weight: isNxt ? 50 : 40

	onClicked: {
		if (app.newsreaderScreen) app.newsreaderScreen.show();
	}
}
