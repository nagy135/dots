// Copyright (c) 2011 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Modifications (c) 2013,2014 -- SingleClickApps.com

// Icons Copyright (c) 2014 Derek Nelson (twitter.com/drknlsn)

var prefs;
var icon = 'defaultIcon';

var targetWindow = null;
var tabCount = 0;



function getLocalStoragePrefs() {
	
	// merge_windows_prefs
	if (!window.localStorage.merge_windows_prefs) {
		window.localStorage.merge_windows_prefs = JSON.stringify({ "defaultIcon": true});
	}
	prefs = JSON.parse(window.localStorage.merge_windows_prefs);


    // icon is now inside prefs->colored Icon ...etc.
         if (prefs.redIcon) icon = 'red'
    else if (prefs.greenIcon) icon = 'green'
    else if (prefs.blueIcon) icon = 'blue'
    else if (prefs.yellowIcon) icon = 'yellow'
    else if (prefs.ownIcon) icon = 'own'
    else icon = 'icon24';
    updateIcon(icon);
    
}


function updateIcon(icon) {
    if (icon=="own") {
        //load customer selected icon from storage
         //load custom icon, if set
        if (prefs.ownIcon){
            var img = new Image();
            img.onload = function(){
                var canvas = document.createElement('canvas');
                                    canvas.width = img.width;
                                    canvas.height = img.height;

                                    var context = canvas.getContext('2d');
                                       context.drawImage(img, 0, 0);             
                                    // ...draw to the canvas...
                                    var imageData = context.getImageData(0, 0, 19, 19);
                chrome.browserAction.setIcon({imageData:imageData});
            };
            img.setAttribute("src", prefs.storedCanvas);
            document.getElementById('destination').appendChild(img);

        }
    } else
        chrome.browserAction.setIcon({path:icon + ".png"});
   
}

//set icon on browser startup
chrome.runtime.onStartup.addListener(function() {
 	getLocalStoragePrefs();
});

function start(tab) {
  chrome.windows.getCurrent(getWindows);
}

function getWindows(win) {
  targetWindow = win;
  chrome.tabs.getAllInWindow(targetWindow.id, getTabs);
}

function getTabs(tabs) {
  tabCount = tabs.length;
  // We require all the tab information to be populated.
  chrome.windows.getAll({"populate" : true}, moveTabs);
}

function moveTabs(windows) {
  var numWindows = windows.length;
  var tabPosition = tabCount;

  for (var i = 0; i < numWindows; i++) {
    var win = windows[i];

    if (targetWindow.id != win.id) {
      var numTabs = win.tabs.length;

      for (var j = 0; j < numTabs; j++) {
        var tab = win.tabs[j];
        // Move the tab into the window that triggered the browser action.
        chrome.tabs.move(tab.id,
            {"windowId": targetWindow.id, "index": tabPosition});
        tabPosition++;
		// fix pinned tabs
		if(tab.pinned==true){chrome.tabs.update(tab.id, {"pinned":true});}
      }
    }
  }
}

// Set up a click handler so that we can merge all the windows.
chrome.browserAction.onClicked.addListener(start);
loadSavedSettings();

function loadSavedSettings() {
	
	// app version
	var currVersion = getVersion();
	var prevVersion = window.localStorage.MergeWindows_Version;
	if (currVersion != prevVersion) {
		if (typeof prevVersion == 'undefined') {
			onInstall();
		} else {
			//skip updated with prev.minor
			if (prevVersion != "1.0.1.0")
				onUpdate();
		}
		window.localStorage.MergeWindows_Version = currVersion;
	}

}

//set on uninstall url
chrome.runtime.setUninstallURL('https://singleclickapps.com/merge-windows/removed-chrome.html');

// Check if this is new version
function onInstall() {
	
	if (navigator.onLine) {
		chrome.tabs.create({url: 'https://singleclickapps.com/merge-windows/postinstall-chrome.html'});
	}
}
function onUpdate() {
	
	if (navigator.onLine) {
		chrome.tabs.create({url: 'https://singleclickapps.com/merge-windows/info-chrome-1-4-1.html'});
	}
}
function getVersion() {
	var details = chrome.app.getDetails();
	return details.version;
}

function init() {
	
	getLocalStoragePrefs();
	
}