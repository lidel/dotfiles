-- Xmonad config file (0.9)
-- by Marcin Rataj (http://lidel.org)
-- Updates: http://github.com/lidel/dotfiles/
-- License: public domain / CC0
-- vim: ts=8 et sw=8
-- xmonad zen: Normally, you'd only override those defaults you care about.

import XMonad
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import IO
import XMonad.Util.Run (spawnPipe, safeSpawn)
import XMonad.Util.EZConfig
import XMonad.Util.Themes
import XMonad.Util.NamedWindows (getName) -- for LibNotifyUrgencyHook

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.WorkspaceByPos
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook

import XMonad.Actions.UpdatePointer
import XMonad.Actions.CycleWS
import qualified XMonad.Actions.FlexibleResize as Flex -- resize windows y with mod+a / mod+z

import XMonad.Layout.Tabbed
import XMonad.Layout.Maximize
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.ThreeColumns

------------------------------------------------------------------------
myBorderWidth   = 1
myModMask       = mod4Mask
myWorkspaces    = ["main","web"] ++ map show [3..8] ++ ["dl"]

myFontName = "-*-terminus-medium-r-*-*-12-*-*-*-*-*-iso10646-*"

myInactiveBorderColor   = "#111111"
myActiveBorderColor     = "#333333"

myInactiveTextColor     = "#a0a0a0"
myInactiveColor         = "#000000"

myActiveTextColor       = "#29B5B5"
myActiveColor           = "#000000"

myUrgentTextColor       = "#000000"
myUrgentColor           = "#BF2020"

myDecoTextColor         = "#444444"
myDecoChar              = " : "
myEmptyColor            = ""

------------------------------------------------------------------------
lidelDarkTheme :: Theme
lidelDarkTheme = defaultTheme { inactiveBorderColor = myInactiveBorderColor
                              , inactiveColor       = myInactiveColor
                              , inactiveTextColor   = myInactiveTextColor
                              , activeBorderColor   = myActiveBorderColor
                              , activeColor         = myActiveBorderColor
                              , activeTextColor     = myInactiveTextColor
                              , fontName            = myFontName
                              , decoHeight          = 10
                              , urgentColor         = myUrgentColor
                              , urgentTextColor     = myUrgentTextColor
                              }
------------------------------------------------------------------------

myLayout = maximize (tiled ||| tiled3 ||| tabbedBottom shrinkText lidelDarkTheme )
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = ResizableTall nmaster delta goldenRatio []
     tiled3  = ThreeCol nmaster delta ratio3
     -- The default number of windsws in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     goldenRatio = toRational $ 2/(1 + sqrt 5 :: Double)
     ratio3  = -1/3
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
    [ className =? "Firefox" <&&> resource =? r -?> doCenterFloat | r <- floatFF ]
    ++
    [ className =? "Minefield" <&&> resource =? r -?> doCenterFloat | r <- floatFF ]
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
      floatC  = [ "psi", "Vncviewer", "Qt-dotnet.dll", "Skype", "Wine", "Pidgin"
                     , "Intensity_CClient", "Psi", "Kadu", "mplayer2" ]
      centerFloatC = [ "Gcolor2", "Sonata", "Galculator", "Pinentry", "Qtconfig", "glxgears"
                     , "Switch2", "Lxappearance", "Geeqie", "Wicd-client.py"
                     , "Xarchiver", ".", "Gqview", "Pystopwatch", "Blueman-manager" ]
      ignoreC = [ "Do", "trayer", "ioUrbanTerror.x86_64", "Xfce4-notifyd" ]
      floatFF = [ "DTA", "Manager", "Extension", "Download", "Dialog", "Browser", "Toplevel", "Places" ]

myManageHook = manageDocks
               <+> myAdditionalManageHook
               <+> workspaceByPos
               <+> composeAll [(isFullscreen --> doFullFloat)]
               <+> manageHook defaultConfig
------------------------------------------------------------------------
-- Not needing a mouse doesn't mean not using it ;-)
button8     =  8 :: Button
button9     =  9 :: Button
------------------------------------------------------------------------
myTerminal      = "urxvtc-wrapper.sh"
myTrayer        = "killall trayer ; exec trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --widthtype request --transparent true --alpha 0 --tint 0x0000000 --heighttype pixel --height 16 --distance 0"
myDmenuRun      = "exe=`dmenu_run -nb '" ++ myInactiveColor ++ "' -nf '" ++ myInactiveTextColor ++ "' -sb '" ++ myActiveColor  ++ "' -sf '" ++ myActiveTextColor ++ "' -fn '" ++ myFontName ++ "'` && eval \"exec $exe\""
------------------------------------------------------------------------
data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)
-- simple notify when window requires attention
instance UrgencyHook LibNotifyUrgencyHook where
    urgencyHook LibNotifyUrgencyHook w = do
        name <- getName w
        ws <- gets windowset
        whenJust (W.findTag w ws) (flash name)
      where flash name index =
                safeSpawn "notify-send" ["-i", "gtk-dialog-info", show name ++ " requests your attention on workspace " ++ index]

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
        workspaces         = myWorkspaces,
        normalBorderColor  = myInactiveBorderColor,
        focusedBorderColor = myActiveBorderColor,

      -- hooks, layouts
        layoutHook         = avoidStruts $ smartBorders $ myLayout,
        manageHook         = myManageHook,
        logHook            = ewmhDesktopsLogHook >> (
                             dynamicLogWithPP $ defaultPP {
                                                ppTitle     = xmobarColor myInactiveTextColor myEmptyColor . shorten 100,
                                                ppCurrent   = xmobarColor myActiveTextColor myEmptyColor, -- . wrap "" "",
                                                ppUrgent    = xmobarColor myUrgentTextColor myUrgentColor . xmobarStrip,
                                                ppSep       = xmobarColor myDecoTextColor myEmptyColor myDecoChar,
                                                ppOutput    = hPutStrLn xmproc,
                                                ppLayout    = xmobarColor myDecoTextColor myEmptyColor .
                                                      (\ x -> case x of
                                                          "Maximize ResizableTall"            -> "[]="
                                                          "Maximize ThreeCol"                 -> "T3="
                                                          "Maximize Tabbed Bottom Simplest"   -> "Tab"
                                                          _                         -> pad x)
                                                }) >> updatePointer Nearest,
        startupHook        = setWMName "LG3D" -- fix for all apps that get american psycho with tilled WM
    }
                 `additionalKeys`
                 [ ((myModMask,xK_Left),              moveTo Prev HiddenNonEmptyWS)   -- prev used workspace
                 , ((myModMask.|.shiftMask,xK_Left),  shiftTo Prev HiddenNonEmptyWS)  -- prev used workspace
                 , ((myModMask,xK_Right),             moveTo Next HiddenNonEmptyWS)   -- next used workspace
                 , ((myModMask.|.shiftMask,xK_Right), shiftTo Next HiddenNonEmptyWS)  -- next used workspace
                 , ((myModMask,xK_0),                 moveTo Next EmptyWS)      -- find a free workspace
                 , ((myModMask.|.shiftMask,xK_0),     shiftTo Next EmptyWS)     -- move to a free workspace
                 , ((myModMask,xK_m), withFocused (sendMessage . maximizeRestore))
                 , ((myModMask, xK_z), sendMessage MirrorShrink)
                 , ((myModMask, xK_a), sendMessage MirrorExpand)
                 -- base
                 , ((myModMask, xK_p), spawn myDmenuRun)        -- run prompt
                 , ((myModMask, xK_grave), spawn myTerminal)    -- terminal
                 , ((myModMask, xK_f), spawn "thunar")          -- file manager
                 , ((myModMask, xK_v), spawn "pavucontrol")     -- sound manager
                 , ((myModMask, xK_Print), spawn "sleep 0.2 ; scrot")       -- print-screen
                 , ((myModMask, xK_Escape), spawn "xscreensaver-command -lock") -- lock screen
                 , ((myModMask.|.shiftMask, xK_Escape), spawn "vaio-s2ram.sh ; xscreensaver-command -lock") -- suspend + lock
                 -- mpd
                 , ((myModMask, 0x1008ff11), spawn "mpc prev")      -- XF86AudioLowerVolume
                 , ((myModMask, 0x1008ff13), spawn "mpc next")      -- XF86AudioRaiseVolume
                 , ((myModMask, 0x1008ff12), spawn "mpc toggle")    -- XF86AudioMute
                 -- volume
                 , ((0, 0x1008ff11), spawn "pa-volume-ctl.sh down") -- XF86AudioLowerVolume
                 , ((0, 0x1008ff13), spawn "pa-volume-ctl.sh up")   -- XF86AudioRaiseVolume
                 , ((0, 0x1008ff12), spawn "pa-volume-ctl.sh mute") -- XF86AudioMute
                 -- keys for my current notebook
                 , ((0, 0x1008ff14), spawn "mpc toggle")    -- XF86AudioPlay
                 , ((0, 0x1008ff15), spawn "mpc stop")      -- XF86AudioStop
                 , ((0, 0x1008ff16), spawn "mpc prev")      -- XF86AudioPrev
                 , ((0, 0x1008ff17), spawn "mpc next")      -- XF86AudioNext
                 , ((0, 0x1008ff41), spawn "xscreensaver-command -lock")    -- lock screen vaio key (XF86Launch1)
                 , ((0, 0x1008ff02), spawn "vaio-fw21e-backlight2.sh up")   -- XF86MonBrightnessUp
                 , ((0, 0x1008ff03), spawn "vaio-fw21e-backlight2.sh down") -- XF86MonBrightnessDown
                 ]
                 `additionalMouseBindings`
                 [ ((myModMask, button3), (\w -> focus w >> Flex.mouseResizeWindow w)) -- pretty resize
                 , ((myModMask, button1), (\w -> focus w >> mouseMoveWindow w)) -- fix bug with master (http://code.google.com/p/xmonad/issues/detail?id=241)
                 , ((0, button8), (\w -> moveTo Prev HiddenNonEmptyWS)) -- my mouse has 2 arrows under thumb
                 , ((0, button9), (\w -> moveTo Next HiddenNonEmptyWS)) -- i use them for 'next/prev active workspace'
                 , ((myModMask, button2), (\w -> moveTo Next EmptyWS)) -- find a free workspace
                 ]

