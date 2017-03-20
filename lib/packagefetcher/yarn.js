var path = require('path');
var nijs = require('nijs');

function fetchMetaDataFromYarn(baseDir, dependencyName, versionSpec, yarnInfo, callback) {
  var yarnKey = dependencyName + "@" + versionSpec;
  var yarnDepInfo = yarnInfo[yarnKey];

  var resolvedParts = yarnDepInfo.resolved.split("#");
  var url = resolvedParts[0];
  var shasum = resolvedParts[1];

  var packageObj = {
    name: dependencyName,
    version: yarnDepInfo["version"],
    dependencies: yarnDepInfo["dependencies"]
  };

  var yarnPkg = {
    baseDir: path.join(baseDir, dependencyName),
    packageObj: packageObj,
    identifier: dependencyName + "-" + packageObj.version,
    src: new nijs.NixFunInvocation({
        funExpr: new nijs.NixExpression("fetchurl"),
        paramExpr: {
            url: url,
            sha1: shasum
        }
    }),
  };

  callback(null, yarnPkg);
}

exports.fetchMetaDataFromYarn = fetchMetaDataFromYarn;
