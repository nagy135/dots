function setKey(value) {
	var parseKeyObj = keyutil.parseKey(value);
	if (parseKeyObj['array']) {
		if (!parseKeyObj['array'][0]['ctrl'] && !parseKeyObj['array'][0]['alt'] && !parseKeyObj['array'][0]['shift'] && parseKeyObj['array'][0]['code'] == 8) {
			document.getElementById("shortcut").value = "";
			document.getElementById("shortcutNotes").innerHTML = '&nbsp;';
			return;
		} else {
			document.getElementById("shortcut").value = value;
		}
	}
	var shortcutNotes = document.getElementById("shortcutNotes");
	shortcutNotes.style.color = 'black';
	shortcutNotes.style.fontWeight = 'normal';
	if (parseKeyObj['error']) {
		shortcutNotes.innerHTML = parseKeyObj['error'];
		shortcutNotes.style.color = 'red';
	} else if (parseKeyObj['note']) {
		shortcutNotes.innerHTML = 'Note: ' + parseKeyObj['note'];
		shortcutNotes.style.color = 'blue';
	} else {
		shortcutNotes.innerHTML = '&nbsp;';
	}
	localStorage.keyString = value;
}

function key() {
	var shortcut = document.getElementById("shortcut");
	if (shortcut.value == "Meta") {
		return shortcut.value;
	}
}

$(document).ready(function() {
	
	if (!localStorage.enabled || localStorage.enabled == "true") {
		$("#enabled").get(0).checked = true;
	} else {
		$("#enabled").get(0).checked = false;
	}
	
	$("#enabled").change(function() {
		if (this.checked) {
			chrome.permissions.request({origins:["<all_urls>"], permissions:["tabs"]}, granted => {
				if (granted) {
					localStorage.enabled = true;
				} else {
					$("#enabled").get(0).checked = false;
				}
			});
		} else {
			localStorage.enabled = this.checked;
		}
	});
	
	var shortcut = document.getElementById("shortcut");
	var keyString = localStorage.keyString;
	if (keyString) {
		shortcut.value = keyString;
	}
	new keyutil.InputBoxListener(shortcut,
	   util.bind(key, this),
	   util.bind(setKey, this));
	$("#displayTabCylcer").prop("checked", pref(localStorage["displayTabCylcer"], true));
	var maxRecentTabs = pref(localStorage["maxRecentTabs"], 10);
	$("#maxRecentTabs").val(maxRecentTabs);
	$("#save").click(function() {
		if (shortcut.value) {
			localStorage["keys"] = JSON.stringify(keyutil.parseKey(shortcut.value));
		}			
		localStorage["displayTabCylcer"] = $("#displayTabCylcer").prop("checked") ? "true" : "false";
		localStorage["maxRecentTabs"] = $("#maxRecentTabs").val();
		$("#status").show().fadeOut(2000);
		$("#note").show();
	});
	//$("#shortcut").focus();

	$("#test1").click(function() {
		google.payments.inapp.getSkuDetails({
			'parameters': {'env': 'prod'},
		});
	});
		
	$("#test2").click(function() {
		var sku = "extra_features";
		google.payments.inapp.buy({
			'parameters': {'env': 'prod'},
			'sku': sku
		});
	});
});