var lastOnUpdateInfo;
var lastOnCreateInfo;

//return 1st active tab
function getActiveTab(callback) {
	chrome.tabs.query({'active': true, lastFocusedWindow: true}, function(tabs) {
		if (tabs) {
			callback(tabs[0]);
		} else {
			callback();
		}
	});
}

function indexOfTab(tabId) {
	var tabs = getTabsFromStorage();
	for(var i = 0; i < tabs.length; i++) {
		if(tabId == tabs[i].id) {
			return i;
		}
	}
	return -1;
}

function updateTabOrder(tabId) {
	var tabs = getTabsFromStorage();
	var idx = indexOfTab(tabId);
	if(idx >= 0) {
		var tab = tabs[idx];
		tabs.splice(idx, 1);
		tabs.unshift(tab);
	}
	localStorage.tabs = JSON.stringify(tabs);
}

function recordTabsRemoved(tabIds, callback) {
	var tabs = getTabsFromStorage();
	for(var j = 0; j < tabIds.length; j++) {
		var tabId = tabIds[j];
		var idx = indexOfTab(tabId);
		if(idx >= 0) {
			var tab = tabs[idx];
			tabs.splice(idx, 1);
		}
	}
	localStorage.tabs = JSON.stringify(tabs);
	if(callback) {
		callback();
	}
}

function switchTabs(tabid, callback) {
	chrome.tabs.update(tabid, {active:true});
	if (callback) {
		callback();
	}
}

var re = /^https?:\/\/.*/;
function isWebUrl(url) {
	return re.exec(url);
}

function filterByWindow(element, index, array) {
	return (element.windowId == localStorage.lastWindowId);
}

function getTabsFromStorage() {
	if (localStorage.tabs) {
		return JSON.parse(localStorage.tabs);		
	} else {
		return [];
	}
}

chrome.commands.onCommand.addListener(function(command) {
	if (command == "toggleTabs") {
		var tabs = getTabsFromStorage();
		switchTabs(parseInt(tabs[1].id));
	}
});

chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {
	if (request.call == "getTabs") {
		chrome.windows.getLastFocused(function (currentWindow) {
			localStorage.lastWindowId = currentWindow.id;
			var tabs = getTabsFromStorage();
			sendResponse({
				"tabs" : tabs.filter(filterByWindow)
			});				
		});
	} else if (request.call == "switchTabs") {
		switchTabs(parseInt(request.id));
	} else if (request.call == "getLocalStorage") {
		sendResponse({
			ls : localStorage
		});
	} else if (request.call == "openDonatePage") {
		chrome.tabs.create({url:"http://jasonsavard.com?ref=recentTabs"})
	} else {
		sendResponse({});
	}
	return true;
});

chrome.tabs.onRemoved.addListener(function(tabId) {
	recordTabsRemoved([tabId], null);
});

chrome.tabs.onCreated.addListener(function(tab) {
	// patch for Chrome bug, because onupdated is called 4 times (twice for on loading and twice for complete)
	var thisOnCreateInfo = JSON.stringify(tab);
	if (lastOnCreateInfo != thisOnCreateInfo) {

		//getActiveTab(function(t2) {
			var tabs = getTabsFromStorage();
			//console.log("oncreate: ");// + JSON.stringify(tabs));
			tabs.unshift(tab);
			localStorage.tabs = JSON.stringify(tabs);
			updateTabOrder(tab.id);
		//});

		lastOnCreateInfo = thisOnCreateInfo;
		
	}
});

chrome.tabs.onUpdated.addListener(function(tabId, changeInfo, tab) {
	// patch for Chrome bug, because onupdated is called 4 times (twice for on loading and twice for complete)
	var thisOnUpdateInfo = JSON.stringify(changeInfo) + " " + JSON.stringify(tab);
	if (lastOnUpdateInfo != thisOnUpdateInfo) {
		
		var tabs = getTabsFromStorage();
		//console.log(tabId + " " + changeInfo.status + " " + changeInfo.url + " " + tab.title);
		//console.log("onupdate: " + tabId);// + JSON.stringify(changeInfo) + " " + JSON.stringify(tab));
		
		
		//tabs[indexOfTab(tabId)] = tab;
		// patch for Chrome 28 because of cached pages not calling oncreated/onupdated (refer to Xin Tao's email)
		var idx = indexOfTab(tabId);
	  	if (idx >= 0) {
	  		tabs[idx] = tab;
	  	} else {
	  		tabs.unshift(tab);
	  	}
		localStorage.tabs = JSON.stringify(tabs);

		lastOnUpdateInfo = thisOnUpdateInfo;
		
		
		// inject code
		if (changeInfo.status == "loading") {
			
			if (!localStorage.enabled || localStorage.enabled == "true") {
				var available = true;
				if (tab.title && tab.title.indexOf("is not available") != -1) {
					available = false;
				}
				//console.log(tab.title + " tab: ", tab)
				if (available && tab.url.indexOf("http") == 0 && tab.url.indexOf("https://chrome.google.com/webstore") == -1 && tab.url.indexOf("chrome://chromewebdata/") == -1) { // make sure it's standard webpage and not extensions:// or ftp:// because errors are generated
					chrome.tabs.executeScript(tabId, {file:"js/common.js", allFrames:true, runAt:"document_start"}, function() {
						chrome.tabs.executeScript(tabId, {file:"js/jquery.js", allFrames:true}, function() {
							chrome.tabs.executeScript(null, {file:"js/injected.js", allFrames:true}, function(result) {
								if (chrome.runtime.lastError) {
									console.log("error: " + chrome.runtime.lastError.message);
							    } else {
							    	//console.log("result", result);						    	
							    }
							});
						});
					});
				}
			}
		}			
		
	}
});

chrome.tabs.onSelectionChanged.addListener(function(tabId, selectInfo) {
	//console.log("onselect: ")
	updateTabOrder(tabId);
});

/*
chrome.windows.onFocusChanged.addListener(function(windowId) {
	//console.log("onfocuschange")
	if (windowId != -1) {
		chrome.tabs.query({windowId:windowId, 'active':true}, function(tab) {
		  //updateTabOrder(tab.id);
		});
	}
});
*/

chrome.runtime.onInstalled.addListener(function(details) {
	if (details.reason == "install") {
		chrome.windows.getAll({populate:true}, function (windows) {
			var tabs = new Array();
			for(var i = 0; i < windows.length; i++) {
				var t = windows[i].tabs;
				for(var j = 0; j < t.length; j++) {
					tabs.push(t[j]);
				}
			}
			localStorage.tabs = JSON.stringify(tabs);
			getActiveTab(function(tab) {
				updateTabOrder(tab.id);
			});
		});
		chrome.tabs.create({url:"startup.html"});
	} else if (details.reason == "update") {
		/* Jason: uncomment if important update that you want users to reloaded their tabs */
		//chrome.tabs.create({url:"startup.html?update=true"});
	}	
});

if (chrome.runtime.setUninstallURL) {
	chrome.runtime.setUninstallURL("https://jasonsavard.com/uninstalled?app=recentTabs");
}