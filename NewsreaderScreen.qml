import QtQuick 1.1
import SimpleXmlListModel 1.0
import qb.components 1.0


Screen {
	id: newsreaderScreen

	// Newsreader loading indicator
	property bool newsreaderLoaded: false
	// for unit test only
	property alias newsreaderSimpleListCount: newsreaderSimpleList.count
	property alias newsreaderNewsModel: newsreaderModel

	// Function (triggerd by a signal) updates the newsreader list model and the header text
	function updateNewsreaderList() {
		if (app.newsreaderData.length > 0) {
			// Update the newsreader list model
			newsreaderModel.xml = app.newsreaderData;
			newsreaderSimpleList.initialView();
			app.tmpCount = newsreaderSimpleListCount;
		}
		newsreaderLoaded = true;
	}

		// truncate long news item headers

	function getDescriptionHeader(tekst) {
		if (tekst.length > 50) {
			return tekst.substring(0, 50) + "...";
		} else {
			return tekst;
		}
	}

	anchors.fill: parent
	screenTitleIconUrl: "./drawables/newsreader.png"
	screenTitle: "Nieuws"

	Component.onCompleted: {
		app.newsreaderUpdated.connect(updateNewsreaderList)
	}

	onShown: {
		// Initialize new newsreader data request and clear the list model view
		app.newsreaderData = app.newsreaderDataAll;
		addCustomTopRightButton("Wijzig bronnen");
	}

	onCustomButtonClicked: {
		if (app.newsreaderConfigurationScreen) app.newsreaderConfigurationScreen.show();
	}

	Item {
		id: header
		height: isNxt ? 55 : 45
		anchors.horizontalCenter: parent.horizontalCenter
		width: isNxt ? parent.width - 95 : parent.width - 76

		Text {
			id: headerText
			text: "Recente artikelen van " + app.newsSourcesNames[app.selectedNewsSourceIndex]
			font.family: qfont.semiBold.name
			font.pixelSize: isNxt ? 25 : 20
			anchors {
				left: header.left
				bottom: parent.bottom
			}
		}

		StandardButton {
			id: nextItem
			width: isNxt ? 60 : 48
			height: isNxt ? 60 : 48
			text: ">"
			fontPixelSize: isNxt ? 48 : 44
			color: colors.background
			visible: ((app.selectedNewsSourceIndex < app.newsSourcesURLs.length - 1) && (app.newsreaderDataRead))
			anchors {
				top: headerText.top
				topMargin: isNxt ? -20 : -16
				right: parent.right
			}

			onClicked: {
				if (app.selectedNewsSourceIndex < app.newsSourcesURLs.length - 1) {
					app.newsreaderDataRead = false;
					app.newsSource = app.newsSourcesURLs[app.selectedNewsSourceIndex + 1];
					app.selectedNewsSourceIndex = app.selectedNewsSourceIndex + 1;
					app.updateNewsreaderInfo();
					app.saveNewsSources();	
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
			visible: ((app.selectedNewsSourceIndex > 0) && 	(app.newsreaderDataRead))
			anchors {
				top: headerText.top
				topMargin: isNxt ? -20 : -16
				right: nextItem.left
				rightMargin: isNxt ? 5 : 4

			}

			onClicked: {
				if (app.selectedNewsSourceIndex > 0) {
					app.newsreaderDataRead = false;
					app.newsSource = app.newsSourcesURLs[app.selectedNewsSourceIndex - 1];
					app.selectedNewsSourceIndex = app.selectedNewsSourceIndex - 1;
					app.updateNewsreaderInfo();
					app.saveNewsSources();	
				}
			}
		}
	}

	SimpleXmlListModel {
		id: newsreaderModel
		query: "/channel/item"
		roles: ({
			title: "string",
			description: "string",
			pubDate: "string",
			counter: "integer"
		})
	}

	Rectangle {
		id: content
		anchors.horizontalCenter: parent.horizontalCenter
		width: isNxt ? parent.width - 95 : parent.width - 76
		height: isNxt ? parent.height - 94 : parent.height - 75
		y: isNxt ? 64 : 51
		radius: 3

		NewsreaderSimpleList {
			id: newsreaderSimpleList
			delegate: NewsreaderScreenDelegate{}
			dataModel: newsreaderModel
			itemHeight: isNxt ? 30 : 23
			itemsPerPage: 8
			anchors.top: parent.top
			downIcon: "./drawables/arrowScrolldown.png"
			buttonsHeight: isNxt ? 180 : 144
			buttonsVisible: true
			scrollbarVisible: true
		}

		Throbber {
			id: refreshThrobber
			anchors.centerIn: parent
			visible: !newsreaderLoaded
		}
	}
}
