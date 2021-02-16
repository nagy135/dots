(function() {
    var f = this,
        g = function(a, d) {
            var c = a.split("."),
                b = window || f;
            c[0] in b || !b.execScript || b.execScript("var " + c[0]);
            for (var e; c.length && (e = c.shift());) c.length || void 0 === d ? b = b[e] ? b[e] : b[e] = {} : b[e] = d
        };
    var h = function(a) {
        // jason patch: refactored to use Promise
        return new Promise((resolve, reject) => {
            var d = chrome.runtime.connect("nmmhkkegccagdldgiimedpiccmgmieda", {}),
                c = !1;
            d.onMessage.addListener(function(b) {
                c = !0;
                if ("response" in b) {
                    if ("errorType" in b.response) {
                        reject(b.response.errorType);
                    } else {
                        resolve(b.response);
                    }
                } else {
                    var error = "jresponse error";
                    console.error(error, b);
                    reject(error);
                }
                //"response" in b && !("errorType" in b.response) ? a.success && a.success(b) : a.failure && a.failure(b)
            });
            d.onDisconnect.addListener(function() {
                reject("INTERNAL_SERVER_ERROR");
                /*
                !c && a.failure && a.failure({
                    request: {},
                    response: {
                        errorType: "INTERNAL_SERVER_ERROR"
                    }
                })
                */
            });
            d.postMessage(a)
        });
    };
    g("google.payments.inapp.buy", function(a) {
        a.method = "buy";
        return h(a);
    });
    g("google.payments.inapp.consumePurchase", function(a) {
        a.method = "consumePurchase";
        return h(a);
    });
    g("google.payments.inapp.getPurchases", function(a) {
        a.method = "getPurchases";
        return h(a);
    });
    g("google.payments.inapp.getSkuDetails", function(a) {
        a.method = "getSkuDetails";
        return h(a);
    });
})();