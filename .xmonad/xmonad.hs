import XMonad hiding ( (|||) )
import Data.Monoid
import System.Exit
-- To cycle forward/backward through list of workspaces/screens.
import XMonad.Actions.CycleWS

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- Needed for bindings to the numpad.
import XMonad.Util.EZConfig

import XMonad.Layout.LayoutCombinators
import XMonad.Layout.MultiToggle

import XMonad.Layout.StackTile
import XMonad.Layout.Tabbed
import XMonad.Layout.Reflect
import XMonad.Layout.Magnifier hiding (Toggle)
import XMonad.Layout.Renamed
import XMonad.Layout.Grid

-- For smartBorders.
import XMonad.Layout.NoBorders

terminal' = "xterm"

myFocusFollowsMouse :: Bool
-- Whether focus follows the mouse pointer.
myFocusFollowsMouse = False

-- Width of the window border in pixels.
myBorderWidth = 2

-- The modMask to use (mod4Mask is the Tux/Super key). Note: mod1key equals modm.
mod1key = mod4Mask 
-- The key to be used in combination with the modMask.
mod2 = shiftMask
-- Used for key sequences.
mod3 = controlMask

myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

-- Border color for unfocused window(s).
myNormalBorderColor  = "#0A0A0A"
-- Border color for focused window.
myFocusedBorderColor = "#2973bc"

