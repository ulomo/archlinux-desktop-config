--                                       _                    __ _       
-- __  ___ __ ___   ___  _ __   __ _  __| |   ___ ___  _ __  / _(_) __ _ 
-- \ \/ / '_ ` _ \ / _ \| '_ \ / _` |/ _` |  / __/ _ \| '_ \| |_| |/ _` |
--  >  <| | | | | | (_) | | | | (_| | (_| | | (_| (_) | | | |  _| | (_| |
-- /_/\_\_| |_| |_|\___/|_| |_|\__,_|\__,_|  \___\___/|_| |_|_| |_|\__, |

-- ====================================================================================================
-- import modules
-- ====================================================================================================
--import XMonad
import System.IO
import XMonad.Actions.CycleWS  --movie/cycle windows between workspaces
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
import XMonad.Layout.PerWorkspace --diff workspace has diff layout
import XMonad.Actions.DynamicProjects --goto workspace with apps open up
import XMonad.Util.Run -- runinterm for workspace
---shift to window/float window/manage dock
import XMonad.ManageHook
import XMonad.Hooks.ManageDocks  --toggle xmobar hidden
import Control.Monad (liftM2)
--scratchpad
import XMonad.Util.NamedScratchpad
--layout
import XMonad.Layout.Maximize  --toggle fullscreen
import XMonad.Layout.Grid
import XMonad.Layout.OneBig
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ToggleLayouts --toggle layout
import XMonad.Layout.SubLayouts --sub layout
import XMonad.Layout.Tabbed
import XMonad.Layout.Simplest
import XMonad.Actions.CopyWindow --copy window to all
import XMonad.Layout.SimplestFloat --float workspace
--jump to layout
import XMonad hiding ( (|||) )
import XMonad.Layout.LayoutCombinators
--used to set workspace with tree select
import Data.Tree
import XMonad.Actions.TreeSelect
import XMonad.Hooks.WorkspaceHistory
import qualified XMonad.StackSet as W

-- for polybar info
import Data.List (sortBy)
import Data.Function (on)
import Control.Monad (forM_, join)
import XMonad.Util.Run (safeSpawn)
import XMonad.Util.NamedWindows (getName)
import qualified XMonad.StackSet as W



--this is the method to toggle status bar: main add docks and layouthook add avoidStruts then bind a key to toggle status bar ,really nice
main = do
    forM_ [".xmonad-workspace-log", ".xmonad-title-log"] $ \file -> do --for polybar info
        --safeSpawn "mkfifo" ["/tmp/" ++ file]
        safeSpawn "mkfifo" ["/tmp/.xmonad-title-log","/tmp/.xmonad-workspace-log"]

	xmonad 
		$ docks  
		$ dynamicProjects projects 
		$ myConfig 


myConfig = defaultConfig { modMask = mod4Mask
						 , borderWidth = 0
						 -- , normalBorderColor  = "#eedfdf" 
						 -- , focusedBorderColor = "#eedfdf"
                         , terminal = myTerminal
						 , workspaces = toWorkspaces myWorkspaces --tree select support
                         , focusFollowsMouse = False
                         , mouseBindings = myMouseBindings 
                         , layoutHook = avoidStruts $ myLayoutHook 
                         --, logHook = workspaceHistoryHook 
                         , logHook = eventLogHook
                         --1. add doF W.swpaUp make all pop up window in the front 
						 , manageHook = myManageHook <+> manageHook defaultConfig <+> insertPosition End Newer 
                            <+> namedScratchpadManageHook myScratchPads <+> doF W.swapUp 
                          }`additionalKeys` myKeys


myTerminal = "xterm"

projects :: [Project] ------------------------------------------------------------------diff workspace with diff apps to start up
projects =
  [ Project { projectName      = "FSL9"
            , projectDirectory = "~/Music"
            , projectStartHook = Just $ do runInTerm "-name cmus" "cmus"
                                           --spawn "netease-cloud-music"
                                           runInTerm "-name cava" "cava"
                                           runInTerm "-name cava" "cava"
            }
            { projectName      = "FSL8"
            , projectStartHook = Just $ do runInTerm "-name nload" "nload"
                                           runInTerm "-name htop" "htop"
                                           runInTerm "-name iotop" "sudo iotop"
                                           runInTerm "-name glances" "glances"
            }
  ]

-- app station
myManageHook = composeAll 
		[ className =? "netease-cloud-music"			--> viewShift "FSL9"
		, className =? "netease-cloud-music"			--> doF W.swapDown --wow it is amazing,it make windows down,and suit for workspace5,which make music in the middle,really really nice
		, className =? "mplayer"						--> doIgnore
   		, className =? "firefox" 						--> viewShift "FSL2" --open window and shift to window
   		--, className =? "firefox" 						--> doFloat
   		, className =? "firefox" 						--> doF W.swapUp
   		, className =? "Typora" 						--> viewShift "FSL3" 
   		, className =? "Typora" 						--> doFloat
   		, className =? "Thunar"    						--> doFloat
   		, className =? "VirtualBox" 					--> viewShift "FSL4" 
   		--, className =? "VirtualBox" 					--> doFloat
   		, className =? "VirtualBox"						--> doF W.swapUp
   		, manageDocks
   		]
	where viewShift = doF . liftM2 (.) W.greedyView W.shift


--  mylayout
myLayoutHook =  hiddenWindows
            $  maximizeWithPadding 0
            $  minimize 
            $  windowNavigation
            $  noFrillsDeco shrinkText topBarTheme
            $  addTabs shrinkText myTabTheme
            $  spacingWithEdge 10
			$  subLayout [0,1,2] (Simplest)
			$  onWorkspace "FSL8" (OneBig (3/4) (3/4))
			$  onWorkspace "FSL9" three
			$  onWorkspace "FSL6" simplestFloat
			-- $  toggleLayouts talldiff tallsame  ||| Grid ||| noBorders Full ||| three 
			$  toggleLayouts talldiff tallsame  ||| Grid ||| three 
tallsame	 = ResizableTall 1 (1/100) (1/2) []
talldiff	 = ResizableTall 1 (1/100) (2/3) [] 
three		 = ThreeColMid 1 (3/100) (1/2)



-------------------------------------------------------------------------------------------- key bending
myKeys =
    [ ((mod1Mask, xK_F2),spawn "amixer set Master 5%-")
    , ((mod1Mask, xK_F3), spawn "amixer set Master 5%+")
    , ((mod1Mask, xK_F4 ), spawn "xbacklight -dec 2")
    , ((mod1Mask, xK_F5), spawn "xbacklight -inc 2")
    , ((mod4Mask, xK_F6), spawn "xinput disable 14")
    , ((mod4Mask, xK_n  ), spawn "xterm")  --new terminal
    --, ((mod4Mask, xK_r  ), spawn "rofi -lines 4  -show drun -show-icons -theme android_notification.rasi -eh 2")  --show date usr dzen2
    , ((mod4Mask, xK_r  ), spawn "dmenu_run -fn 'WenQuanYi Micro Hei-12' -p '》'")  --show date usr dzen2
    , ((mod4Mask, xK_b), sendMessage ToggleStruts) --toggle status bar
-- navigate key
    -- redefine the default moveing key
    , ((mod4Mask, xK_j), sendMessage $ Go D)
    , ((mod4Mask, xK_k), sendMessage $ Go U)
    , ((mod4Mask, xK_l), sendMessage $ Go R)
    , ((mod4Mask, xK_h), sendMessage $ Go L)
    -- methords to find the key's name use:  xev | sed -ne '/^KeyPress/,/^$/p' then press the key
    -- the key used for sublayout which compressed
    , ((mod4Mask, xK_bracketleft), onGroup W.focusUp')
    , ((mod4Mask, xK_bracketright), onGroup W.focusDown')
    , ((mod4Mask .|. mod1Mask, xK_i  ), sendMessage MirrorShrink)  --vertical shrink window
    , ((mod4Mask .|. mod1Mask, xK_o  ), sendMessage MirrorExpand)  --vertical expand window
    , ((mod4Mask .|. mod1Mask, xK_h  ), sendMessage Shrink)
    , ((mod4Mask .|. mod1Mask, xK_l  ), sendMessage Expand)
    , ((mod4Mask .|. shiftMask, xK_m), windows W.swapMaster)  --move window to master
    , ((mod4Mask, xK_0), withFocused hideWindow) --hide window
    , ((mod4Mask, xK_g  ), withFocused toggleBorder)  --togger window border
    , ((mod4Mask, xK_f  ), withFocused (sendMessage . maximizeRestore))  --toggle full window
    , ((mod1Mask, xK_Tab  ), toggleWS)  --cycle workspace
    , ((mod4Mask, xK_t), sendMessage ToggleLayout)  --toggle window frame
    , ((mod4Mask, xK_BackSpace), kill)  --kill window
    , ((mod4Mask, xK_w), treeselectWorkspace myts myWorkspaces W.greedyView)  --sellect treeworkspace
    , ((mod4Mask, xK_p), spawn "flameshot full -p ~/Pictures/screenshot")  --fullscreen capture

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
       
       -- , ((0 , xK_period), onGroup W.focusUp')
       -- , ((0 , xK_comma), onGroup W.focusDown')
       ])
-- sub key \ ----------------------------------------------------------------------------- used for launch app
    , ((mod4Mask , xK_backslash), submap . M.fromList $
       [ ((0 , xK_v), spawn "obs --minimize-to-tray")  --start video record app
       , ((0 , xK_p), spawn "flameshot")  --start screen capture app
	   , ((0 , xK_s), spawn "rofi -show ssh -show-icons -theme lb.rasi -terminal xterm")  --launch ssh connect window
       , ((0 , xK_k), spawn "~/.local/bin/showkey") --toggle screenkey program on or off
       , ((0 , xK_r), spawn "pkill polybar; polybar -r -q queen >/dev/null 2>&1 &") --stop change desktop picture program 
       , ((0 , xK_m), spawn "amixer set Master toggle")  --toggle amixer mute
       , ((0 , xK_l), spawn "slock")  --lock screen
       --, ((0 , xK_t), spawn "translate \"`xclip -o`\" | xargs -0 notify-send && xclip -o | paste -s >> ~/Documents/books/remember_word.txt")  
       , ((0 , xK_t), spawn "translate \"`xclip -o`\"") -- faster translate 
       , ((0 , xK_f), AL.launchApp def "firefox")  --a prompt search for firefox
       , ((0 , xK_0), popOldestHiddenWindow) -- show hidden window
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
-- scratchpad
    , ((mod4Mask, xK_u), namedScratchpadAction myScratchPads "terminal" )
    , ((mod4Mask, xK_i), namedScratchpadAction myScratchPads "topTerm" )
    , ((mod4Mask, xK_o), namedScratchpadAction myScratchPads "thinTerm" )
    ]


--  mouse binding
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w)) --modekey+left move window
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w)) ] --modekey+right resize window


-------------------------------------------------------------------------------------------- scratch window
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "topTerm" spawnTerm1  findTerm1 manageTerm1
                , NS "thinTerm" spawnTerm2  findTerm2 manageTerm2
		        ]
	where
    spawnTerm = myTerminal ++  " -name terminal" 
    findTerm = resource =? "terminal"
    manageTerm = customFloating $ W.RationalRect l t w h 
		where
        h = 0.85 
        w = 0.9
        t = 0.07      -- top
        l = 0.05      -- left

    spawnTerm1 = myTerminal ++  " -name topterm"
    findTerm1 = resource =? "topterm"
    manageTerm1 = customFloating $ W.RationalRect l t w h 
		where
        h = 0.2     --hight
        w = 1.0     --width
        t = 0.02    --top 
        l = 0.0     -- left

    spawnTerm2 = myTerminal ++  " -name thinterm" 
    findTerm2 = resource =? "thinterm"
    manageTerm2 = customFloating $ W.RationalRect l t w h 
		where
        h = 0.04    --hight
        w = 0.70    --width
        t = 0.03    -- top
        l = 0.15    -- left



---workspace
myWorkspaces :: Forest String
myWorkspaces = [ Node "FSL1" [] 
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
                           , ts_background   = 0xdd1C2B40
                           , ts_font         = "xft:WenQuanYi Micro Hei-14"
                           , ts_node         = (0xff839496, 0xdd1C2B40)
                           , ts_nodealt      = (0xff839496, 0xdd1C2B40)
                           , ts_highlight    = (0xffFF9100, 0xdd1C2B40)
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


--  theme
-- topBarTheme = def
--      { activeColor = "#4f4e83"
--     , activeBorderColor = "#4f4e83"
--     , activeTextColor = "#4f4e83"
--     , inactiveColor = "#323353"
--     , inactiveBorderColor = "#323353"
--     , inactiveTextColor = "#323353"
--     , decoHeight = 4
--     , fontName =   "xft:iosevka-10"
--     }
-- myTabTheme = def
--     { activeColor           = "#4f4e83"
--     , inactiveColor         = "#323353"
--     , activeBorderColor     = "#4f4e83"
--     , inactiveBorderColor   = "#323353"
--     , activeTextColor       = "#4f4e83" 
--     , inactiveTextColor     = "#323353"
--      , decoHeight = 6
--      , fontName =   "xft:iosevka-10"
--      }

--  theme
topBarTheme = def
     { activeColor 	    = "#4e7397"
    , activeBorderColor     = "#4e7397"
    , activeTextColor	    = "#4e7397"
    , inactiveColor	    = "#3d5266"
    , inactiveBorderColor   = "#3d5266"
    , inactiveTextColor     = "#3d5266"
    , decoHeight 	    = 4
    , fontName		    =   "xft:iosevka-10"
    }
myTabTheme = def
    { activeColor           = "#4e7397"
    , inactiveColor         = "#3d5266"
    , activeBorderColor     = "#4e7397"
    , inactiveBorderColor   = "#3d5266"
    , activeTextColor       = "#4e7397" 
    , inactiveTextColor     = "#3d5266"
     , decoHeight	    = 4
     , fontName		    = "xft:iosevka-10"
     }

-- get polybar inifo
eventLogHook = do
  winset <- gets windowset
  title <- maybe (return "") (fmap show . getName) . W.peek $ winset
  let currWs = W.currentTag winset

  io $ appendFile "/tmp/.xmonad-title-log" (title ++ "\n")
  io $ appendFile "/tmp/.xmonad-workspace-log" (currWs ++ "\n")

