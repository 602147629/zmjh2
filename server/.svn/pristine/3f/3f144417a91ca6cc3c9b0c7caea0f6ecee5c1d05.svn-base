//文件加载器
var loader = require("./loader.js");

var files = {};

module.exports = {
    Load : function(path){
        if(files[path]){
            return files[path];
        }
        var file = loader.load(path);
        files[path] = file;

        return file;
    }
}