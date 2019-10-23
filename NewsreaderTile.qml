import QtQuick 1.1
import qb.components 1.0

Tile {
	id: newsreaderTile

	onClicked: {
	if (app.newsreaderScreen) {
			app.newsreaderScreen.show();
		}
	}
	
	Text {
		id: tiletitle
		text: "Laatste Nieuws"
		anchors {
			baseline: parent.top
			baselineOffset: isNxt ? 30 : 24
			left: parent.left
			leftMargin: isNxt ? 15 : 12

		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 25 : 20
		}
		color: colors.waTileTextColor
       		visible: !dimState
	}
	TextEdit {
		id: newsitemcountLabel
		text: app.tileNewsItem
		anchors {
			baseline: parent.top
			baselineOffset: isNxt ? 62 : 50
			left: tiletitle.left
			right: parent.right
			rightMargin: isNxt ? 15 : 12
		}
		font {
			family: qfont.regular.name
			pixelSize: isNxt ? 22 : 18
		}
		color: colors.waTileTextColor
		wrapMode: Text.WordWrap
		textFormat: TextEdit.RichText
	        readOnly:true
		MouseArea {
			anchors.fill: parent
			onClicked: {
				if (app.newsreaderScreen) {
					app.showDescriptionFirstItem = true;
					app.newsreaderScreen.show();
				}
			}
		}
	}
}
