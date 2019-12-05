var ownBitmap;
var storedCanvas = document.createElement('canvas');
var ownIconSelected = false;

function save() {
	var prefs = JSON.parse(window.localStorage.merge_windows_prefs);
    
    prefs.yellowIcon = document.getElementById("yellowIcon").checked;
    prefs.greenIcon = document.getElementById("greenIcon").checked;
    prefs.blueIcon = document.getElementById("blueIcon").checked;
    prefs.redIcon = document.getElementById("redIcon").checked;
    prefs.defaultIcon = document.getElementById("defaultIcon").checked;
    prefs.ownIcon = document.getElementById("ownIcon").checked;
    if(prefs.ownIcon && ownIconSelected)prefs.storedCanvas = storedCanvas.toDataURL("image/png");
    
    window.localStorage.merge_windows_prefs = JSON.stringify(prefs);
    
    //update icon
    if (prefs.yellowIcon)
        chrome.browserAction.setIcon({path:"yellow.png"})
    else if (prefs.greenIcon)
        chrome.browserAction.setIcon({path:"green.png"})   
    else if (prefs.blueIcon)
        chrome.browserAction.setIcon({path:"blue.png"})   
    else if (prefs.redIcon)
        chrome.browserAction.setIcon({path:"red.png"})  
    else if (prefs.ownIcon && prefs.storedCanvas!=null)chrome.browserAction.setIcon({imageData:ownBitmap})      
    else
		chrome.browserAction.setIcon({path:"icon24.png"});
    
	
	
	//chrome.extension.getBackgroundPage().init();
}


window.onload = function() {

    var prefs;
    if (!window.localStorage.merge_windows_prefs) {
		window.localStorage.merge_windows_prefs = JSON.stringify({ "defaultIcon": true});
	}
    prefs = JSON.parse(window.localStorage.merge_windows_prefs);

    document.getElementById("yellowIcon").checked = prefs.yellowIcon;
    document.getElementById("greenIcon").checked = prefs.greenIcon;
    document.getElementById("blueIcon").checked = prefs.blueIcon;
    document.getElementById("redIcon").checked = prefs.redIcon;
    document.getElementById("defaultIcon").checked = prefs.defaultIcon;
    document.getElementById("ownIcon").checked = prefs.ownIcon;
    
    //default icon by default ;-)
    if (!prefs.yellowIcon &&!prefs.greenIcon &&!prefs.blueIcon &&!prefs.redIcon &&!prefs.defaultIcon &&!prefs.ownIcon )document.getElementById("defaultIcon").checked = true;
    
    document.getElementById("yellowIcon").onclick = function() { save(); };
    document.getElementById("greenIcon").onclick = function() { save(); };
    document.getElementById("blueIcon").onclick = function() { save(); };
    document.getElementById("redIcon").onclick = function() { save(); };
    document.getElementById("defaultIcon").onclick = function() { save(); };
    document.getElementById("ownIcon").onclick = function() { save(); };
    
    document.getElementById("errorMessage").innerHTML='';
    
    //load custom icon, if set
    if (prefs.storedCanvas!=null){
        var img = new Image();
        img.onload = function(){
            var canvas = document.createElement('canvas');
                                canvas.width = img.width;
                                canvas.height = img.height;

                                var context = canvas.getContext('2d');
                                   context.drawImage(img, 0, 0);             
                                // ...draw to the canvas...
                                var imageData = context.getImageData(0, 0, 19, 19);
            if(img.width>19 || img.width>19)document.getElementById("errorMessage").innerHTML='Image is '+img.width+'x'+img.height+' pixels. Only the top/left 19x19 pixels are used!';
                                    
            if (prefs.ownIcon)chrome.browserAction.setIcon({imageData:imageData});
                                    ownBitmap = imageData;
                        storedCanvas = canvas;
        };
        img.setAttribute("src", prefs.storedCanvas);
        document.getElementById('destination').appendChild(img);
        
    }

}

document.getElementById('upload-file').addEventListener('change', function() {
	var file;
	var destination = document.getElementById('destination');
	destination.innerHTML = '';

		file = this.files[0];
		if(file.type.indexOf('image') != -1) { // Very primitive "validation"

			var reader = new FileReader();

			reader.onload = function(e) {
				var img = new Image();
                
                    img.onload = function(){
                
                                var canvas = document.createElement('canvas');
                                canvas.width = img.width;
                                canvas.height = img.height;

                                var context = canvas.getContext('2d');
                                   context.drawImage(img, 0, 0);             
                                // ...draw to the canvas...
                                var imageData = context.getImageData(0, 0, 19, 19);
                               //show error if large image
                        document.getElementById("errorMessage").innerHTML='';
                            if(img.width>19 || img.width>19)document.getElementById("errorMessage").innerHTML='Image is '+img.width+'x'+img.height+' pixels. Only the top/left 19x19 pixels are used!';
                        
                        ownBitmap = imageData;
                        storedCanvas = canvas;
                        save();
                            
                    };
                
                img.src = e.target.result; // File contents here

                destination.appendChild(img);
			
			 };
                reader.readAsDataURL(file);
           document.getElementById("ownIcon").checked=true;
            ownIconSelected=true;
		} else {
            //not an image?
            destination.innerHTML = 'Wrong File...';
            document.getElementById("errorMessage").innerHTML='';
        }
	
});
