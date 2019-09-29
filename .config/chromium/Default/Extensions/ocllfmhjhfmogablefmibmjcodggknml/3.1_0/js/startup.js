//return 1st active tab
function getActiveTab(callback) {
	chrome.tabs.query({'active': true}, function(tabs) {
		if (tabs) {
			callback(tabs[0]);
		} else {
			callback();
		}
	});
}

function extensionBannedTab(tab) {
	return tab.url.indexOf("chrome://extensions") != -1 || tab.url.indexOf("https://chrome.google.com/extensions") != -1;
}

function tabImage(tab) {
	if(tab.favIconUrl && tab.favIconUrl.length > 0) {
		return tab.favIconUrl;
	} else if(/^chrome:\/\/extensions\/.*/.exec(tab.url)) {
		return "http://img168.imageshack.us/img168/3407/chromeextensionsicon.png";
	} else {
		return "http://img29.imageshack.us/img29/5347/documentblankicon.png"
	}
}

$(document).ready(function() {

	var intro = "";
	if (document.location.href.match("update=true")) {
		intro = "You received an important update to this extension.";
	} else {
		intro = "Thank you for installing this extension.";
	}
	$("#message").text(intro);


	chrome.tabs.getAllInWindow(null, function(tabs) {
		var bannedTabs = false;
		for (var b=0; b<tabs.length; b++) {
			var tab = tabs[b];
			if (extensionBannedTab(tab)) {
				$("#bannedTabs").append("<img align='absmiddle' src='" + tabImage(tab) + "'/>&nbsp;" + tab.title + "<br>");
				bannedTabs = true;
			}
		}
		if (bannedTabs) {
			$("#bannedTabsWrapper").show();
			$("#bannedTabsWrapper a").click( function() {
				$("#bannedTabs").slideDown();
			});
		}
	});

	$("#reloadTabs").click(function() {
		chrome.windows.getAll({populate:true}, function (windows) {
			for (var a=0; a<windows.length; a++) {
				var tabs = windows[a].tabs;
				for (var b=0; b<tabs.length; b++) {
					var tab = tabs[b];
					if (!extensionBannedTab(tab)) {
						chrome.tabs.update(tab.id, {url: tab.url, selected: tab.selected}, null);
					}
				}
			}
		});
		getActiveTab(function(tab) {
			chrome.tabs.remove(tab.id);
		});
		chrome.tabs.create({url:"options.html"});

	});
});