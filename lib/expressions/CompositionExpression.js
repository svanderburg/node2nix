var path = require('path');
var nijs = require('nijs');
var inherit = require('nijs/lib/ast/util/inherit.js').inherit;

/*
 * Prefixes a relative path with ./ if needed so that it can be converted to a
 * value belonging to Nix's file type
 */
function prefixRelativePath(target) {
    if(path.isAbsolute(target) || target.substring(0, 2) == "./" || target.substring(0, 3) == "../") {
        return target;
    } else {
        return "./" + target;
    }
}

function composePathRelativeToCompositionExpression(compositionNix, exprNix) {
    return prefixRelativePath(path.relative(path.dirname(compositionNix), exprNix));
}

/**
 * Creates a new composition expression instance.
 *
 * @class CompositionExpression
 * @extends NixASTNode
 * @classdesc Represents an expression that composes NPM packages
 *
 * @constructor
 * @param {String} compositionNix Path to which the generated composition expression is written
 * @param {String} nodePackage Name of the Node.js package to use from Nixpkgs
 * @param {String} nodeEnvNix Path to which the NPM package build expression is written
 * @param {String} packagesNix Path to a Nix expression containing packages and sources
 * @param {String} supplementNix Path to which the generated supplement expression is written
 * @param {Boolean} generateSupplement Indicates whether we need a reference to a supplement Nix expression
 * @param {Boolean} useFetchGitPrivate Indicates that the fetchgitPrivate function should be used instead of fetchgit
 */
function CompositionExpression(compositionNix, nodePackage, nodeEnvNix, packagesNix, supplementNix, generateSupplement, useFetchGitPrivate) {
    this.nodePackage = nodePackage;
    this.nodeEnvNixPath = composePathRelativeToCompositionExpression(compositionNix, nodeEnvNix);
    this.packagesNixPath = composePathRelativeToCompositionExpression(compositionNix, packagesNix);
    this.supplementNix = composePathRelativeToCompositionExpression(compositionNix, supplementNix);
    this.generateSupplement = generateSupplement;
    this.useFetchGitPrivate = useFetchGitPrivate;
}

/* CompositionExpression inherits from NixASTNode */
inherit(nijs.NixASTNode, CompositionExpression);

/**
 * @see NixASTNode#toNixAST
 */
CompositionExpression.prototype.toNixAST = function() {
    var globalBuildInputs;
    var fetchgitAttr;

    // Determine which fetchgit function to use
    if(this.useFetchGitPrivate) {
        fetchgitAttr = new nijs.NixAttrReference({
            attrSetExpr: new nijs.NixExpression("pkgs"),
            refExpr: new nijs.NixExpression("fetchgitPrivate")
        });
    } else {
        fetchgitAttr = new nijs.NixInherit("pkgs");
    }

    if(this.generateSupplement) {
        var supplementNixPath = prefixRelativePath(this.supplementNix);

        globalBuildInputs = new nijs.NixFunInvocation({
            funExpr: new nijs.NixExpression("pkgs.lib.attrValues"),
            paramExpr: new nijs.NixFunInvocation({
                funExpr: new nijs.NixImport(new nijs.NixFile({ value: supplementNixPath })),
                paramExpr: {
                  nodeEnv: new nijs.NixInherit(),
                  stdenv: new nijs.NixInherit("pkgs"),
                  lib: new nijs.NixInherit("pkgs"),
                  "nix-gitignore": new nijs.NixInherit("pkgs"),
                  fetchurl: new nijs.NixInherit("pkgs"),
                  fetchgit: fetchgitAttr
                }
            })
        });
    }

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
                refExpr: this.nodePackage
            })
        },
        body: new nijs.NixLet({
            value: {
                globalBuildInputs: globalBuildInputs,

                nodeEnv: new nijs.NixFunInvocation({
                    funExpr: new nijs.NixImport(new nijs.NixFile({ value: this.nodeEnvNixPath })),
                    paramExpr: {
                        stdenv: new nijs.NixInherit("pkgs"),
                        lib: new nijs.NixInherit("pkgs"),
                        python2: new nijs.NixInherit("pkgs"),
                        libtool: new nijs.NixIf({
                            ifExpr: new nijs.NixAttrReference({
                                attrSetExpr: new nijs.NixExpression("pkgs"),
                                refExpr: new nijs.NixAttrReference({
                                    attrSetExpr: new nijs.NixExpression("stdenv"),
                                    refExpr: new nijs.NixExpression("isDarwin")
                                }),
                            }),
                            thenExpr: new nijs.NixAttrReference({
                                attrSetExpr: new nijs.NixExpression("pkgs"),
                                refExpr: new nijs.NixExpression("cctools"),
                                orExpr: new nijs.NixAttrReference({
                                    attrSetExpr: new nijs.NixExpression("pkgs"),
                                    refExpr: new nijs.NixAttrReference({
                                        attrSetExpr: new nijs.NixExpression("darwin"),
                                        refExpr: new nijs.NixExpression("cctools")
                                    }),
                                }),
                            }),
                            elseExpr: null
                        }),
                        runCommand: new nijs.NixInherit("pkgs"),
                        writeTextFile: new nijs.NixInherit("pkgs"),
                        writeShellScript: new nijs.NixInherit("pkgs"),
                        pkgs: new nijs.NixInherit(),
                        nodejs: new nijs.NixInherit()
                    }
                })
            },
            body: new nijs.NixFunInvocation({
                funExpr: new nijs.NixImport(new nijs.NixFile({ value: this.packagesNixPath })),
                paramExpr: {
                    fetchurl: new nijs.NixInherit("pkgs"),
                    "nix-gitignore": new nijs.NixInherit("pkgs"),
                    stdenv: new nijs.NixInherit("pkgs"),
                    lib: new nijs.NixInherit("pkgs"),
                    fetchgit: fetchgitAttr,
                    nodeEnv: new nijs.NixInherit(),
                    globalBuildInputs: globalBuildInputs ? new nijs.NixInherit() : undefined
                }
            })
        })
    });
};

exports.CompositionExpression = CompositionExpression;
