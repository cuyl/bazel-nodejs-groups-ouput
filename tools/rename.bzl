load("@build_bazel_rules_nodejs//:providers.bzl", "JSEcmaScriptModuleInfo", "JSModuleInfo", "JSNamedModuleInfo", "node_modules_aspect")

def _rename_impl(ctx):
    sources = []
    result = []
    for dep in ctx.attr.deps:
        if JSEcmaScriptModuleInfo in dep:
            sources.append(dep[JSEcmaScriptModuleInfo].direct_sources)
        if JSNamedModuleInfo in dep:
            sources.append(dep[JSNamedModuleInfo].direct_sources)
        if JSModuleInfo in dep:
            sources.append(dep[JSModuleInfo].direct_sources)
    for f in depset(transitive = sources).to_list():
        if f.short_path.find("esbuild.js") == -1 and f.short_path.find("rollup.js") == -1:
            continue
        file_path = f.short_path.replace("esbuild.js", "index.js").replace("rollup.js", "index.js").replace(ctx.label.package + "/", "")
        rerooted_file = ctx.actions.declare_file(file_path)
        result.append(rerooted_file)
        ctx.actions.expand_template(
            output = rerooted_file,
            template = f,
            substitutions = {
                "esbuild.js.map": "index.js.map",
                "rollup.js.map": "index.js.map",
            },
        )
    return [
        DefaultInfo(
            files = depset(result),
        )
    ]

rename = rule(
    implementation = _rename_impl,
    attrs = {
        "deps": attr.label_list(
            aspects = [node_modules_aspect],
        )
    },
    outputs = {},
)
