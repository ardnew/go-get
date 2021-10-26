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

#### Check out a new module with import path `github.com/ardnew/clin`:

```sh
$ go-get github.com/ardnew/clin
Cloning into '/usr/local/go/src/github.com/ardnew/clin'...
remote: Enumerating objects: 29, done.
remote: Counting objects: 100% (29/29), done.
remote: Compressing objects: 100% (20/20), done.
remote: Total 29 (delta 12), reused 25 (delta 8), pack-reused 0
Receiving objects: 100% (29/29), 12.19 KiB | 2.03 MiB/s, done.
Resolving deltas: 100% (12/12), done.
$
```

#### Update an existing package with import path `github.com/ardnew/svngrab`:

```
$ go-get github.com/ardnew/svngrab
remote: Enumerating objects: 5, done.
remote: Counting objects: 100% (5/5), done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 3 (delta 2), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (3/3), 795 bytes | 265.00 KiB/s, done.
From github.com:ardnew/svngrab
   21ceb59..7eb310a  main       -> origin/main
Created autostash: dbe0e0e
Changes from 21ceb59347ddb24149daeb640a530e488187bb38 to 7eb310a2b923b7de81fa857ea8014a4dbe8b4745:
 README.md | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)
First, rewinding head to replay your work on top of it...
Fast-forwarded main to 7eb310a2b923b7de81fa857ea8014a4dbe8b4745.
Applied autostash.
$
```

#### Update a command from subdirectory `cmd/goshfun` of import path `github.com/ardnew/gosh`:
```
$ go-get github.com/ardnew/gosh cmd/goshfun
From ssh://github.com/ardnew/gosh
 = [up to date]      master      -> origin/master
 = [up to date]      profile-dir -> origin/profile-dir
Created autostash: 5e6447f
Current branch master is up to date.
Applied autostash.
github.com/ardnew/gosh/cmd/goshfun/util
github.com/ardnew/version
github.com/juju/errors
github.com/ardnew/gosh/cmd/goshfun/parse
github.com/ardnew/gosh/cmd/goshfun/pkg
github.com/ardnew/gosh/cmd/goshfun/print
github.com/ardnew/gosh/cmd/goshfun/run
github.com/ardnew/gosh/cmd/goshfun
$
```
