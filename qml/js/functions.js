// gets string from c++ and parses it to array
function getIconPacks() {
    var packs = iconpack.listIconPacks();
    packs = packs.split("\n");
    packs.pop();
    return packs;
}

function getCapabilities() {
    var capabilities = ip.capabilities(iconpack);
    var ret = {
        icons: false,
        fonts: false
    };

    console.log(capabilities);
    if(capabilities[0] == "true") { // string because of QStringList
        ret.icons = true;
    }
    if(capabilities[1] == "true") {
        ret.fonts = true;
    }
    return ret;
}

function getWeights() {
    var weights = ip.weights(iconpack);
    var ret = [];
    for(var i in weights) {
        var w = String(weights[i]).replace(".ttf","");
        ret.push(w);
    }
    return ret;
}
