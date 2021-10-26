# go-get
#### Clone a Go package/module source code repository from import path

With Go modules replacing GOPATH mode, there isn't really a convenient way to fetch Go source code using the `go` toolchain anymore. This script wraps the tedious steps necessary to create the local import path and clone the repository into that path. 

If the local import path already exists, the source code is updated using `git pull` instead.

```text
usage:
  go-get <package> [cmdpath]

description:
  go-get downloads the given Go package source code to GOPATH. The package path
  may be specified as either a fully-qualified URL or local Go import path.

  If the given package path is not a fully-qualified URL, it attempts to
  determine the URL based on a table of known hosts, mapping the host name in
  the first component of the given Go import path to its corresponding URL.

  If the local Go import path already exists, the source code is updated with
  git pull. Otherwise, the repository is cloned into the local import path.

  The user may also specify a relative file path cmdpath (from the root of the
  package import path), referring to an executable to build and install after
  the repository has been downloaded.

  Currently, the only package resources supported are Git repositories.
```

## Examples