--------------------------------------
------------ KEY BINDINGS ------------
--------------------------------------
keys' conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- Launch a (default) terminal.
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf)

    -- Close focused window.
    , ((modm .|. mod2,    xK_Return), kill)
    
    -- Rotate through the available layout algorithms.
    , ((modm,             xK_space ), sendMessage NextLayout)
    -- Jump directly to a layout algorithm.
    , ((modm,             xK_F5    ), sendMessage $ JumpToLayout "Layout1")
    , ((modm,             xK_F6    ), sendMessage $ JumpToLayout "Layout2")
    , ((modm,             xK_F7    ), sendMessage $ JumpToLayout "Layout3")
    , ((modm,             xK_F8    ), sendMessage $ JumpToLayout "Layout4")
    , ((modm,             xK_F9    ), sendMessage $ JumpToLayout "Layout5")
    , ((modm,             xK_F10   ), sendMessage $ JumpToLayout "Layout6")
    , ((modm .|. mod2,    xK_a     ), spawn "audacious")
    -- Reset the layouts on the current workspace to default.
    , ((modm .|. mod2,    xK_space ), setLayout $ XMonad.layoutHook conf)
    -- Move focus to the next window.
    , ((modm,             xK_k     ), windows W.focusDown)
    -- Move focus to the previous window.
    , ((modm,             xK_j     ), windows W.focusUp)
    -- Move focus to the master window.
    , ((modm .|. mod2,    xK_Tab   ), windows W.focusMaster)
    -- Swap the focused window and the master window.
    , ((modm,             xK_Tab), windows W.swapMaster)
    -- Swap the focused window with the next window.
    , ((modm,             xK_q     ), windows W.swapDown)
    -- Swap the focused window with the previous window.
    , ((modm,             xK_a     ), windows W.swapUp)
    -- Expand the master area.
    , ((modm,             xK_w     ), sendMessage Expand)
    -- Shrink the master area.
    , ((modm,             xK_s     ), sendMessage Shrink)
    -- Push window back into tiling.
    , ((modm,             xK_BackSpace), withFocused $ windows . W.sink)
    -- Increment the number of windows in the master area.
    , ((modm,             xK_e     ), sendMessage (IncMasterN 1))
    -- Decrement the number of windows in the master area.
    , ((modm,             xK_d     ), sendMessage (IncMasterN (-1)))

    -- Move focus to the left screen.
    , ((modm,             xK_h     ), prevScreen)
    -- Move focus to the right screen.
    , ((modm,             xK_l     ), nextScreen)

    -- Quit xmonad.
    , ((modm .|. mod2,    xK_Escape), io (exitWith ExitSuccess))
    -- Restart xmonad.
    , ((modm,             xK_End   ), spawn "xmonad --recompile; xmonad --restart")

    -- Start programs.
    -- Uses mod1-shift, while keySeqs uses mod1-ctrl.
    , ((modm .|. mod2,    xK_a     ), spawn "audacious")
    , ((modm .|. mod2,    xK_b     ), spawn "chromium")
    , ((modm .|. mod2,    xK_c     ), spawn (terminal'++" calc"))
    , ((modm .|. mod2,    xK_d     ), spawn "dbeaver")
    , ((modm .|. mod2,    xK_e     ), spawn "gedit")
    , ((modm .|. mod2,    xK_f     ), spawn "filezilla")
    , ((modm .|. mod2,    xK_g     ), spawn "gimp")
    , ((modm .|. mod2,    xK_h     ), spawn (terminal'++" hexedit"))
    , ((modm .|. mod2,    xK_l     ), spawn "libreoffice")
    , ((modm .|. mod2,    xK_m     ), spawn "mirage")
    , ((modm .|. mod2,    xK_n     ), spawn "nautilus")
    , ((modm .|. mod2,    xK_o     ), spawn "code")
    , ((modm .|. mod2,    xK_p     ), spawn "evince")
    , ((modm .|. mod2,    xK_r     ), spawn "postman")
    , ((modm .|. mod2,    xK_s     ), spawn "spotify")
    , ((modm .|. mod2,    xK_t     ), spawn "qbittorrent")
    , ((modm .|. mod2,    xK_v     ), spawn "vlc")
    , ((modm .|. mod2,    xK_w     ), spawn (terminal'++" wicd-curses"))
    , ((modm .|. mod2,    xK_x     ), spawn (terminal'++" alsamixer"))

    -- Volume settings.
    , ((modm,             xK_KP_Add), spawn "amixer set Master 2dB+")
    , ((modm,             xK_KP_Subtract), spawn "amixer set Master 2dB-")

    ]
    ++

    -- mod-[1..10(0)]:       switch to workspace.
    -- mod-shift-[1..10(0)]: move client to workspace n.
    [((m .|. modm, k), windows $ f i)
         | (i, k) <- zip myWorkspaces ([xK_1 .. xK_9] ++ [xK_0])
         , (f, m) <- [(W.greedyView, 0), (W.shift, mod2)]]
    ++
    -- mod-NUMPAD[1..10(0)]:       switch to workspace n.
    -- mod-shift-NUMPAD[1..10(0)]: move client to workspace n.
    [((m .|. modm, k), windows $ f i)
         | (i, k) <- zip myWorkspaces numpadKeys
         , (f, m)   <- [(W.greedyView, 0), (W.shift, mod2)]]
    ++

    -- mod-{F1,F2,F3}:       switch to physical/Xinerama screens 1, 2, or 3.
    -- mod-shift-{F1,F2,F3}: move client to screen 1, 2, or 3.
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
         | (key, sc) <- zip [xK_F1, xK_F2, xK_F3] [0..]
         , (f, m) <- [(W.view, 0), (W.shift, mod2)]]

-- Key sequences: Emacs-style specifications.
-- All these key sequences start with mod1-ctrl.
keySeqs = 
    [
     -- Terminals (t)
     (("M-C-t a"), spawn "aterm"),
     (("M-C-t e"), spawn "Eterm"),
     (("M-C-t g"), spawn "gnome-terminal"),
     (("M-C-t u"), spawn "urxvt"),
     (("M-C-t x"), spawn "xterm"),
     -- Shells    (s)
     -- Note: these calls only seem to work with XTerm.
     (("M-C-s b"), spawn (terminal'++" bash")),
     (("M-C-s c"), spawn (terminal'++" csh")),
     (("M-C-s k"), spawn (terminal'++" ksh")),
     (("M-C-s t"), spawn (terminal'++" tcsh")),
     (("M-C-s z"), spawn (terminal'++" zsh")),
     -- Editors   (e)
     (("M-C-e v"), spawn (terminal'++" vim")),
     (("M-C-e g"), spawn "gvim"),
     (("M-C-e l"), spawn "lyx"),
     -- Network   (n)
     (("M-C-n s"), spawn (terminal'++" netstat"))
    ]

-- Non-numeric numpad keys, sorted by number.
numpadKeys =
    [ xK_KP_End,  xK_KP_Down,  xK_KP_Page_Down, -- 1,2,3
      xK_KP_Left, xK_KP_Begin, xK_KP_Right,     -- 4,5,6
      xK_KP_Home, xK_KP_Up,    xK_KP_Page_Up,   -- 7,8,9
      xK_KP_Insert ]                            -- 0

mouseBindings' (XConfig {XMonad.modMask = modm}) = M.fromList $
    -- Set the window to floating mode and move by dragging.
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    -- Raise the window to the top of the stack.
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    -- Set the window to floating mode and resize by dragging.
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    ]

layout' =
    smartBorders $
               named "Layout1"            (Tall 1 (3/100) (60/100))
           ||| named "Layout2"            (Tall 2 (3/100) (50/100))
           ||| named "Layout3" (Mirror    (Tall 2 (3/100) (50/100)))
           ||| named "Layout4" (magnifier (Tall 1 (3/100) (50/100)))
           -- ||| named "Layout5" (tabbed shrinkText defaultTheme)
           ||| named "Layout5" Full
           ||| named "Layout6" Grid

-- Window rules.
manageHook' = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

-- Event handling.
eventHook' = mempty

-- Status bar and logging.
logHook' = return ()

-- Startup hook: perform an arbitrary action each time xmonad starts or is restarted.
startupHook' = return ()

-- Run xmonad with the settings specified.
main = xmonad defaults

-- Structure containing the configuration settings, overriding fields in
-- the default config. Any settings not overridden will use the defaults
-- defined in xmonad/XMonad/Config.hs.
defaults = def {
        terminal           = terminal',
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = mod1key,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

        -- Key bindings.
        keys               = keys',
        mouseBindings      = mouseBindings',

        -- Hooks and layouts.
        layoutHook         = layout',
        manageHook         = manageHook',
        handleEventHook    = eventHook',
        logHook            = logHook',
        startupHook        = startupHook'
    }
    `additionalKeysP`
    keySeqs
