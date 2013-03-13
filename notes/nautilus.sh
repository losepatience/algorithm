#! /usr/bin/gvim

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
* --- Install wps beta1
下载 wps-office_8.1.0.3724~b1p2_x86.tar.xz 并解压为 wps
$ cd wps
$ mkdir tmplib
$ cp xx/libstdc++.so.6.0.17 xx/libfreetype.so.6.8.0 ./tmplib
$ ln -s ....
vim wps/wpp/et and add
  export LD_LIBRARY_PATH=xx/wps/tmplib:$LD_LIBRARY_PATH
beta 版本有 bug, 目前只能用 sudo 才行!
------------------------------------
* --- Install texlive-cjk
$ cat > /etc/yum.repos.d/texlive.repo << EOF
[texlive]
name=TeXLive
baseurl=http://jnovy.fedorapeople.org/texlive/2011/packages.el6/
enabled=1
gpgcheck=0
EOF
$ yum install texlive-cjk
(note: By default, fonts are installed in
/usr/share/texlive/texmf-dist/tex/latex/cjk/texinput/
ls this dir and use one.
Example:
	\begin{CJK}{UTF8}{gbsn}
)
------------------------------------
* --- Install fonts
$ cp *.ttf /usr/share/fonts/tauren
$ cd /usr/share/fonts/tauren
$ mkfontscale
$ mkfontdir
$ fc-cache -fv
(note:
mkfontdir: 搜索所用字体文件，去其后缀作为字体名，并把字体
名、字体文件、参数写入到 font.dir 供 X 服务器使用
fc-cache -fv: 刷新字体缓存
fc-list: 查看已安装的字体
)
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

* --- Edit
w 下一词词首, b 上一词词首. e 下一词词尾(ge).
(note: 大写版本将忽略除空格和 tab 外的分割符)

^+e 向上滚屏(下移一行), ^+y 方向相反

zt 当前行置顶, zz 置中, zb 置底.

d4w: 不删除第 5 词词首. !!!c2w: 不删除词前空格
(note: x->dl X->dh D->d$ C->C$ s->cl S->cc)

. 命令重复除 ^+r 和 u 外的所有编辑命令.

daw 删词及词后空格, diw: 删词(note: das dis cis cas)

Visual: try o & O

* --- 加速:
:cmd: ^+l 向左一词, ^+r 向右, ^+b 行首, ^+e 行尾, ^+w 删词

z-o --- z-c
^+a: 数字加1
insert 模式: ^+w 删除词

读取当前目录下的内容到第 10 行: :10read !ls
:write !wc 内容通过标准输入送入指定的命令中.

global:
:g/^/m 0
line(".")  当前光标所在行的行号
line("'<") 所选区域第一行的行号
string starting with "\=" is evaluated as an expression
:g/^/s/^/\=line("."). " "/
:s/^/\=1 + 2/

