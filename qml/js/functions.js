function getIconPacks() {
    var packs = iconpack.listIconPacks();
    packs = packs.split("\n");
    packs.pop();
    return packs;
}
