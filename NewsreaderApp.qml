import QtQuick 1.1
import BxtClient 1.0
import FileIO 1.0

import qb.components 1.0
import qb.base 1.0;

App {
	id: newsreaderApp
	property url fullScreenUrl : "NewsreaderScreen.qml"
	property url fullMessageScreenUrl : "NewsreaderFullMessageScreen.qml"
	property url fullConfigurationScreenUrl : "NewsreaderConfigurationScreen.qml"
	property url tileUrl : "NewsreaderTile.qml"
	property url thumbnailIcon: "./drawables/newsreader.png"
	property url newsreaderMenuIconUrl: "./drawables/newsreader.png"
	property url trayUrl : "NewsreaderTray.qml";
	property NewsreaderScreen newsreaderScreen
	property NewsreaderFullMessageScreen newsreaderFullMessageScreen
	property NewsreaderConfigurationScreen newsreaderConfigurationScreen
	property string newsSource

	// user settings from config file
	property variant newsreaderSettingsJson : {
		'Newsfeeds': [],
		'TrayIcon': "",
		'LastUsedSourceIndex': ""
	}

	// derived from user settings
	property variant newsSourcesNames : []  	// array of news sources (friendly names)
	property variant newsSourcesURLs : []		// array of corresponding rss feed urls
	property int selectedNewsSourceIndex : 0	// active news source (index in array above)
	property bool enableSystray			// flag whether news icon is shown in the systray

	// Newsreader data in XML string format
	property string newsreaderData			// input for xml model
	property string newsreaderDataAll
	property bool newsreaderDataRead: false

	// name and url for new source to be added
	property string addNewsSourceName
	property string addNewsSourceURL
	property bool showDescriptionFirstItem: false
	property string debugText: "noppes"

	// header and description of the latest news item, header will be shown on the tile, description shown in dialog box when clicked on the tile
	property string tileNewsItem
	property string tileNewsItemDescription
	// header and description of the selected news item for full screen view
	property string tmpTitle
	property string tmpDescription
	property string tmpPubDate
	property int tmpIndex
	property int tmpCount

	// Newsreader signals, used to update the listview and filter enabled button
	signal newsreaderUpdated()

	FileIO {
		id: newsreaderSettingsFile
		source: "file:///mnt/data/tsc/newsreader.userSettings.json"
 	}

	// Init the newsreader app by registering the widgets
	function init() {
		registry.registerWidget("tile", tileUrl, this, null, {thumbLabel: qsTr("Nieuws"), thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, thumbIconVAlignment: "center"});
		registry.registerWidget("screen", fullScreenUrl, this, "newsreaderScreen");
		registry.registerWidget("screen", fullConfigurationScreenUrl, this, "newsreaderConfigurationScreen");
		registry.registerWidget("screen", fullMessageScreenUrl, this, "newsreaderFullMessageScreen");
		registry.registerWidget("menuItem", null, this, null, {objectName: "newsreaderMenuItem", label: "Nieuws", image: newsreaderMenuIconUrl, screenUrl: fullScreenUrl, weight: 120});
		registry.registerWidget("systrayIcon", trayUrl, this, "newsreaderTray");
	}


	Component.onCompleted: {

		// read user settings

		try {
			newsreaderSettingsJson = JSON.parse(newsreaderSettingsFile.read());
			if (newsreaderSettingsJson['TrayIcon'] == "Yes") {
				enableSystray = true
			} else {
				enableSystray = false
			}
			selectedNewsSourceIndex = newsreaderSettingsJson['LastUsedSourceIndex'];		
		} catch(e) {
		}
		tmpIndex = selectedNewsSourceIndex;

		// convert JSON object to separate arrays for names and url's

		var tmpNewsSourcesNames = [];
		var tmpNewsSourcesURLs = [];

		for (var i = 0; i < newsreaderSettingsJson['Newsfeeds'].length; i++) {
			var tmp = newsreaderSettingsJson['Newsfeeds'][i].split("@");
			tmpNewsSourcesNames.push(tmp[0]);
			tmpNewsSourcesURLs.push(tmp[1]);
		}

		newsSourcesNames = tmpNewsSourcesNames;
		newsSourcesURLs = tmpNewsSourcesURLs;

		// set last used news source as active one
		newsSource = newsSourcesURLs[selectedNewsSourceIndex];

		// read rss feed
		updateNewsreaderInfo();
	}

	function deleteNewsSource(itemIndex) {


		// delete the item at index itemIndex from both arrays		
		var tmpNames = [];
		var tmpURLs = [];
		var newSourceToShow = (newsSourcesURLs[itemIndex] == newsSource)

		for (var i = 0; i < newsSourcesNames.length; i++) {
		if (i !== itemIndex) {		// skip the item to be deleted
				tmpNames.push(newsSourcesNames[i]);
				tmpURLs.push(newsSourcesURLs[i]);
			}
		}
		newsSourcesNames = tmpNames;
		newsSourcesURLs = tmpURLs;

		// if deleted item was the active one, select the first news source from the last as new active one and read the rss feed
		if (newSourceToShow) {
			newsSource = newsSourcesURLs[0];
			selectedNewsSourceIndex = 0
			updateNewsreaderInfo();
		}
	}

	function saveNewsSources() {
		
		// save user settings

		var tmpFeeds = [];
		for (var i = 0; i < newsSourcesNames.length; i++) {
			tmpFeeds.push(newsSourcesNames[i] + "@" + newsSourcesURLs[i]);
		}

		var tmpTrayIcon = "";
		if (enableSystray == true) {
			tmpTrayIcon = "Yes";
		} else {
			tmpTrayIcon = "No";
		}

 		var tmpUserSettingsJson = {
			"Newsfeeds" : tmpFeeds,
			"TrayIcon" : tmpTrayIcon,
			"LastUsedSourceIndex" : selectedNewsSourceIndex
		}

  		var doc3 = new XMLHttpRequest();
   		doc3.open("PUT", "file:///mnt/data/tsc/newsreader.userSettings.json");
   		doc3.send(JSON.stringify(tmpUserSettingsJson ));
	}

	function updateNewsreaderInfo() {
		
		// read rss feed

		tileNewsItem = "Even geduld";
		tileNewsItemDescription = "Even geduld";
		var counter = 0;

		var xmlhttp = new XMLHttpRequest();
		xmlhttp.onreadystatechange=function() {

			// create a simplified version of the RSS XML feed to be compliant with the Toon xml model implementation)

			if (xmlhttp.readyState == XMLHttpRequest.DONE) {
				var inputXML = "<channel>";
				var a = xmlhttp.responseText;
				var j = a.indexOf("<channel>");
				var i = a.indexOf("<item>", j);
				var k = 0;

				while (i > 0) {

						// save title
					j = a.indexOf("<title>", i);
					k = a.indexOf("</title>", j);
					inputXML = inputXML + "<item>" + a.substring(j, k+8);

					if (tileNewsItem == "Even geduld") {
						tileNewsItem = a.substring(j+7, k);
						tileNewsItem = tileNewsItem.replace("<![CDATA[","");
						tileNewsItem = tileNewsItem.replace("]]>","");
					}

						//save description
					j = a.indexOf("<description>", i);
					k = a.indexOf("</description>", j);
					inputXML = inputXML + a.substring(j, k+14);

					if (tileNewsItemDescription == "Even geduld") {
						tileNewsItemDescription = a.substring(j+13, k);
						tileNewsItemDescription = tileNewsItemDescription .replace("<![CDATA[","");
						tileNewsItemDescription = tileNewsItemDescription .replace("]]>","");
					}

						//save publication date
					j = a.indexOf("<pubDate>", i);
					k = a.indexOf("</pubDate>", j);
					inputXML = inputXML + a.substring(j, k+10);
					inputXML = inputXML + "<counter>" + counter + "</counter></item>";
					counter = counter + 1;

					i = a.indexOf("<item>", j);
				}
				inputXML = inputXML + "</channel>";

				// done, show results on screen
				newsreaderDataRead = true;
				newsreaderDataAll = inputXML;
				newsreaderData = newsreaderDataAll;
				newsreaderUpdated();

			}
		}
		xmlhttp.open("GET", newsSource, true);
		xmlhttp.send();
	}

		// timer to refresh rss feed every 10 minutes
	Timer {
		id: datetimeTimerFiles
		interval: 600000			//update every 10 mins
		triggeredOnStart: false
		running: true
		repeat: true
		onTriggered: updateNewsreaderInfo()
	}
}
