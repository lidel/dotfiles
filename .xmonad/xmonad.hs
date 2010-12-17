-- Xmonad config file (0.8-0.9)
-- by Marcin Rataj (http://lidel.org)
-- Updates: http://github.com/lidel/dotfiles/
-- License: public domain
-- vim: ts=8 et sw=8
-- xmonad zen: Normally, you'd only override those defaults you care about.

import XMonad
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import IO
import XMonad.Util.Run (spawnPipe, safeSpawn)

import XMonad.Util.EZConfig

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Actions.UpdatePointer
import XMonad.Actions.CycleWS

-- resize windows y with mod+a / mod+z
import qualified XMonad.Actions.FlexibleResize as Flex

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageHelpers
-- import XMonad.Actions.CopyWindow


import XMonad.Util.Themes
import XMonad.Layout.Tabbed
import XMonad.Layout.Maximize
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile

-- for LibNotifyUrgencyHook
import XMonad.Util.NamedWindows (getName)


-- remove when upgraded to darcs (0.9)
-- import Data.List
-- xmobarStrip :: String -> String
-- xmobarStrip = strip [] where
--    strip keep x
--      | null x                 = keep
--      | "<fc="  `isPrefixOf` x = strip keep (drop 1 . dropWhile (/= '>') $ x)
--      | "</fc>" `isPrefixOf` x = strip keep (drop 5  x)
--      | '<' == head x          = strip (keep ++ "<") (tail x)
--      | otherwise              = let (good,x') = span (/= '<') x
--                                 in strip (keep ++ good) x'

------------------------------------------------------------------------
myTerminal      = "urxvtc_wrapper"
myBorderWidth   = 1
myModMask       = mod4Mask
myNumlockMask   = 0
myWorkspaces    = ["main","web"] ++ map show [3..8] ++ ["dl"]

myNormalBorderColor  = "#111111"
myFocusedBorderColor = "#333333"
-- myFocusedBorderColor = "#303030"

------------------------------------------------------------------------
lidelDarkTheme :: Theme
lidelDarkTheme = defaultTheme { inactiveBorderColor = "#101010"
                              , inactiveColor = "#101010"
                              , inactiveTextColor = "#808080"
                              , activeBorderColor = "#222"
                              , activeColor = "#222"
                              , activeTextColor = "#aaa"
                              , fontName = "-*-terminus-medium-r-*-*-12-*-*-*-*-*-iso10646-*"
                              , decoHeight = 10
                              , urgentColor = "#A36666"
                              , urgentTextColor = "#000"
                              }
------------------------------------------------------------------------

myLayout = maximize (tiled ||| Mirror tiled ||| tabbed shrinkText lidelDarkTheme )
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = ResizableTall nmaster delta ratio []
     -- The default number of windsws in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
myAdditionalManageHook = composeOne $
    [ transience ]
    ++
    [ className =? c                -?> doIgnore | c <- ignoreC ]
    ++
    [ className =? c                -?> doFloat | c <- floatC ]
    ++
    [ className =? c                -?> doCenterFloat | c <- centerFloatC ]
    -- ++
    --[ resource  =? r                -?> doCenterFloat | r <- centerFloatR ]
    ++
    [ className =? "Firefox" <&&> resource =? r -?> doCenterFloat
      | r <- floatFF ]
    ++
    -- auto shift
    [ className =? c         -?> doShift t
      | (c, t) <- [ ("Firefox", "web")
                  , ("Minefield", "web")
                  , ("VirtualBox", "7")
                  , ("Eclipse", "5")
                  ]
    ]
    where
      unFloat = ask >>= doF . W.sink
      -- define application handling exceptions here
      floatC  = [ "psi", "Gimp", "Vncviewer", "Qt-dotnet.dll", "Skype", "Wine", "Pidgin"
                     , "Intensity_CClient", "Gnome-mplayer", "Gimp-2.6" ]
      centerFloatC = [ "Gcolor2", "Sonata", "Galculator", "Pinentry", "Qtconfig"
                     , "Switch2", "Lxappearance", "Geeqie", "Wicd-client.py"
                     , "Xarchiver", ".", "Gqview", "Pystopwatch", "Blueman-manager" ]
      ignoreC = [ "Do", "trayer" ]
      floatFF = [ "DTA", "Manager", "Extension", "Download", "Dialog", "Browser", "Toplevel" ]

myManageHook = manageDocks
               <+> myAdditionalManageHook
               <+> composeAll [(isFullscreen --> doFullFloat)]
               <+> manageHook defaultConfig
------------------------------------------------------------------------
-- Not needing a mouse doesn't mean not using it ;-)
button8     =  8 :: Button
button9     =  9 :: Button

------------------------------------------------------------------------
myTrayer = "killall trayer ; exec trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 5 --transparent true --alpha 0 --tint 0x000000 --height 16"
------------------------------------------------------------------------
data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)
-- simple notify when window requires attention
instance UrgencyHook LibNotifyUrgencyHook where
    urgencyHook LibNotifyUrgencyHook w = do
        name <- getName w
        ws <- gets windowset
        whenJust (W.findTag w ws) (flash name)
        where flash name index = spawn "notify-send URGENCY"
        --(show name ++ " requests your attention on workspace " ++ index)
------------------------------------------------------------------------
main = do
        xmproc <- spawnPipe "xmobar"
        spawn myTrayer
        xmonad $ withUrgencyHook LibNotifyUrgencyHook defaultConfig {

      -- basic bindings
        terminal           = myTerminal,
        focusFollowsMouse  = True,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        numlockMask        = myNumlockMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- hooks, layouts
        layoutHook         = avoidStruts $ smartBorders $ myLayout,
        manageHook         = myManageHook,
        logHook            = ewmhDesktopsLogHook >> (
                             dynamicLogWithPP $ defaultPP {
                                                ppTitle     = xmobarColor "#a0a0a0" "" . shorten 100,
                                                ppCurrent   = xmobarColor "#29B5B5" "", -- . wrap "" "",
                                                ppUrgent    = xmobarColor "#000000" "#BF2020" . xmobarStrip,
                                                ppSep       = xmobarColor "#404040" "" " : ",
                                                ppOutput    = hPutStrLn xmproc,
                                                ppLayout    = xmobarColor "#606060" "" .
                                                      (\ x -> case x of
                                                          "Maximize ResizableTall"            -> "[]="
                                                          "Maximize Mirror ResizableTall"     -> "TTT"
                                                          "Maximize Tabbed Simplest"          -> "Tab"
                                                          _                         -> pad x)
                                                }) >> updatePointer Nearest,
        startupHook        = setWMName "LG3D" -- fix for all apps that get american psycho with tilled WM
    }
                 `additionalKeys`
                 [ ((myModMask,xK_Left),              moveTo Prev NonEmptyWS)   -- prev used workspace
                 , ((myModMask.|.shiftMask,xK_Left),  shiftTo Prev NonEmptyWS)  -- prev used workspace
                 , ((myModMask,xK_Right),             moveTo Next NonEmptyWS)   -- next used workspace
                 , ((myModMask.|.shiftMask,xK_Right), shiftTo Next NonEmptyWS)  -- next used workspace
                 , ((myModMask,xK_0),                 moveTo Next EmptyWS)      -- find a free workspace
                 , ((0,0x1008ff1b),                   moveTo Next EmptyWS)      -- XF86Search - find a free workspace
                 , ((myModMask.|.shiftMask,xK_0),     shiftTo Next EmptyWS)     -- move to a free workspace
                 , ((myModMask,xK_m), withFocused (sendMessage . maximizeRestore))
                 , ((myModMask, xK_z), sendMessage MirrorShrink)
                 , ((myModMask, xK_a), sendMessage MirrorExpand)
                 ]
                 `additionalMouseBindings`
                 [ ((myModMask, button3), (\w -> focus w >> Flex.mouseResizeWindow w)) -- pretty resize
                 , ((myModMask, button1), (\w -> focus w >> mouseMoveWindow w)) -- fix bug with master (http://code.google.com/p/xmonad/issues/detail?id=241)
                 , ((0, button8), (\w -> moveTo Prev NonEmptyWS)) -- my mouse has 2 arrows under thumb
                 , ((0, button9), (\w -> moveTo Next NonEmptyWS)) -- i use them for 'next/prev active workspace'
                 ]

