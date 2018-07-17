{-#
OPTIONS_GHC -fno-warn-missing-signatures
#-}
--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import System.Exit
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Actions.WindowGo (raiseMaybe)
import XMonad.Actions.WindowBringer (gotoMenuArgs)
import XMonad.Actions.SpawnOn
import XMonad.Layout.Simplest
import XMonad.Layout.OneBig
import XMonad.Layout.Grid
import XMonad.Layout.Reflect
import XMonad.Layout.Spacing (smartSpacing)
import qualified XMonad.Actions.CycleWS as CW
import Graphics.X11.ExtraTypes.XF86
import Control.Concurrent (threadDelay)

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Data.List as L

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal = "termite"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = True

-- Width of the window border in pixels.
--
myBorderWidth = 2

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask = mod4Mask


myVimCommand = "/bin/zsh -c '/usr/bin/gvim -f'"

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces :: [WorkspaceId]
myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#e05050"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run -i -fn 'Monospace-18' -o '0.9' -nb '#202020' -nf '#e0e0e0' ")

    -- launch gVim
    , ((modm,               xK_v     ), spawn myVimCommand)

    -- launch browser
    , ((modm,               xK_f     ), spawnOn "2" "firefox")

    -- launch browser
    , ((modm,               xK_Escape ), spawn "light-locker-command -l")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- backlight brightness up
    , ((0, xF86XK_MonBrightnessUp), spawn "xbacklight -inc 7")

    -- backlight brightness down
    , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -dec 6")

    -- sound volume up
    , ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 0.5dB-")

    -- sound volume down
    , ((0, xF86XK_AudioRaiseVolume), spawn "amixer set Master 0.5dB+")

    -- sound volume down
    , ((0, xF86XK_AudioMute), spawn "amixer set Master toggle")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)
    , ((modm              , xK_w     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)
    , ((modm,            xK_semicolon), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Window Briger!
    , ((modm              , xK_i     ), gotoMenuArgs ["-i", "-l", "10", "-fn", "Nasu-18", "-o", "'0.9'", "-nb", "#e0e0e0", "-nf", "#202020"])

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    , ((modm .|. shiftMask, xK_q     ), rescreen)

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    --, ((modMask .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (workspaces conf) [xK_1 .. xK_9]
        -- , (f, m) <- [(viewOnScreen 0, 0), (\n -> W.view n . shiftOn 0 n, shiftMask)]]
        , (f, m) <- [(viewOnScreen 0, 0), (shiftAndViewOnScreen 0, shiftMask)]]
    ++


    [((modm, xK_Tab), CW.nextScreen)
    ,((modm .|. shiftMask, xK_Tab), CW.shiftNextScreen >> CW.nextScreen)
    ]

-- Similar to XMonad.Actions.OnScreen but more flexible and easier.
onScreen :: (Eq sid, Eq i) => (i -> W.StackSet i l a sid sd -> W.StackSet i l a sid sd) -> sid -> i -> W.StackSet i l a sid sd -> W.StackSet i l a sid sd
onScreen f sid wid ss
    | Just scrn <- L.find ((sid==) . W.screen) (W.screens ss)
        = let newwid = W.tag . W.workspace $ scrn
          in
          f wid $ W.view newwid $ ss
    | otherwise = ss

viewOnScreen :: (Eq sid, Eq i) => sid -> i -> W.StackSet i l a sid sd -> W.StackSet i l a sid sd
viewOnScreen = onScreen W.view

shiftOnScreen :: (Ord a, Eq sid, Eq i) => sid -> i -> W.StackSet i l a sid sd -> W.StackSet i l a sid sd
shiftOnScreen sid wid ss = maybe ss (\w -> onScreen (flip W.shiftWin w) sid wid ss) (W.peek ss)

shiftAndViewOnScreen :: (Ord a, Eq sid, Eq i) => sid -> i -> W.StackSet i l a sid sd -> W.StackSet i l a sid sd
shiftAndViewOnScreen sid wid = viewOnScreen sid wid . shiftOnScreen sid wid

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts $ smartSpacing 5 (Mirror (reflectVert (OneBig 0.8 0.8))) ||| Simplest ||| smartSpacing 5 (GridRatio 1.5) ||| smartSpacing 5 (Mirror (Tall 1 (3/100)  (1/2)))

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = defaultFloatings <+> manageDocks <+> manageSpawn
  where
    defaultFloatings = composeAll
        [ title =? "Firefox Preferences" --> doFloat,
          className =? "feh" --> doFloat
        ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
    setWMName "LG3D"
    io $ threadDelay $ 2000*1000
    spawn $ "pkill trayer; " ++ trayerCommand
    spawn "nitrogen --restore"
    -- raiseMaybe (spawnOn "2" "firefox") (className =? "Firefox")
    raiseMaybe (spawnOn "1" $ XMonad.terminal defaults) (className =? "Termite")
        where
            -- NOTE: trayer-srg is used for multi monitor support instead of trayer
            trayerCommand = "trayer --edge top --align right --SetDockType true --SetPartialStrut false --expand true --width 10 --transparent true --tint 0x000000 --height 28 --alpha 0 --monitor primary"



------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
main = do
    x <- statusBar myBar myPP toggleStrutsKey $ defaults
    xmonad x

-- Command to launch the bar.
myBar = "xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP = xmobarPP {
    ppCurrent = xmobarColor "#000000" "#BCBC52" . wrap "[" "]",
    ppVisible = xmobarColor "#101010" "#808038" . wrap "[" "]",
    ppHidden = xmobarColor "#808080" "#505050" . wrap " " " ",
    ppTitle = xmobarColor "#20F0C0" "" . shorten 150
}

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modmask} = (modmask, xK_b)

defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }
