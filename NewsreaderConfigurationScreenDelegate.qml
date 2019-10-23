import QtQuick 1.1
import BasicUIControls 1.0
import qb.components 1.0

Rectangle
{
	width: isNxt ? 320 : 250
	height: isNxt ? 44 : 36
	color: colors.canvas

	StandardButton {
		id: newsSourceButton
		controlGroup: newsSourcesGroup
		width: isNxt ? 250 : 200
		height: isNxt ? 35 : 28
		radius: 5
		text: name
		fontPixelSize: isNxt ? 25 : 20
		color: colors.background

		anchors {
			top: parent.top
			topMargin: isNxt ? 5 : 4
			left: parent.left
			leftMargin: isNxt ? 5 : 4
		}

		onClicked: {
			app.newsSource = app.newsSourcesURLs[model.index];
			app.selectedNewsSourceIndex = model.index;
			app.updateNewsreaderInfo();
			app.saveNewsSources();	
			hide();
		}
	}

	IconButton {
		id: deleteNewsSourceButton
		width: isNxt ? 35 : 28
		height: isNxt ? 35 : 28
		iconSource: "./drawables/icon_delete.png"
		anchors {
			left: newsSourceButton.right
			leftMargin: 6
			top: newsSourceButton.top
		}
		visible: (model.index > 0)
		topClickMargin: 3
		onClicked: {
			qdialog.showDialog(qdialog.SizeLarge, "Bevestiging verwijdering RSS bron", "Wilt U deze RSS bron echt verwijderen uit de lijst:\n\n" + app.newsSourcesNames[model.index] + "\n" + app.newsSourcesURLs[model.index],
					qsTr("Nee"), function(){ },
					qsTr("Ja"), function(){ 
						app.addNewsSourceName = app.newsSourcesNames[model.index];
						app.addNewsSourceURL = app.newsSourcesURLs[model.index];
						app.deleteNewsSource(model.index);
						app.newsreaderConfigurationScreen.initSourcesList();
						app.saveNewsSources();
					});
			
		}
	}
}


