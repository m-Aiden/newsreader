import QtQuick 1.1
import qb.components 1.0

Rectangle {

	id: newsreaderScreenDelegate

	property int indexOfThisDelegate: index

	// truncate long news item titles
	function getDescriptionHeader() {
		if (title.length > 70) {
			return title.substring(0, 67) + "...";
		} else {
			return title;
		}
	}

	function formatDate() {
		var newDate = new Date(pubDate);
		var strMinutesNew = newDate.getMinutes();
		if (strMinutesNew < 10) {
			strMinutesNew = "0" + strMinutesNew;
		}

		return newDate.getHours() + ":" + strMinutesNew
	}

	width: isNxt ? 870 : 646
	height: isNxt ? 45 : 34

	MouseArea {
		anchors.fill: parent
		onClicked: {
			app.tmpTitle = title;
			app.tmpDescription = description;
			app.tmpPubDate = pubDate;
			app.tmpIndex = counter;
			app.newsreaderFullMessageScreen.show();
		}
	}

	Text {
		id: newstitleLabel
		x: 10
		anchors.baseline: parent.top
		anchors.baselineOffset: isNxt ? 30 : 24
		text: getDescriptionHeader()
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 22 : 18

	}
	Text {
		id: newsDate
		x: 0
		anchors.top: newstitleLabel.top
		anchors.topMargin: isNxt ? -10 : -8
		anchors.right: parent.right
		anchors.rightMargin: isNxt ? 15 : 12
		text: formatDate()
		font.family: qfont.regular.name
		font.pixelSize: isNxt ? 15 : 12
	}
}
