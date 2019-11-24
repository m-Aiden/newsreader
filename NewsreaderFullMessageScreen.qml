import QtQuick 2.1
import qb.components 1.0

Screen {
	id: newsreaderFullMessageScreen
	screenTitle: app.newsSourcesNames[app.selectedNewsSourceIndex]

	function formatDate() {
		var newDate = new Date(app.tmpPubDate);
		var strMinutesNew = newDate.getMinutes();
		if (strMinutesNew < 10) {
			strMinutesNew = "0" + strMinutesNew;
		}

		return newDate.getHours() + ":" + strMinutesNew
	}

	onShown: {
		flickArea.contentY = 0;
	}

	Text {
		id: headerText
		text: formatDate() + " " + app.tmpTitle
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 20 : 16
		anchors {
			top: parent.top
			topMargin: isNxt ? 15 : 12
			left: parent.left
			leftMargin: isNxt ? 15 : 12
		}
	}

	StandardButton {
		id: nextItem
		width: isNxt ? 60 : 48
		height: isNxt ? 60 : 48
		text: ">"
		fontPixelSize: isNxt ? 48 : 44
		color: colors.background
		visible: (app.tmpIndex < app.tmpCount - 1)
		anchors {
			top: headerText.top
			topMargin: isNxt ? -25 : -20
			right: parent.right
			rightMargin: isNxt ? 15 : 12
		}

		onClicked: {
			if (app.tmpIndex < app.tmpCount - 1) {
				app.tmpIndex = app.tmpIndex + 1;
				app.tmpTitle = app.newsreaderScreen.newsreaderNewsModel.get(app.tmpIndex).title;
				app.tmpDescription = app.newsreaderScreen.newsreaderNewsModel.get(app.tmpIndex).description;
				app.tmpPubDate = app.newsreaderScreen.newsreaderNewsModel.get(app.tmpIndex).pubDate;
				flickArea.contentY = 0;
			}
		}
	}

	StandardButton {
		id: backItem
		width: isNxt ? 60 : 48
		height: isNxt ? 60 : 48
		text: "<"
		fontPixelSize: isNxt ? 48 : 44
		color: colors.background
		visible: (app.tmpIndex > 0)
		anchors {
			top: headerText.top
			topMargin: isNxt ? -25 : -20
			right: nextItem.left
			rightMargin: isNxt ? 5 : 4

		}

		onClicked: {
			if (app.tmpIndex > 0) {
				app.tmpIndex = app.tmpIndex - 1;
				app.tmpTitle = app.newsreaderScreen.newsreaderNewsModel.get(app.tmpIndex).title;
				app.tmpDescription = app.newsreaderScreen.newsreaderNewsModel.get(app.tmpIndex).description;
				flickArea.contentY = 0;
			}
		}
	}

	Rectangle {
		id: backgroundRect
		height: isNxt ? parent.height - 55 : parent.height - 44
		width: isNxt ? parent.width - 30 : parent.width - 24
		anchors {
			top: headerText.bottom
			topMargin: isNxt ? 15 : 12
			left: headerText.left
		}
		color: colors.addDeviceBackgroundRectangle

	       Flickable {
	            id: flickArea
	             anchors.fill: parent
	             contentWidth: backgroundRect.width;
		     contentHeight: messageText.height + 100
	             flickableDirection: Flickable.VerticalFlick
	             clip: true

	             TextEdit{
	                  id: messageText
	                   wrapMode: TextEdit.Wrap
	                   width:backgroundRect.width
			   textFormat: TextEdit.RichText
	                   readOnly:true
				font {
					family: qfont.regular.name
					pixelSize: isNxt ? 22 : 18
				}
	                   text:  app.tmpDescription
	            }
	      }
	}
}
