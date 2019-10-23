import QtQuick 1.1

import qb.components 1.0
import qb.base 1.0

SystrayIcon {
	id: newsreaderSystrayIcon
	posIndex: 9000
	property string objectName: "newsreaderSystray"
	visible: app.enableSystray

	onClicked: {
		if (app.newsreaderScreen) app.newsreaderScreen.show();
	}

	Image {
		id: imgNewMessage
		anchors.centerIn: parent
		source: "./drawables/newsreaderTray.png"

	}
}
