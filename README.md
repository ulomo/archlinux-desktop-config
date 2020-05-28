> archlinux+xmonad+polybar，刚开始使用tiling window manager或许是因为它很轻量。但是使用久了就会觉得它有其它桌面无法取代的优点，定制化强，需要什么功能，那么自己动手写一个，然后映射一下快捷键。总之使用起来感觉很好！

# 下载

```shell
pacman -S xmonad xmonad-contrib polybar xterm
```



# 配置文件位置

```shell
# polybar
~/.config/polybar
# xmonad
~/.xmonad/xmonad.hs
```



# polybar

## 字体

```shell
awesome-terminal-fonts
```

## 一些配置文件

polybar文件夹下的一些脚本是用来实现特定功能的，目前启用的只有docker.sh





---

# xmonad中快捷键涉及的软件

由于配置文件中有一些是基于软件来实现的，所以可以选择是否下载。当然不下载也不会报错

```shell
flameshot --截图软件
obs	--录屏推流
dunst --显示消息
rofi --搜索
```



# 重要快捷键功能

一些简单的以及内置的快捷键这里就不列举了，只写一些比较重要的

```shell
modkey+n #打开terminal
modkey+F2 #音量+5
modkey+F3 #音量-5
modkey+F4 #亮度-2
modkey+F5 #亮度+2
modkey+r #搜索
modkey+b #显示/隐藏polybar
modkey+y #隐藏窗口
modkey+shift+y #还原窗口
modkey+f #最大化窗口
modkey+space #切换布局
modkey+backspace #关闭窗口
modkey+s+backspace #关闭所有窗口
modkey+w #选择workspace，j/k/l选择workspace
modkey+p #全屏截屏，保存位置~/Pictures/screenshot

#调出scatchpad
modkey+u #中间
modkey+i #上面
modkey+o #右边

modkey+left_click #悬浮窗口
modkey+right_click #缩放窗口
modkey+s+t #全部取消悬浮

modkey+s+y #复制窗口到所有workspace
modkey+s+x #删除其它复制窗口

modkey+\+p #打开截图软件
modkey+\+k #打开/关闭screenkey
modkey+\+r #重启polybar
modkey+\+m #静音
modkey+\+v #打开obs
modkey+\+t #对选中的词进行翻译，并循环提醒。需要插件和配置支持
```

![](https://raw.githubusercontent.com/ulomo/archlinux-desktop-config/master/desktop.png)




