--                                       _                    __ _       
-- __  ___ __ ___   ___  _ __   __ _  __| |   ___ ___  _ __  / _(_) __ _ 
-- \ \/ / '_ ` _ \ / _ \| '_ \ / _` |/ _` |  / __/ _ \| '_ \| |_| |/ _` |
--  >  <| | | | | | (_) | | | | (_| | (_| | | (_| (_) | | | |  _| | (_| |
-- /_/\_\_| |_| |_|\___/|_| |_|\__,_|\__,_|  \___\___/|_| |_|_| |_|\__, |

-- ====================================================================================================
--note: variables if directory changed or script changed the following may also be changed
--    "~/Document/script/shell/changeDesktopBg.sh"
-- ====================================================================================================
--{{{ import module
-------------------------------------------------------------------------------------------- import modules
--import XMonad
import System.IO
import XMonad.Actions.CycleWS  --movie/cycle windows between workspaces
import XMonad.Actions.SimpleDate  --popup the date with dzen2
import XMonad.Actions.Submap  --create a sub-mapping of key bindings
import XMonad.Actions.NoBorders   --used in all window
import XMonad.Actions.FloatKeys  --position window with float
import XMonad.Actions.WithAll  --make effort for all windows
import XMonad.Hooks.DynamicLog  --for xmobar
import XMonad.Hooks.InsertPosition  --choose new window position
import XMonad.Util.EZConfig  --set shortkeys
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import XMonad.Layout.NoBorders    --used in fullscreen
import XMonad.Layout.Spacing   --set edge space of window
import XMonad.Layout.ResizableTile  --adjust vertical height
import XMonad.Layout.Minimize  --toggle miniscreen
import XMonad.Layout.Hidden  --hide window
import XMonad.Layout.ToggleLayouts   --toggle circle windows
import XMonad.Layout.NoFrillsDecoration  --set windows titlebar
import XMonad.Layout.WindowNavigation  --move or swap focus window between left and right
import XMonad.Prompt
import XMonad.Prompt.Window
import XMonad.Prompt.AppLauncher as AL --search app
import XMonad.Hooks.WorkspaceHistory

------------------------------------------------------------------------------------------- shift to window/float window/manage dock
import XMonad.ManageHook
import XMonad.Hooks.ManageDocks  --toggle xmobar hidden
import Control.Monad (liftM2)

------------------------------------------------------------------------------------------- scratchpad
import XMonad.Util.NamedScratchpad
------------------------------------------------------------------------------------------- layout
import XMonad.Layout.Maximize  --toggle fullscreen
import XMonad.Layout.CenteredMaster
import XMonad.Layout.Grid
import XMonad.Layout.Dishes
import XMonad.Layout.OneBig
import XMonad.Layout.Accordion
import XMonad.Layout.ThreeColumns
------------------------------------------------------------------------------------------- toggle layout
import XMonad.Layout.ToggleLayouts
------------------------------------------------------------------------------------------- sub layout
--import XMonad.Util.Themes
import XMonad.Layout.SubLayouts
--import XMonad.Layout.WindowNavigation
import XMonad.Layout.Tabbed
import XMonad.Layout.Simplest
------------------------------------------------------------------------------------------- copy window to all
import XMonad.Actions.CopyWindow
------------------------------------------------------------------------------------------- jump to layout
import XMonad hiding ( (|||) )
import XMonad.Layout.LayoutCombinators

------------------------------------------------------------------------------------------- diff workspace has diff layout
import XMonad.Layout.PerWorkspace
------------------------------------------------------------------------------------------- goto workspace with apps open up
import XMonad.Actions.DynamicProjects

------------------------------------------------------------------------------------------- runinterm for workspace
import XMonad.Util.Run

--import XMonad.Layout.SimpleFloat --used to float one whole workspace
import XMonad.Layout.SimplestFloat --used to float one whole workspace,this one works much better

--used to set workspace with tree select
import Data.Tree
import XMonad.Actions.TreeSelect
import XMonad.Hooks.WorkspaceHistory
import qualified XMonad.StackSet as W

---}}}

-------------------------------------main funcation-------------------------------------------------{{{
----------------------------------------------------------------------------------------------------
--this is the method to toggle status bar: main add docks and layouthook add avoidStruts then bind a key to toggle status bar ,really nice
main = do
	xmonad 
		$ docks  
		$ dynamicProjects projects 
		$ myConfig 
-- }}}
--{{{ myconfig
myConfig = defaultConfig { modMask = mod4Mask
						 , borderWidth = 0
						 , normalBorderColor  = "#eedfdf" -- #1d2935  #FF7F24 #d57a39
						 , focusedBorderColor = "#eedfdf"
                         , terminal = myTerminal
						 --, workspaces = myWorkspaces
						 , workspaces = toWorkspaces myWorkspaces --tree select support
                         , focusFollowsMouse = False
                         , mouseBindings = myMouseBindings 
                         , layoutHook = avoidStruts $ myLayoutHook 
                         , logHook = workspaceHistoryHook 
						 , manageHook = myManageHook <+> manageHook defaultConfig <+> insertPosition End Newer <+> namedScratchpadManageHook myScratchPads
                          }`additionalKeys` myKeys-- }}}
-- {{{ terminal and workspace
myTerminal = "xterm"
-- myWorkspaces = ["1:home","2:web","3:term","4:term","5:write","6:paint","7:vbox","8:monitor","9:music"]-- }}}
-- {{{ diff workspace diff app
projects :: [Project] ------------------------------------------------------------------diff workspace with diff apps to start up
projects =
  [ Project { projectName      = "9:Music"
            , projectDirectory = "~/Music"
            , projectStartHook = Just $ do spawn "netease-cloud-music"
                                           runInTerm "-name cava" "cava"
                                           runInTerm "-name cava" "cava"
                                           --runInTerm "-name alsamixer" "alsamixer"
            }
--  , Project { projectName      = "8:monitor"
--            , projectDirectory = "~/"
--            , projectStartHook = Just $ do runInTerm "-name glances" "glances"
--                                           runInTerm "-name cava" "cava"
--                                           runInTerm "-name  " " "
--                                           runInTerm "-name " ""
----                                           spawn "/usr/lib/xscreensaver/glplanet"
--            }
  ]-- }}}
-- {{{ app station
myManageHook = composeAll
		[ className =? "netease-cloud-music"			--> viewShift "FSL9"
		, className =? "netease-cloud-music"			--> doF W.swapDown  --wow it is amazing,it make windows down,and suit for workspace5,which make music in the middle,really really nice
		, className =? "mplayer"						--> doIgnore
   		, className =? "firefox" 						--> viewShift "FSL2" --open window and shift to window
   		, className =? "firefox" 						--> doFloat
   		, className =? "firefox" 						--> doF W.swapMaster
   		, className =? "Typora" 						--> viewShift "FSL3" 
   		, className =? "Typora" 						--> doFloat
   		, className =? "Thunar"    						--> doFloat
   		, className =? "VirtualBox" 					--> viewShift "FSL5" 
   		, className =? "VirtualBox" 					--> doFloat
   		, className =? "VirtualBox"						--> doF W.swapMaster
   		, manageDocks
   		]
	where viewShift = doF . liftM2 (.) W.greedyView W.shift-- }}}
-- {{{ mylayout
myLayoutHook =  hiddenWindows
            $  maximizeWithPadding 0
            $  minimize 
            $  windowNavigation

            -- $  noFrillsDeco shrinkText topBarTheme
            -- $  addTabs shrinkText myTabTheme

            $  spacingWithEdge 2
			$  subLayout [0,1,2] (Simplest)
			-- $  onWorkspace "4:Float" simplestFloat
			$  onWorkspace "FSL9" three
			$  toggleLayouts talldiff tallsame  ||| Grid ||| noBorders Full ||| three
tallsame	 = ResizableTall 1 (1/100) (1/2) []
talldiff	 = ResizableTall 1 (1/100) (2/3) [] 
three		 = ThreeColMid 1 (3/100) (1/2)-- }}}
-- {{{ theme
topBarTheme = def
     { activeColor = "#FF7F24"
     , activeBorderColor = "#FF7F24"
     , activeTextColor = "#FF7F24"
     , inactiveColor = "#00868B"
     , inactiveBorderColor = "#00868B"
     , inactiveTextColor = "#00868B"
     , urgentColor = "#9AFF9A"
     , urgentBorderColor = "#9AFF9A"
     , urgentTextColor = "#C1C1C1"
     , decoHeight = 4
    }
myTabTheme = def
     { activeColor           = "#FF7F24"
     , inactiveColor         = "#00868B"
     , activeBorderColor     = "#FF7F24"
     , inactiveBorderColor   = "#00868B"
     , activeTextColor       = "#FF7F24" 
     , inactiveTextColor     = "#00868B"
     , urgentColor = "#9AFF9A"
     , urgentBorderColor = "#9AFF9A"
     , urgentTextColor = "#C1C1C1"
     , decoHeight = 8
     }-- }}}
-- {{{ key binding
-------------------------------------------------------------------------------------------- key bending
myKeys =
    [ ((mod1Mask, xK_F2),spawn "amixer set Master 5%-")
    , ((mod1Mask, xK_F3), spawn "amixer set Master 5%+")
    , ((mod1Mask, xK_F4 ), spawn "xbacklight -dec 2")
    , ((mod1Mask, xK_F5), spawn "xbacklight -inc 2")
    , ((mod4Mask, xK_F6), spawn "xinput disable 14")
    -- , ((mod4Mask, xK_n  ), spawn "xterm")  --new terminal
    , ((mod4Mask, xK_n  ), spawn "xterm")  --new terminal
    --, ((mod4Mask, xK_n  ), spawn "mate-terminal")  --new terminal
    , ((mod4Mask, xK_r  ), spawn "rofi -lines 4  -show drun -show-icons -theme android_notification.rasi -eh 2")  --show date usr dzen2
    , ((mod4Mask .|. shiftMask, xK_z), spawn "betterlockscreen  ~/Picture/background/healer.jpg -l -b 1 dim")  --lock screen
    , ((mod4Mask, xK_b), sendMessage ToggleStruts) --toggle status bar
-- navigate key
    , ((mod4Mask, xK_l), sendMessage $ Go R)
    , ((mod4Mask, xK_h), sendMessage $ Go L)
    , ((mod4Mask .|. mod1Mask, xK_i  ), sendMessage MirrorShrink)  --vertical shrink window
    , ((mod4Mask .|. mod1Mask, xK_o  ), sendMessage MirrorExpand)  --vertical expand window
    , ((mod4Mask .|. mod1Mask, xK_h  ), sendMessage Shrink)
    , ((mod4Mask .|. mod1Mask, xK_l  ), sendMessage Expand)
    , ((mod4Mask .|. shiftMask, xK_m), windows W.swapMaster)  --move window to master
    , ((mod4Mask, xK_y), withFocused hideWindow) --hide window
    , ((mod4Mask .|. shiftMask, xK_y), popOldestHiddenWindow) -- show hidden window
    , ((mod4Mask, xK_g  ), withFocused toggleBorder)  --togger window border
    , ((mod4Mask, xK_f  ), withFocused (sendMessage . maximizeRestore))  --toggle full window
    , ((mod1Mask, xK_Tab  ), toggleWS)  --toggle workspace in order
    , ((mod4Mask, xK_t), sendMessage ToggleLayout)  --toggle window frame
    , ((mod4Mask, xK_BackSpace), kill)  --kill window
    , ((mod4Mask, xK_w), treeselectWorkspace myts myWorkspaces W.greedyView)  --sellect treeworkspace
    , ((mod4Mask, xK_p), spawn "flameshot full -p ~/Pictures/screenshot")  --new terminal


-- funcation key
    , ((mod4Mask .|. shiftMask, xK_g     ), windowPrompt 
                                       def { autoComplete = Just 500000 }
                                       Goto allWindows)
    , ((mod4Mask .|. shiftMask, xK_b     ), windowPrompt 
                                       def { autoComplete = Just 500000 }
                                       Bring allWindows)
-- scratchpad
    , ((mod4Mask, xK_u), namedScratchpadAction myScratchPads "terminal" )
    , ((mod4Mask, xK_i), namedScratchpadAction myScratchPads "topTerm" )
--    , ((mod4Mask, xK_i), namedScratchpadAction myScratchPads "bottomLeftTerm" )
    , ((mod4Mask, xK_o), namedScratchpadAction myScratchPads "bottomRightTerm" )
    , ((mod4Mask, xK_v), namedScratchpadAction myScratchPads "leftTerm" )
-- sub key s ----------------------------------------------------------------------------- used for navigate
    , ((mod4Mask , xK_s), submap . M.fromList $
       [ ((0 , xK_j), nextWS)  --jump to next workspace 
       , ((0 , xK_k), prevWS)  --jump to previous workspace 
       , ((0 , xK_l), shiftToNext)  --shift window to next workspace 
       , ((0 , xK_h), shiftToPrev)  --shift window to previous workspace 
       , ((0 , xK_t), sinkAll)  --unfloat all window
       , ((0 , xK_BackSpace), killAll)  --kill all window
       , ((0 , xK_c), sendMessage ToggleLayout)  --toggle window frame
	   , ((0 , xK_y), windows copyToAll) --copy window to all desktop
	   , ((0 , xK_x), killAllOtherCopies)
       ])
-- sub key d ----------------------------------------------------------------------------- used for sublayout
    , ((mod4Mask , xK_d), submap . M.fromList $
       [ ((0 , xK_h), sendMessage $ pullGroup L)
       , ((0 , xK_l), sendMessage $ pullGroup R)
       , ((0 , xK_k), sendMessage $ pullGroup U)
       , ((0 , xK_j), sendMessage $ pullGroup D)
       
       , ((0 , xK_m), withFocused (sendMessage . MergeAll))
       , ((0 , xK_u), withFocused (sendMessage . UnMerge))
       
       , ((0 , xK_period), onGroup W.focusUp')
       , ((0 , xK_comma), onGroup W.focusDown')
       ])
-- sub key \ ----------------------------------------------------------------------------- used for launch app
    , ((mod4Mask , xK_backslash), submap . M.fromList $
       [ ((0 , xK_v), spawn "obs --minimize-to-tray")  --start video record app
       , ((0 , xK_p), spawn "flameshot &")  --start screen capture app
	   , ((0 , xK_s), spawn "rofi -show ssh -show-icons -theme lb.rasi -terminal xterm")  --launch ssh connect window
       , ((0 , xK_b), spawn "~/Documents/script/shell/changeDesktopBg.sh") --run change desktop picture program
       , ((0 , xK_k), spawn "~/.local/bin/showkey") --toggle screenkey program on or off
       , ((0 , xK_o), spawn "pkill changeDesktopBg ; pkill sleep") --stop change desktop picture program 
       , ((0 , xK_r), spawn "pkill polybar; polybar -r -q mybar >/dev/null 2>&1 &") --stop change desktop picture program 
       , ((0 , xK_m), spawn "amixer set Master toggle")  --toggle amixer mute
       --, ((0 , xK_t), spawn "translate \"`xclip -o`\" | xargs -0 notify-send && xclip -o | paste -s >> ~/Documents/books/remember_word.txt")  
       , ((0 , xK_t), spawn "translate \"`xclip -o`\" | xargs -0 notify-send ") -- faster translate 
       , ((0 , xK_f), AL.launchApp def "firefox")  --a prompt search for firefox
       , ((0 , xK_1), windows $ W.greedyView "FSL1")
       , ((0 , xK_2), windows $ W.greedyView "FSL2")
       , ((0 , xK_3), windows $ W.greedyView "FSL3")
       , ((0 , xK_4), windows $ W.greedyView "FSL4")
       , ((0 , xK_5), windows $ W.greedyView "FSL5")
       , ((0 , xK_6), windows $ W.greedyView "FSL6")
       , ((0 , xK_7), windows $ W.greedyView "FSL7")
       , ((0 , xK_8), windows $ W.greedyView "FSL8")
       , ((0 , xK_9), windows $ W.greedyView "FSL9")
       ])
-- sub key a ------------------------------------------------------------------------------- jump layout
--    , ((mod4Mask , xK_a), submap . M.fromList $
--       [ ((0 , xK_g ), sendMessage $ JumpToLayout "Grid")
--       , ((0 , xK_c ), sendMessage $ JumpToLayout "Accordion")
--       , ((0 , xK_t ), sendMessage $ JumpToLayout "talldiff")
--       , ((0 , xK_d ), sendMessage $ JumpToLayout "dishes")
--       , ((0 , xK_o ), sendMessage $ JumpToLayout "onebig")
--       , ((0 , xK_f ), sendMessage $ JumpToLayout "Full")
--       ])
    ]-- }}}
-- {{{ mouse binding
-------------------------------------------------------------------------------------------- float window
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w)) --modekey+left move window
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w)) ] --modekey+right resize window
--    [ ((0, button2), (\w -> focus w >> mouseMoveWindow w)) --middle click move window
--    , ((0, button3), (\w -> focus w >> mouseResizeWindow w)) ] --right click resize window
-- {{{ scratch pads
-------------------------------------------------------------------------------------------- scratch window
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                -- NS "terminal" "kitty" (className =? "kitty") manageTerm

                , NS "topTerm" spawnTerm1  findTerm1 manageTerm1
--                , NS "bottomLeftTerm" spawnTerm2  findTerm2 manageTerm2
                , NS "bottomRightTerm" spawnTerm3  findTerm3 manageTerm3
                , NS "leftTerm" spawnTerm4  findTerm4 manageTerm4
		        ]
	where
    spawnTerm = myTerminal ++  " -name centerTerm" ----------------------------------------- center terminal
    findTerm = resource =? "centerTerm"
    manageTerm = customFloating $ W.RationalRect l t w h 
		where
        h = 0.85 
        w = 0.9
        t = 0.07      -- bottom edge
        l = 0.05      -- left

    spawnTerm1 = myTerminal ++  " -name popupterm" ----------------------------------------- command terminal
    findTerm1 = resource =? "popupterm"
    manageTerm1 = customFloating $ W.RationalRect l t w h 
		where
        h = 0.2     --hight
        w = 1.0     --width
        t = 0.02    -- bottom edge
        l = 0.0     -- left

--    spawnTerm2 = "urxvt" ++  " -name blterm" ----------------------------------------------- bottom left terminal
--    findTerm2 = resource =? "blterm"
--    manageTerm2 = customFloating $ W.RationalRect l t w h 
--		where
--        h = 0.05    --hight
--        w = 0.5     --width
--        t = 0.95    -- bottom edge
--        l = 0       -- left
    spawnTerm3 = myTerminal ++  " -name brterm" ----------------------------------------------- bottom right terminal
    findTerm3 = resource =? "brterm"
    manageTerm3 = customFloating $ W.RationalRect l t w h 
		where
        h = 0.15    --hight
        w = 0.25    --width
        t = 0.1   -- bottom edge
        l = 0.748     -- left
    spawnTerm4 = myTerminal ++  " -name topcterm" --------------------------------------------- top center terminal
    findTerm4 = resource =? "topcterm"
    manageTerm4 = customFloating $ W.RationalRect l t w h 
		where
        h = 0.96     --hight
        w = 0.5     --width
        t = 0.04     -- bottom edge
        l = 0.25    -- left}}}


---workspace---------------------------------------------------------{{{
--myWorkspaces = ["1:Home","2:Float","3:Program","4:Browser","5:Terminal","6:Writer","7:Vbox","8:Monitor","9:Music"]-- }}}
myWorkspaces :: Forest String
myWorkspaces = [ Node "FSL1" [] -- a workspace for your browser
               , Node "FSL2" []
               , Node "FSL3" []
               , Node "FSL4" []
               , Node "FSL5" []       
               , Node "FSL6" []
               , Node "FSL7" []
               , Node "FSL8" []
               , Node "FSL9" []
               ]

myts = TSConfig { ts_hidechildren = True
                           --, ts_background   = 0x00000000
                           -- , ts_background   = 0xffd4d4d4
                           , ts_background   = 0xff1C2B40
                           , ts_font         = "xft:Sans-16"
                           , ts_node         = (0xff839496, 0xff1C2B40)
                           , ts_nodealt      = (0xff839496, 0xff1C2B40)
                           , ts_highlight    = (0xffFF9100, 0xff1C2B40)
                           , ts_extra        = 0xff839496
                           , ts_node_width   = 180
                           , ts_node_height  = 40
                           , ts_originX      = 500
                           , ts_originY      = 500
                           , ts_indent       = 40
                           , ts_navigate     = M.fromList
                                [ ((0, xK_Escape), cancel)
                                , ((0, xK_Return), select)
                                , ((0, xK_space),  select)
                                , ((0, xK_Up),     movePrev)
                                , ((0, xK_Down),   moveNext)
                                , ((0, xK_Left),   moveParent)
                                , ((0, xK_Right),  select)
                                , ((0, xK_k),      movePrev)
                                , ((0, xK_j),      moveNext)
                                , ((0, xK_h),      moveParent)
                                , ((0, xK_l),      select)
                                , ((0, xK_o),      moveHistBack)
                                , ((0, xK_i),      moveHistForward)
                                ]
               }
--}}}
