var path = require('path');
var nijs = require('nijs');

/**
 * @member npm2nix.generator
 *
 * Generates a composition expression allowing someone to build packages through
 * nix-build or deploy package through nix-env.
 *
 * @param {String} outputNix Path to which the generated registry expression is written
 * @param {String} nodeEnvNix Path to which the NPM package build expression is written
 * @param {Object} body Nix expression generated from a package or collection
 */
function generateCompositionExpr(outputNix, nodeEnvNix, body) {
    return new nijs.NixFunction({
        argSpec: {
            system: new nijs.NixAttrReference({
                attrSetExpr: new nijs.NixExpression("builtins"),
                refExpr: new nijs.NixExpression("currentSystem")
            }),
            pkgs: new nijs.NixFunInvocation({
                funExpr: new nijs.NixImport(new nijs.NixExpression("<nixpkgs>")),
                paramExpr: {
                    system: new nijs.NixInherit()
                }
            }),
            overrides: {}
        },
        body: new nijs.NixLet({
            value: {
                nodeEnv: new nijs.NixFunInvocation({
                    funExpr: new nijs.NixImport(new nijs.NixFile({ value: "./"+path.basename(nodeEnvNix) })),
                    paramExpr: {
                        stdenv: new nijs.NixInherit("pkgs"),
                        fetchurl: new nijs.NixInherit("pkgs"),
                        nodejs: new nijs.NixInherit("pkgs"),
                        python: new nijs.NixInherit("pkgs"),
                        utillinux: new nijs.NixInherit("pkgs"),
                        runCommand: new nijs.NixInherit("pkgs")
                    }
                }),
                registry: new nijs.NixFunInvocation({
                    funExpr: new nijs.NixImport(new nijs.NixFile({ value: "./"+path.basename(outputNix) })),
                    paramExpr: {
                        buildNodePackage: new nijs.NixInherit("nodeEnv"),
                        fetchurl: new nijs.NixInherit("pkgs"),
                        fetchgit: new nijs.NixInherit("pkgs"),
                        self: new nijs.NixExpression("registry // overrides")
                    }
                })
            },
            body: body
        })
    });
}

exports.generateCompositionExpr = generateCompositionExpr;
