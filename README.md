### Understanding the problem

- 1. `diff -r Constant_Success/ Intermittent_Success/`
- 2. `cd Constant_Success/major/; ./b.sh`
- 3. `cd Intermittent_Success/major/; ./b.sh`

Intermittent_Success fails non-deterministically with
```
(ins)[user@pc major]$ ./b.sh 
STEP 1
/home/user/dev/git/zi/ZigCacheIssue_MinExample/Intermittent_Success/major/major.zig:1:27: error: no package named 'minor' available within package 'root'
pub const minor = @import("minor");
                          ^~~~~~~
referenced by:
    Foo: /home/user/dev/git/zi/ZigCacheIssue_MinExample/Intermittent_Success/major/major.zig:2:17
    Foo: /home/user/dev/git/zi/ZigCacheIssue_MinExample/Intermittent_Success/major/src/alpha.zig:7:18
    remaining reference traces hidden; use '-freference-trace' to see all reference traces

error: test...
error: The following command exited with error code 1:
/home/user/dev/git/zi/zig/master/build/stage3/bin/zig test /home/user/dev/git/zi/ZigCacheIssue_MinExample/Intermittent_Success/major/main_test.zig --cache-dir /home/user/dev/git/zi/ZigCacheIssue_MinExample/Intermittent_Success/major/zig-cache --global-cache-dir /home/user/.cache/zig --name test --pkg-begin major /home/user/dev/git/zi/ZigCacheIssue_MinExample/Intermittent_Success/major/major.zig --pkg-begin minor /home/user/dev/git/zi/ZigCacheIssue_MinExample/Intermittent_Success/minor/minor.zig --pkg-end --pkg-en d --enable-cache 
error: the following build command failed with exit code 1:
/home/user/dev/git/zi/ZigCacheIssue_MinExample/Intermittent_Success/major/zig-cache/o/552a17303a3cfe25f45a59a25ba92fda/build /home/user/dev/git/zi/zig/master/build/stage3/bin/zig /home/user/dev/git/zi/ZigCacheIssue_MinExample/Intermittent_Success/major /home/user/dev/git/zi/ZigCacheIssue_MinExample/Intermittent_Success/major/zig-cache /home/user/.cache/zig test
```

## Problem description:
```
Constant_Success
Constant_Success/major/b.sh
Constant_Success/major/build.zig
Constant_Success/major/main_test.zig
Constant_Success/major/major.zig
Constant_Success/major/src/alpha.zig
Constant_Success/minor/build.zig
Constant_Success/minor/main_test.zig
Constant_Success/minor/minor.zig
Constant_Success/minor/src/foo.zig
```
and for Intermittent_Sucess same structure but `+ Intermittent_Success/major/src/beta.zig`
and this diff:
```diff
diff -r Constant_Success/major/main_test.zig Intermittent_Success/major/main_test.zig
2a3
>     _ = @import("src/beta.zig");
diff -r Constant_Success/major/major.zig Intermittent_Success/major/major.zig
2a3
> pub const beta = @import("src/beta.zig").beta;
Only in Intermittent_Success/major/src: beta.zig.
```
beta.zig does `const major = @import("../major.zig"); const Foo = major.Foo;`
and uses both `const major` and `const Foo` forwarded via
`pub const Foo = @import("src/foo.zig").Foo;` via minor.zig.

Lets abbreviate major as ma minor as mi with the filename to simplify drawing the graph
how things are imported and remove file ending .zig to descibre its namespace only
(but add the path info).
It would be nice, if we would have a graph output of the problem, because writing this
takes a long time.
Only describe usage for possible resolving paths ignoring std.

Constant_Sucess:
```
ma/build
pkg ma (ma/ma), mi(mi/mi)
ma/main_test ─► ma/src/alpha ─► ma/ma ─► Foo = mi/mi.Foo ─► mi/mi.Foo = mi/src/foo.Foo ─► mi/src/foo: pub fn Foo
```

Intermittent_Success:
```
ma/build                             ┌────┐
pkg ma (ma/ma), mi(mi/mi)            │    ▼
ma/main_test ┬► ma/src/alpha ─► ma/ma│┬► Foo = mi/mi.Foo ─► mi/mi.Foo = mi/src/foo.Foo ─► mi/src/foo: pub fn Foo
             │                       │└► beta = src/beta.beta
             │                       └─────┐             │
             │                             │             │
             │                             │             ▼
             └► ma/src/beta ─► Foo = ma/ma.Foo, pub fn beta
                                ▲                        │using Foo internally
                                └────────────────────────┘
```

Further observation:
Adding `pub const alpha = @import("src/alpha.zig").alpha` to
`Intermittent_Success/major/major.zig` does not create an error message such that
`ma/src/alpha.alpha` does not exist.
