import QtQuick 2.1
import qb.components 1.0
import BasicUIControls 1.0;

Screen {
	id: newsreaderConfigurationScreen
	screenTitle: "Beheren Nieuwsbronnen"

	onShown: {
		initSourcesList();
		enableSystrayToggle.isSwitchedOn = app.enableSystray;
	}

	function initSourcesList() {

		newsSourcesModel.clear();
		for (var i = 0; i < app.newsSourcesNames.length; i++) {
			newsSourcesModel.append({name: app.newsSourcesNames[i]});
		}
		newsSourceLabel.inputText = app.addNewsSourceName;
		newsSourceURL.inputText = app.addNewsSourceURL;

	}

	function saveNewsSourceLabel(text) {

		if (text) {
			app.addNewsSourceName = text;
			newsSourceLabel.inputText = text;
		}
	}

	function saveNewsSourceURL(text) {

		if (text) {
			app.addNewsSourceURL = text;
			newsSourceURL.inputText = text;
		}
	}

	Text {
		id: headerText
		text: "Toevoegen nieuwsbron(RSS feed):"
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 20 : 16
		anchors {
			top: parent.top
			left: parent.left
			leftMargin: isNxt ? 38 : 30
		}
	}

	EditTextLabel4421 {
		id: newsSourceLabel
		width: isNxt ? 550 : 440
		height: isNxt ? 44 : 35
		leftTextAvailableWidth: isNxt ? 200 : 160
		leftText: "Naam RSS bron:"
		x: isNxt ? 38 : 30
		y: 10

		anchors {
			left: isNxt ? 20 : 16
			top: parent.top
			topMargin: isNxt ? 30 : 24
		}

		onClicked: {
			qkeyboard.open("Voer naam in van de nieuwe rss bron", newsSourceLabel.inputText, saveNewsSourceLabel)
		}
	}

	IconButton {
		id: newsSourceLabelButton;
		width: isNxt ? 50 : 40
		iconSource: "qrc:/tsc/edit.png"

		anchors {
			left: newsSourceLabel.right
			leftMargin: 6
			top: newsSourceLabel.top
		}

		bottomClickMargin: 3
		onClicked: {
			qkeyboard.open("Voer naam in van de nieuwe rss bron", newsSourceLabel.inputText, saveNewsSourceLabel)
		}
	}


	EditTextLabel4421 {
		id: newsSourceURL
		width: newsSourceLabel.width
		height: isNxt ? 44 : 35
		leftTextAvailableWidth: isNxt ? 200 : 160
		leftText: "RSS bron URL:"

		anchors {
			left: newsSourceLabel.left
			top: newsSourceLabel.bottom
			topMargin: 6
		}

		onClicked: {
			qkeyboard.open("Voer URL in van de nieuwe rss bron (http://....)", newsSourceURL.inputText, saveNewsSourceURL)
		}
	}

	Text {
		id: enableSystrayLabel
		width: isNxt ? 200 : 160
		height: isNxt ? 45 : 36
		text: "Icon in systray"
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 25 : 20
		anchors {
			left: addNewsSourceButton.left
			top: newsSourceLabel.top
		}
	}

	OnOffToggle {
		id: enableSystrayToggle
		height: isNxt ? 45 : 36
		anchors.left: enableSystrayLabel.right
		anchors.leftMargin: 10
		anchors.top: enableSystrayLabel.top
		leftIsSwitchedOn: false
		onSelectedChangedByUser: {
			if (isSwitchedOn) {
				app.enableSystray = true;
			} else {
				app.enableSystray = false;
			}
			app.saveNewsSources();			
		}
	}

	IconButton {
		id: newsSourceURLButton;
		width: isNxt ? 50 : 40
		iconSource: "qrc:/tsc/edit.png"

		anchors {
			left: newsSourceURL.right
			leftMargin: 6
			top: newsSourceURL.top
		}

		topClickMargin: 3
		onClicked: {
			qkeyboard.open("Voer URL in van de nieuwe rss bron (http://....)", newsSourceURL.inputText, saveNewsSourceURL)
		}
	}

	StandardButton {
		id: addNewsSourceButton
		width: isNxt ? 275 : 220
		height: isNxt ? 44 : 35
		radius: 5
		text: "Toevoegen RSS bron"
		fontPixelSize: isNxt ? 25 : 20
		color: colors.background
		visible : ((app.addNewsSourceName.length > 2) && (app.addNewsSourceURL.length > 2))

		anchors {
			top: newsSourceURLButton.top
			left: newsSourceURLButton.right
			leftMargin: isNxt ? 15 : 12
		}

		onClicked: {
			var tempNames = app.newsSourcesNames;
			var tempURLs = app.newsSourcesURLs;
			tempNames.push(app.addNewsSourceName);
			tempURLs.push(app.addNewsSourceURL);
			app.newsSourcesNames = tempNames;
			app.newsSourcesURLs = tempURLs;

			initSourcesList();
			app.saveNewsSources();
		}
	}

	Text {
		id: gridText
		text: "Klik op een nieuwsbron om te selekteren of de prullenbak om te verwijderen:"
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 20 : 16
		anchors {
			top: newsSourceURL.bottom
			topMargin: isNxt ? 25 : 20
			left: newsSourceURL.left
		}
	}

	ControlGroup {
		id: newsSourcesGroup
		exclusive: false
	}

	GridView {
		id: newsSourcesGridView

		model: newsSourcesModel
		delegate: NewsreaderConfigurationScreenDelegate {}

		interactive: false
		flow: GridView.TopToBottom
		cellWidth: isNxt ? 320 : 250
		cellHeight: isNxt ? 44 : 36
		height: isNxt ? parent.height - 150 : parent.height - 120
		width: parent.width
		anchors {
			top: newsSourceURL.bottom
			topMargin: isNxt ? 50 : 40
			left: newsSourceURL.left

		}
	}

	ListModel {
		id: newsSourcesModel
	}
}
