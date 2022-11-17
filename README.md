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