:let n=0 | g/abc(\zs\d\+/s//\=n/|let n+=1 ;)
let 为变量赋值 (:help let )
| 用来分隔不同的命令 (:help :bar )
g 在匹配后面模式的行中执行指定的ex命令 (:help :g )
\zs 指明匹配由此开始 (:help /\zs )
\d\+ 查找1个或多个数字 (:help /\d )
s 在选中的区域中进行替换 (:help :s )
\= 指明后面是一个表达式 (:help :s\= )

:s/abc\zs[a-z]\ze//
\zs 替换开始处
\ze 替换结束处

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
(note: user+sys 占用的 cpu 时间, real 总时间(cpu + dma))

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

$ rm /etc/fonts/conf.d/49-sansserif.conf
(*note: Solve chinese confusion code in evince)

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


# --------- Shell

------------------------------------
* --- Sha-Bang
  '#!' 实际上是一个 2byte 的幻数(幻数用以指明文件类型)
'#!' 指明文件为可执行文件. 其后紧跟一个路径名, 他是用来
执行此脚本的命令(可以是 shell, gcc, 或者是 utility). 如
果脚本没有使用 bash 内建规则, 可以省略 '#!'


# --------- menuconfig

------------------------------------
* --- start-up
init 进程首先进行一系列的硬件初始化, 然后通过命令行
传递过来的参数挂载根文件系统. 最后 init 进程会根据
"init" 启动参数启动第一个用户进程, 如果没有 init=noinitrd
就会按序搜素: /sbin/init /etc/init /bin/init /bin/sh

* --- General setup
Automatically append version information to the version string
在版本字符串后添加版本信息, 编译时需有 perl 及 git 仓库支持

Support for paging of anonymous memory (swap)
支持 swap 分区

System V IPC
System V 进程间通信(IPC)支持, 许多程序需要这个功能. 必选.

BSD Process Accounting
将进程的统计信息写入文件的用户级系统调用, 包括进程的创
建时间/创建者/内存占用等信息.
$ accton /var/account/pacct
$ sa -u
$ accton # stop
root       0.00 cpu      466k mem accton           
root       0.01 cpu     2082k mem sudo 

Export task/process statistics through netlink (N)
通过通用的网络输出进程的相应数据到用户空间, 进程通信的
一种(taskstats), 参考 Documents/accounting/getdelays.c.

Auditing support
记录文件的所有访问和修改, selinux 用以跟踪 audit, 确认访
问授权

Control Group support (N)
cgroups 支持, cgroups 主要作用是给进程分组, 并可以动态调
控进程组的 CPU 占用率. 比如给予 apple 组 20% CPU占用率.

Kernel->user space relay support (formerly relayfs) (N)
在某些文件系统上(如 debugfs)提供从内核空间向用户空间传
递大量数据的接口.

Configure standard kernel features (4 small systems) (Y)
  Enable 16-bit UID system calls
  允许对 UID 系统调用进行过时的 16bit 包装

  Sysctl syscall support
  不需重启就能修改内核的某些参数和变量, 从 /proc/sys 存取
  可以影响内核行为的参数或变量

  Load all symbols for debugging/kksymoops
  装载所有的调试符号表信息, 仅供调试时选择
    Do an extra kallsyms pass
    除非你要报告 kallsyms 中的 bug 才打开

  Support for hot-pluggable devices
  支持热插拔设备, 如 usb, udev 也需要它

  Enable support for printk
  允许内核向终端打印字符信息

  BUG() support
  显示故障和失败条件(BUG和WARN)

  Enable ELF core dumps
  内存转储支持, 可以帮助调试 ELF 格式的程序

  Enable full-sized data structures for core
  禁用它将减小某些内核数据结构, 但会降低性能

  Enable futex support
  快速用户空间互斥体可以使线程串行化以避免竞
  态条件, 也提高了响应速度. 禁用它将导致内核
  不能正确的运行基于 glibc 的程序

  Enable eventpoll support
  支持事件轮循的系统调用

  Use full shmem filesystem
  完全使用 shmem 来代替 ramfs. shmem 可以挂载为
  tmpfs 供用户空间使用, 它比简单的ramfs先进许多

Disable heap randomization
随机堆会让堆的开发更加困难, 它同样会破坏传统的二进制
文件(libc5), 这个选项使系统启动时变为禁止随机堆, 运行
时可设 /proc/sys/kernel/randomize_va_space 为 2 来
修改, 较新的发行版, 该项是安全的。

Choose SLAB allocator (slub)
slab 默认的, 它已经被证实在所有的环境中都工作得很好.
slub 最小化了缓冲, 高效使用内存，还有加强的诊断(试新)

Profiling support (N)
提供一种检测代码运行效率的工具, 为 OProfile 所用。

* --- Enable loadable module support
Module versioning support
支持其他内核编译的模块

Source checksum for all modules
模块(ko)中包含 MODULE_VERSION, 如果选中此项还会包含
srcversion(源代码的 sum)

* --- Enable the block layer
Block layer SG support v4 (N)
支持通用 scsi 块设备第 4 版

Block layer data integrity support (N)
一些储存设备允许额外信息的储存和找回, 以便保护数据
此选项提供了相应的挂钩, 这可以用于文件系统中，以确
保更好的数据完整性. 如果你的设备提供了 T10/SCSI 数
据完整性域 或 T13/ATA 扩展路径保护功能, 选中.

I/O Schedulers (CFQ)
Deadline I/O scheduler
保证对于既定的 IO 请求以最小的延迟时间响应,
在数据库应用方面性能要比 CFQ 好
CFQ I/O scheduler
尝试为所有进程提供相同的带宽. 它将提供平等的工作环境,
对绝大多数应用程序都有高性能的表现. 另外可改变
/proc/sys/scsi/nr_requests 来适配 I/O 子系统

* --- FIQ Mode Serial Debugger (N)
调试 kernel 用, 不选

* --- Bus support
PCI Stub driver
比如一个 e1000e 的网卡已和一个 e1000e 的驱动结合, 虚拟机又
想自己驱动这个 e1000e 网卡, 使用PCI Stub 将这个 pci 设备跟
目前绑定的驱动分离, 暂时由 PCI Stub driver 接管, 最后交给
虚拟机. ARM 上有虚拟机? 所以不选.
$ echo '8086 10f5' > /sys/bus/pci/drivers/pci-stub/new_id
$ echo -n 0000:00:19.0 > /sys/bus/pci/drivers/e1000e/unbind
$ echo -n 0000:00:19.0 > /sys/bus/pci/drivers/pci-stub/bind

PCI IOV support
SR-IOV 是一个 pcie 的扩展功能, 使得一个物理设备表现为
多个虚拟设备虚拟设备的分配可通过设置设备的寄存器完成,
每个虚拟设备都有自己独立的寄存器和 ID

* --- Kernel Features
Tickless System (Dynamic Ticks)
传统 kernel 有一致命缺陷就是时间滴答周期性的发生, 不顾
处理器正处于忙还是闲的状态. 如果处理器处于闲置, 它也会
每隔一段周期去唤起正处于省电模式下的处理器. 耗电. 
采用 tickless idle(空闲循环)的机制, 内核将会在 CPU 空闲
时消除这个周期性的时间滴答, 但如果 CPU 频繁的被计时事件
唤起, 那么空闲循环机制的优势将消失. 此选项致力于尽可能
长时间的利用 tickless idle 机制

High Resolution Timer Support
开启高分辩率时钟支持. 如硬件不够好, 只是增加内核的尺寸

Enable KSM for page merging
查找相同的内存页合为一页, 然后映射到应用各自的空间, 并被
标记为 copy-on-write, 写的时候再分为不同的页, 主要用于
有多个虚拟机的系统.

* --- File systems
xxx POSIX Access Control Lists
POSIX ACL, 可以更精细的针对每个用户进行访问控制

xxx Security Labels
安全标签支持可选的访问控制模块, 这些模块被例如 SELinux
中的安全模块执行

Quota support
配额支持
  Report quota messages through netlink interface
  通过网络连接接口报告配额信息
  Print quota warnings to console
  在控制台打印配额警告(废弃不用)

General filesystem local caching manager (N)
Filesystem caching on files
缓存文件系统, 用一个高速硬盘上的一个专用的文件系统来
做缓存, 带动慢速硬盘, 主要用于网络文件系统. 需要上层
软件套件的支持.
参考 http://en.gentoo-wiki.com/wiki/CacheFS

Pseudo filesystems 
  Userspace-driven configuration filesystem (N)
  基于 ram 的文件系统, 它提供与 sysfs 相对应的功能.
  是一个管理内核对象的文件系统, 或者配置系统
  参考 https://www.ridgerun.com/developer/wiki/index.php/How_to_use_configfs

* --- Networking options
Packet socket
直接与网络设备通讯, 而不通过内核中的其它中介协议, 一些
应用程序是使用它实现的(如 tcpdump, iptables)

Unix domain sockets
仅运行于本机上的效率高于 TCP/IP 的Socket, 简称 Unix socket.
许多程序都使用它在操作系统内部进行进程间通
信(X-Window syslog)

PF_KEY sockets
IPsec 协议族一员, 要使用 IPsec 须选该项, 一般可不选该项

IP: kernel level autoconfiguration
使用 nfs 启动必选, 支持从 cmdline 或其后所随的 3 个协议
来确定自身 IP, Root file system on NFS 依赖于它. 参考
Documentations/filesystems/nfs/nfsroot.txt


* --- Device Drivers 
Generic Driver Options
  Path to uevent helper (N)
  每个 uevent kernel 都会调用此脚本, 在 netlink-based uevent
  之前, 它用来处理 uevent 时间, 因系统启动或设备加载时会产
  生大量 uevent, 负荷太重, 现在已经舍弃 

  Maintain a devtmpfs filesystem to mount at /dev 
  Automount devtmpfs at /dev, after the kernel mounted the rootfs (NEW)
  在所有设备文件注册前, 生成一个 tmpfs. 为每个拥有
  major/minor 的设备在此 tmpfs 上生成一个节点. 当文件
  系统挂载后, 此 tmpfs 被 mount 到 /dev. 此文件系统可
  在用户空间被任意修改, 这使得 init=/sbin/sh 不需额外
  支持就能工作正常. 系统启动后 udev daemon 会启动并聆
  听来自 Linux 核心的 uevent.

Connector - unified userspace <-> kernelspace linker (N)
连接器是一种 netlink, 协议号为 NETLINK_CONNECTOR, 与一般
的内核 netlink 接口相比, 它更容易使用

Memory Technology Devices (MTD)
  MTD concatenating support
  将并置的几个 MTD 设备整合成一个(虚拟的)设备. 就如一个
  一样操作, 分区.

  Direct char device access to MTD devices
  直接字符设备到 MTD 设备的访问, /dev/mtdN

  Caching block device access to MTD devices
  大部分 mtd 设备的 erase_size 都很大, 因此不能当作块设备
  使用, 所以此接口并不安全 /dev/mtdblockN

  FTL (Flash Translation Layer) support 
  在 flash 上使用某种伪文件系统, 模拟一个 521-byte sector 的
  块设备. 在 flash 上架 fat16/fat32/ntfs/ext2 文件系统时才需
  要选上. 否则 ftl_cs:FTL header not found. 
  NFTL(same but nand), INFTL(same but DiskOnChip)

  Resident Flash Disk (Flash Translation Layer) support
  提供RFD支持, 为嵌入式系统提供类似 BIOS 功能

  NAND SSFDC (SmartMedia) read only translation layer
  SmartMedia/xD new translation layer
  类似 FTL 的另一种模拟块设备支持  

  Mapping drivers for chip access (N)
  把 norflash 映射到内存空间, 读写时可用 memcpy 等

  Include chip ids for known NAND devices
  为不使用 nand 子系统的驱动提供 nand ids

Block devices
  Compaq SMART2 support (N)
  基于 Compaq SMART2 控制器的磁盘阵列卡, 一般没有, 加载
  驱动后, 生成 /dev/idaN 节点.

  Compaq Smart Array 5xxx support
  基于 Compaq SMART 控制器的磁盘阵列卡

  Mylex DAC960/DAC1100 PCI RAID Controller support
  古董级产品

  Micro Memory MM5415 Battery Backed RAM support
  一种使用电池做后备电源的内存

  Loopback device support
  Loopback 是指拿文件来模拟块设备, 比如可以将一个
  iso 文件挂成一个文件系统, mount -o loop abs.iso /mnt/tmp

  Network block device support
  让你的电脑成为网络块设备的客户端

  Promise SATA SX8 support
  基于 Promise 公司的 SATA SX8 控制器的 RAID 卡

  Low Performance USB Block driver
  它不是用来支持 U 盘的,不懂的就别选

  RAM disk support
  内存中的虚拟磁盘,大小固定(由下面的选项决定), 它的
  功能和代码都比 shmem 简单许多
    Default number of RAM disks
    Default RAM disk size (kbytes)
    Default RAM disk block size (bytes)

  Packet writing on CD/DVD media
  CD/DVD 刻录支持
    Free buffers for data gathering
    用于收集写入数据的缓冲区个数(每个占用 64Kb 内存),缓冲区越多性能越好
    Enable write caching
    为 CD-R/W 设备启用写入缓冲, 目前这是一个比较危险的选项

  ATA over Ethernet support
  以太网 ATA 设备支持

Character devices
  Non-standard serial port support
  非标准串口支持. 这样的设备早就绝种了
  
  Serial drivers
  串口驱动.

  Unix98 PTY support
  PTY 模拟一个终端, 由 slave(等价于一个物理终端)和 master(被
  一个诸如 telnet 之类的进程用来读写 slave 设备)两部分组成的
  软设备. 使用 telnet/ssh 必选

  Legacy (BSD) PTY support
  过时的 BSD 风格的 /dev/ptyxx 作为 master, /dev/ttyxx 作为 slave,
  这个方案有一些安全问题, 建议不选

  RAW driver (/dev/raw/rawN)
  已废弃

  








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
实际组ID, 有效用户ID, 有效组ID等。 实际用户ID和实际
组ID标识我们是谁，谁在运行这个程序, 一般这2个字段
在登陆时决定，在一个登陆会话期间， 这些值基本上不改变。

而有效用户ID和有效组ID则决定了进程在运行时的权限。
SUID的优先级比SGID高，当一个可执行程序设置了SUID，
则SGID会自动变成相应的egid

[root@sgrid5 bin]# ls -l passwd

[root@beauty ~]# ls -l /usr/bin/passwd
-rwsr-xr-x 1 root root 25980 2月  22 2012 /usr/bin/passwd

虽然你以test登陆系统，但是当你输入passwd命令来更改密码的时候，由于 passwd设置了SUID位，因此虽然进程的实际用户ID是test对应的ID，但是进程的有效用户ID则是passwd文件的所有者root的ID, 因此可以修改/etc/passwd文件。
