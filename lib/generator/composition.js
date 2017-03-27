var path = require('path');
var nijs = require('nijs');

/*
 * Prefixes a relative path with ./ if needed so that it can be converted to a
 * value belonging to Nix's file type
 */
function prefixRelativePath(target) {
    if(path.isAbsolute(target) || target.substring(0, 2) == "./" || target.substring(0, 3) == "../")
        return target;
    else
        return "./" + target;
}

/**
 * Generates a composition expression that can be used by the Nix package manager
 * to compose and build NPM packages.
 *
 * @param {String} nodeEnvExpr Path to the node environment expression providing the build functionality
 * @param {String} nodePackage Name of the Node.js package to use from Nixpkgs
 * @param {String} packagesExpr Path to the package expression that defines how packages are built from source and their dependencies
 * @param {String} supplementNix Path to which the generated supplement expression is written
 * @param {Boolean} generateSupplement Indicates whether to include supplemental packages
 * @return {NixFunction} Nix function that composes the NPM packages
 */
 
function generateCompositionExpr(nodeEnvNix, nodePackage, packagesNix, supplementNix, generateSupplement) {
    var globalBuildInputs;
    var nodeEnvNixPath = prefixRelativePath(nodeEnvNix);
    var packagesNixPath = prefixRelativePath(packagesNix);
    
    if(generateSupplement) {
        var supplementNixPath = prefixRelativePath(supplementNix);
        
        globalBuildInputs = new nijs.NixFunInvocation({
            funExpr: new nijs.NixExpression("pkgs.lib.attrValues"),
            paramExpr: new nijs.NixFunInvocation({
                funExpr: new nijs.NixImport(new nijs.NixFile({ value: supplementNixPath })),
                paramExpr: {
                  nodeEnv: new nijs.NixInherit(),
                  fetchurl: new nijs.NixInherit("pkgs"),
                  fetchgit: new nijs.NixInherit("pkgs")
                }
            })
        });
    }
    
    /* Generate composition Nix expression */
    return new nijs.NixFunction({
        argSpec: {
            pkgs: new nijs.NixFunInvocation({
                funExpr: new nijs.NixImport(new nijs.NixExpression("<nixpkgs>")),
                paramExpr: {
                    system: new nijs.NixInherit()
                }
            }),
            system: new nijs.NixAttrReference({
                attrSetExpr: new nijs.NixExpression("builtins"),
                refExpr: new nijs.NixExpression("currentSystem")
            }),
            nodejs: new nijs.NixAttrReference({
                attrSetExpr: new nijs.NixExpression("pkgs"),
                refExpr: nodePackage
            })
        },
        body: new nijs.NixLet({
            value: {
                globalBuildInputs: globalBuildInputs,
                
                nodeEnv: new nijs.NixFunInvocation({
                    funExpr: new nijs.NixImport(new nijs.NixFile({ value: nodeEnvNixPath })),
                    paramExpr: {
                        stdenv: new nijs.NixInherit("pkgs"),
                        python2: new nijs.NixInherit("pkgs"),
                        utillinux: new nijs.NixInherit("pkgs"),
                        runCommand: new nijs.NixInherit("pkgs"),
                        writeTextFile: new nijs.NixInherit("pkgs"),
                        nodejs: new nijs.NixInherit()
                    }
                })
            },
            body: new nijs.NixFunInvocation({
                funExpr: new nijs.NixImport(new nijs.NixFile({ value: packagesNixPath })),
                paramExpr: {
                    fetchurl: new nijs.NixInherit("pkgs"),
                    fetchgit: new nijs.NixInherit("pkgs"),
                    nodeEnv: new nijs.NixInherit(),
                    globalBuildInputs: globalBuildInputs ? new nijs.NixInherit() : undefined
                }
            })
        })
    });
}

exports.generateCompositionExpr = generateCompositionExpr;
