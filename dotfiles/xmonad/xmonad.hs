import Control.Monad (when)
import Data.Foldable (traverse_)
import System.Exit (exitSuccess)
import System.IO
import XMonad
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.SpawnOn
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Layout.NoBorders
import qualified XMonad.StackSet as W
import XMonad.Util.Run
import XMonad.Util.EZConfig (additionalKeysP)

main = do
    xmobarHandles <- xmobarOnScreens screens
    xmonad $ def
        -- Leave space for the status bar
        { manageHook = manageSpawn <+> manageDocks <+> manageHook def
        , layoutHook = lessBorders OnlyFloat $ avoidStruts $ layoutHook def
        , handleEventHook = docksEventHook <+> fullscreenEventHook <+> handleEventHook def
        , startupHook = myStartupHook <+> docksStartupHook <+> startupHook def
        -- Rebind Mod to the Windows key
        , modMask = mod4Mask
        -- Send info to xmobar
        , logHook = dynamicLogWithPP xmobarPP
            { ppOutput = multiHPutStrLn xmobarHandles
            , ppTitle = xmobarColor "green" "" . shorten 50
            }
        , workspaces = myWorkspaces
        } `additionalKeysP` myKeys

{%@@ if profile == "home-desktop" @@%}
screens = [0, 1]
{%@@ else @@%}
screens = [0]
{%@@ endif @@%}

xmobarOnScreens = traverse spawnXmobarOnScreen
  where
    spawnXmobarOnScreen sc = spawnPipe $ "xmobar -x " ++ show sc ++ " /home/riccardo/.xmonad/xmobar"

multiHPutStrLn hs msg = traverse_ (\h -> hPutStrLn h msg) hs

myStartupHook = do
{%@@ if profile == "home-desktop" @@%}
    windows $ W.view "1" -- Focus workspace 1 (instead of 2, because of screen order)
    spawnOn mailWorkspace "thunderbird"
{%@@ else @@%}
    pure ()
{%@@ endif @@%}

myWorkspaces =
{%@@ if profile == "home-desktop" @@%}
    fmap show [1..8] ++ [mailWorkspace]
{%@@ else @@%}
    fmap show [1..9]
{%@@ endif @@%}

{%@@ if profile == "home-desktop" @@%}
mailWorkspace = "9.Mail"
{%@@ endif @@%}

myKeys = workspaceKeys ++ screenKeys ++
    [ ("M-o", spawn "chromium")
    , ("M-S-o", spawn "chromium --incognito")
    , ("M-i", spawn "emacsclient -a '' -nqc")
    , ("M-S-q", promptQuit) -- Ask for confirmation before quitting
{%@@ if profile == "home-desktop" @@%}
    -- Media keys
    , ("<XF86AudioRaiseVolume>", spawn "volume set-sink-volume @DEFAULT_SINK@ +5%")
    , ("<XF86AudioLowerVolume>", spawn "volume set-sink-volume @DEFAULT_SINK@ -5%")
    , ("<XF86AudioMute>", spawn "volume set-sink-mute @DEFAULT_SINK@ toggle")
    , ("<XF86AudioPlay>", spawn "playerctl play-pause")
    , ("<XF86AudioStop>", spawn "playerctl stop")
    , ("<XF86AudioNext>", spawn "playerctl next")
    , ("<XF86AudioPrev>", spawn "playerctl previous")
{%@@ else @@%}
    , ("M-b", spawn "toggle-touchpad")
{%@@ endif @@%}
    ]

-- Do not swap workspaces across screens
workspaceKeys = do
    (tag, key) <- zip myWorkspaces "123456789"
    (otherModMasks, action) <-
        [ ("", windows . W.view)
        , ("S-", windows . W.shift)
        ]
    pure (otherModMasks ++ "M-" ++ [key], action tag)

-- Use physical screen order
screenKeys = do
    (key, screen) <- zip ['w', 'e', 'r'] [0..]
    (otherModMasks, action) <-
        [ ("", viewScreen def)
        , ("S-", sendToScreen def)
        ]
    pure (otherModMasks ++ "M-" ++ [key], action screen)

promptQuit = do
    response <- runProcessWithInput "dmenu" ["-p", "Really quit?"] "no\nyes\n"
    when (response == "yes\n") $ io exitSuccess
