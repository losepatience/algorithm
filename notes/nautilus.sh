#!/bin/sh

# --------- Setup your system 

------------------------------------
* --- Install grub on PHD(Portable Hard Disk)
$ fdisk /dev/sdb ... 
$ mkfs -t ext3 /dev/sdb1
$ e2label /dev/sdb1 boot
$ mount /dev/sdb1  /mnt
$ grub-install --root-directory=/mnt --no-floppy /dev/sdb
(note:
--root-directory=/mnt 指明grub的安装目录，默认是 /boot
/dev/sdb: 安装 stage1 到 sdb 的 mbr)
------------------------------------
* --- Install CentOS from HDD
下载2个 iso 安装文件到 sda2
解压第1个 iso 中 isolinux 和 images 目录到sda2
重启进入grub
$ root (hd0,1)
$ kernel /isolinux/vmlinuz
$ initrd /isolinux/initrd.img
$ boot
(note:
如果我们不能确定 iso 在哪个分区，可以用下面的命令
find --set-root --ignore-floppies --ignore-cd /CentOS-6.2-i386-bin-DVD.iso)
------------------------------------
* --- Setup CentOS
$ sudo yum install unrar git git-gui gitk gnupg gnupg2 flex bison gperf	\
	gcc gcc-c++ zip curl zlib-devel wget mtd-utils mtd-utils-ubi	\
	fakeroot fakeroot-libs gawk subversion unixODBC util-linux	\
	SDL-devel esound-devel esound-libs wxGTK-devel ncurses-devel	\
	readline-devel libzip-devel xorg-x11-proto-devel -y
$ sudo yum install minicom nfs-utils rpcbind tftp tftp-server samba -y
$ sudo yum install gstreamer-plugins-ugly gstreamer-plugins-bad -y
(note: mp3 decode)
$ sudo yum install vim-X11 telnet minicom -y
$ sudo yum install fuse fuse-ntfs-3g -y
------------------------------------
* --- create alias 4 IPs 
$ cat 192.168.110.73 gitserver >> /etc/hosts
(note: windows 中, 对应的文件是 Windows/System32/drivers/etc/hosts)
使用 ssh 时，也可以指定主机别名:
host gitserver
	user git
	hostname 192.168.110.155
	port 22
	identityfile ~/.ssh/admin
(note: admin 指向 ~/.ssh/admin.pub 公匙)
------------------------------------
* --- Release memory
$ sudo sync
$ sudo echo 3 > /proc/sys/vm/drop_caches
(note:	0 - 不释放
	1 - 释放页缓存
	2 - 释放dentries和inodes
	3 - 释放所有缓存)
------------------------------------
* --- Common utility
nevernote(the free-version of evernote)

qstardict
在用户目录的 .config 文件夹下，有个qstardict 目录，
它包含 qstardict 的配置信息

