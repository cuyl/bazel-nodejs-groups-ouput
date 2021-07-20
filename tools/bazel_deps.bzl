# Third-party dependencies fetched by Bazel
# Unlike WORKSPACE, the content of this file is unordered.
# We keep them separate to make the WORKSPACE file more maintainable.

# Install the nodejs "bootstrap" package
# This provides the basic tools for running and packaging nodejs programs in Bazel
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
def fetch_dependencies():
    http_archive(
        name = "build_bazel_rules_nodejs",
        sha256 = "8f5f192ba02319254aaf2cdcca00ec12eaafeb979a80a1e946773c520ae0a2c9",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/3.7.0/rules_nodejs-3.7.0.tar.gz"],
    )

    # rules_nodejs doesn't depend on skylib, but it's a useful dependency anyway.
    http_archive(
        name = "bazel_skylib",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
        ],
        sha256 = "8f5f192ba02319254aaf2cdcca00ec12eaafeb979a80a1e946773c520ae0a2c9",
    )

    _ESBUILD_VERSION = "0.12.15"  # reminder: update SHAs below when changing this value

    http_archive(
        name = "esbuild_darwin",
        urls = [
            "https://registry.npmjs.org/esbuild-darwin-64/-/esbuild-darwin-64-%s.tgz" % _ESBUILD_VERSION,
        ],
        strip_prefix = "package",
        build_file_content = """exports_files(["bin/esbuild"])""",
        sha256 = "ad9332d0180c0a59ae6bbf54e457ae8c270b212a3c098eb1594adf110d55b2bd",
    )

    http_archive(
        name = "esbuild_linux",
        urls = [
            "https://registry.npmjs.org/esbuild-linux-64/-/esbuild-linux-64-%s.tgz" % _ESBUILD_VERSION,
        ],
        strip_prefix = "package",
        build_file_content = """exports_files(["bin/esbuild"])""",
        sha256 = "c2038ea88eb4f5009d557d319ff1f9b0627e5ecca06684c6716ec8c62f7b89db",
    )