IP_Messenger(http://ipmsg.org)
设置 --> 首选项 --> 字符编码 --> 选为GBK
------------------------------------
* --- 翻墙
. 到 http://www.cjb.net/ 注册账户
  $ ssh -D 127.0.0.1:7070 furioustauren@216.194.70.6
. 给 firefox 安装 AutoProxy 插件并重启之，在弹出的对话框中
  选中 gfwlist 并把 "默认代理" 设置为 ssh-D(P)
. 在 firefox 地址栏输入 about:config 把 network.proxy.socks_remote_dns
  设置为 true

# --------- vim 

------------------------------------
* --- Configure
U 撤销行上的所有修改
删除三个字符 "3x", 计数总是放在要被处理多次的命令前面

set tags=tags; 
(note: 自动转到父目录中查找 tags)

set autochdir  
(note: 自动转换当前文件所在目录为工作目录)

if has("gui_running")
    if has("unix")
        set guifont=Monospace\ 13
        set guifontwide=KaiTi\ 14
    endif
endif
(note: vim 的字体是不可设置的)fi fi

z-o --- z-c 
^+a: 数字加1
insert 模式: ^+w 删除词

下面命令可以读取当前目录下的内容到第 10 行: :10read !ls

:write !wc 被写入的内容会通过标准输入送入指定的命令中.

global 命令: 找到符合匹配模式的行然后将命令作用其上
:g/^/m 0
:g/^/s/^/\=line("."). " "/ ;\= 字符串转换成命令 .连字符

:s/abc\zs[a-z]\ze//
\zs 替换开始处
\ze 替换结束处
line(".")  当前光标所在行的行号
line("'<") 所选区域第一行的行号

* --- vimdiff
[c 上一个 diff 点
]c 下一个 diff 点
d-p --- d-o diff-put 和 diff-obtain
:diffupdate 更新差异

"xy --- "xp
------------------------------------
* --- cscope
$ find `pwd` -name "*.h" -o -name "*.c" > tags.files
$ ctags -L tags.files
$ cscope -Rbkq -i tags.files
.---------------------------.
| R |  recuerse             |
.---+-----------------------.
| b |  not enter cscope     |
.---+-----------------------.
| q |  speed up seaching    |
.---+-----------------------.
| q |  exclude /usr/include |
^---+-----------------------^

:cs add xxx 
:cs show 

:cs f g xx (definition)
:cs f c xx (functions calling xx)
:cs f d xx (functions called by xx)
:cs f s xx (symbol)
:cs f t xx (text string)
:cs f f xx (file)
:cs f i xx (file including xx)
:cs f e xx (egrep)

nnoremap <C-i>s :cs f s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-i>g :cs f g <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-i>c :cs f c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-i>t :cs f t <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-i>e :cs f e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-i>f :cs f f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-i>i :cs f i <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-i>d :cs f d <C-R>=expand("<cword>")<CR><CR>
(note: "<cword>" 代表光标下的单词)
------------------------------------
* --- Regular Expression
+ 匹配 + 前的字符 1-n 次 
* 0-n 次 
? 0-1 次
{i} i 次 
{i, j} i-j 次

. 任何字符
^ 行首  $ 行尾 \< 词首 \> 词尾
[c1-c2] c1-c2 中的任何字符
[^c1-c2] c1-c2 外的任何字符
\(\) 标记 \(\) 间的内容，之后可用 \1-\9 来引用它 

a\|b: 多选一

examples:
:g/^[ \t]*$/d 
:%s/[ \t]*$// 
d^ d$ dnw dnl
gU <-> gu 大小写转化

# --------- Common command

------------------------------------
* --- Common usage
set -e 
(note: shell 中发生错误时, 中断执行而退出)

$ set -o vi
(note: 设置 bash 使用跟 vi 相同的快捷键)

*history
$ cd - 
$ ls /home/git
$ cd !$ 
$ !cd 
(note: run the last cd cmd in history)
$ cd /home/git/hello.git
$ !!:s/hello.git/hoho
$ !-2

$ mail -s "subject" user@ip < file 

$ yes | rm -i 

$ time dd if=/dev/hda of=disk.mbr bs=512 count=1
real    0m 30.10s
user    0m 0.01s
sys     0m 4.73s
(note: user+sys 占用的 cpu 时间, real 总时间(cpu + dma + .))

$ date -s 1982-08-12
$ date -s 18:30:00 
$ clock -w

$ find . -name *.C -type f -o -name *.H -ok rm {} \;
(note: -ok 会发起一个询问)
$ find . -name *.c -exec ls {} \;
$ find . -name *.c -print
$ find . -regex '.*b.*3'
(note: -regex 使用正则表达式)
$ find . -inum 211028 -exec mv {} newname.dir \;

$ echo -en "\xaa\x10" > abc
(note: write non ascii chars using echo, -n: not print '\n')

$ cp /root/{a,b} /root/dir/
$ cp fs2410_kernel_2614.[I,W]?? /tmp
(note: cp support RE)

EABI: Embedded application binary interface
(note: EABI r7 用来指定 swi 号)
EABI: 
	mov r7, #num
	swi 0x0
OABI
	swi (#num | 0x900000)

# --------- git

------------------------------------
* --- basic
                                                .--------------.
.---------------.                           .-> |blob |  size  |
| commit | size |                           |   |-----^--------|
|--------+------|      .-----------------.  |   | the 1st file |
|  tree  | 92ec2| ---> |  tree  |  size  |  |   ^--------------^
|--------+------|      |----.---^-.------|  |  
| author | John |      |blob|5b1d3|lib.c | -* 
|--------+------|      |----+-----+------|      .--------------.
|commiter| John |      |blob|911e7|readme| ---> |blob |  size  |
|--------*------|      ^----^-----^------^      |-----^--------|
|comments of pro|                               | the 2rd file |
^---------------^                               ^--------------^
	当你执行一次 commit，git 会把当前文件的内容做成快
照，并保存一个指向此快照的引用。对于没有发生变化的文
件，git 会保存一个其前版本的链接。
	git 不以文件名的方式储存对象，而是把对象储存到数
据库中，我们可以通过队形内容的 hash 值去寻址对象。

.-----------.         .------------.         .----------. 
|working dir| ------> |staging area| ------> |repository|
^-----------^ git add ^------------^ commit  ^----------^

	Git directory 储存元数据和对象数据库，它是执行依次
git clone 所得到的所有东西。
	工作目录是工程的一个检出版本，所有的文件都是从压缩
数据库中抽取的，放于磁盘，供你修改和使用。
	暂存区是一个文件，它保存下次将要提交的信息，通常它
就是 index。
                       
*初始化版本库并添加跟踪文件: 
	使用 $ git init 来生成版本库的框架，使用 $ git add/rm 添
删跟踪的文件。取消跟踪但不删除文件 $ git rm a --cached。
要删除暂存区的某文件 $ git rm a -f。

*.gitignore 原则：要忽略 $ ./configure, $ make 产生的文件,
编译器产生的临时文件，diff 文件等。
.gitignore
	*.[ao]	# no .a files
	!lib.a	# but do track lib.a
	/TODO	# only ignore the root TODO file, not subdir/TODO
	build/	# ignore all files in the build/ directory

*文件的快照放到暂存区: $ git add
	$ git commit 生成一个 commit 对象，其 tree 元指向
$ git add 时产生的快照. 所以提交前通常先运行 $ git add
来生成文件快照，commit 时使用 -a 选项可以跳过这步
*重命名工作区或者暂存区的文件: $ git mv a b

*查看文件状态: $ git status 
*查看提交历史: $ git log 
	要显示提交历史中文件增减和修改信息使用 --stat 选项；
要显示文件内容的变动信息使用 -p 选项；指明查看条目:
-(n) --since,--after --until,--before --author --committer

*查看不同: 
$ git diff *查看暂存区和工作区的差异
$ git diff --cached *查看暂存区和上次提交快照的差异: 
$ git diff commit1 commit2
$ git diff branch1 branch2
$ git format-patch master --stdout > ~/tmp.patch 
(note: 把当期分支与 maste 分支的差别放入 tmp.patch 文件)
$ git apply ~/tmp.patch 打补丁
$ git am ~/tmp.patch 相对 apply，am 支持从电子又见格式 patch
(note: $ git am 之前，最好先运行下 $ git --abort 去除垃圾信息)

*一段工作后，如果你不想把新修改的内容提交到的版本，
而是提供到上一个中，使用 --amend 选项:
$ git commit --amend -m "version again"

$ git checkout hello.c 取消文件修改
$ git reset HEAD hello.c 取消 git add
$ git reset --mixed HEAD^ 取消 git add 和 git commit
$ git reset --hard versionxxx 
------------------------------------
* --- Branch        .---.
                    | m |
                    ^---^
                      Y
.---.     .---.     .---.
| 1 | --> | 2 | --> | 3 |
^---^     ^---^     ^---^
            Y
          .---.     .---.     .---.
          | n | --> |n-1| --> |n-2|
          ^---^     ^---^     ^---^

*分支是用指向 commit 对象的可移动的轻量级指针
$ git branch test
$ git checkout test
(note: 可用 $ git checkout -b test 代替上面的两句)
$ git chechout master
$ git merge test 
$ git branch -m [old] [new]

*正在某分支工作突然需要切换另一个分支工作，可还不想提
交当前分支，这时用到 $ git stash。完成另一个分支的工作
后再切换到该分支，用 $ git stash apply [@{n}] 恢复放入
栈内的内容.
$ git stash list 查看栈内 stash 信息
$ git stash clear 清空栈
------------------------------------
* --- Working with Remotes

$ git remote [-v]
$ git remote add [shortname] [url]
$ git fetch [remote-name]
$ git remote rename 
$ git remote rm 
*$ git remote show [remote-name] 

$ git check -b br1 origin/svrbr
(note: 检出服务器的 svrbr 分支到本地 br 分支)
$ git push origin br:svrbr
(note: 推送本地 br 分支到服务器的 svrbr 分支
不过，在此之前要先 $ git fetch origin, 把服务器
上分支改动的信息取到本地。)

$ git push [remote] :[branch]
(note: 删除服务器上的某分支)

*删除远程仓库的 commit:
	在本地仓库执行 $ git reset --hard sh-1，然后
$ git push -f

*在本地库中删除所有远程库 origin 中已不存在的分支:
$ git remote prune origin 
------------------------------------
* --- Git advanced skill

*Git 支持自动补全
$ cp git/contrib/completion/git-completion.bash ~/.git-completion.bash
在 .bashrc 中加入：
if [ -f .git-completion.bash ]; then
	. .git-completion.bash
fi

$ git reflog record your commit history
(note: afer a $ git reset --hard abcde, the sha-1 "abcde" 
are still in reflog, you can run $ git reset --hard abcde to
reset it. the $ git gc --prune=0 does not clear refs still in
reflog, so you should run 
$ git reflog expire --expire-unreachable=0 --all 
firstly)

$ git rebase -i sha1-id 
(note: rebase to delete some commit)

$ git cherry-pick [–n] <commit name>
(note: merge a commit)

$ git branch <new branch> <start point>

$ cp git-completion.bash ~/.git-completion.bash 
$ echo ". ~/.git-completion.bash" >> ~/.bashrc
(note: auto-completion)
------------------------------------
* --- Gitolte

* pre-git check:
(any permission that contains "R"/"W" matches a read/write operation.
In addition, gitolite ignores deny rules during the pre-git check.
so Wally in our example will pass the pre-git check.)


* update check: git gives us all the information we need. Then:
(   1. All the rules for a repo are accumulated.
    2. The rules pertaining to this repo and this user are kept;
       the rest are ignored.
    3. These rules are examined in the sequence they appeared in the conf file.
    For each rule:
        a. If the ref does not match the refex, the rule is skipped.
        b. If it is a deny rule (the permissions field is a -), 
           access is rejected and the matching stops.
        c. If the permission field matches the specific type of write
           operation, access is allowed and the matching stops.
    If no rule ends with a decision, ("fallthru"), access is rejected.
)


# --------- Shell Basic 

------------------------------------
* --- File 
1. (cp / ln / mv) src des(Destination)

2. 【硬连接】
在Linux中，多个文件名指向同一索引节点是存在的。
只有当最后一个连接被删除后，文件的数据块及目录
的连接才会被释放。

【软连接】
它实际上是一个特殊的文件。在符号连接中，文件实际
上是一个文本文件，其中包含的有另一文件的位置信息。

3. suid sgid
进程在运行的时候，有一些属性，其中包括实际用户ID,
实际组ID,有效用户ID,有效组ID等。 实际用户ID和实际
组ID标识我们是谁，谁在运行这个程序,一般这2个字段
在登陆时决定，在一个登陆会话期间， 这些值基本上不改变。

而有效用户ID和有效组ID则决定了进程在运行时的权限。
SUID的优先级比SGID高，当一个可执行程序设置了SUID，
则SGID会自动变成相应的egid

[root@sgrid5 bin]# ls -l passwd

[root@beauty ~]# ls -l /usr/bin/passwd 
-rwsr-xr-x 1 root root 25980 2月  22 2012 /usr/bin/passwd

虽然你以test登陆系统，但是当你输入passwd命令来更改密码的时候，由于 passwd设置了SUID位，因此虽然进程的实际用户ID是test对应的ID，但是进程的有效用户ID则是passwd文件的所有者root的ID, 因此可以修改/etc/passwd文件。
