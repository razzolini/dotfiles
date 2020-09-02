{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

import Control.Monad (when)
import Data.Foldable (find, traverse_)
import System.Exit (exitSuccess)
import System.IO (Handle, hPutStrLn)
import XMonad
import XMonad.Actions.CycleWS (swapNextScreen)
import XMonad.Actions.PhysicalScreens (sendToScreen, viewScreen)
import XMonad.Actions.SpawnOn (manageSpawn, spawnOn)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops (ewmh, fullscreenEventHook)
import XMonad.Hooks.ManageDocks (avoidStruts, docks)
import XMonad.Layout.LayoutModifier
import XMonad.Layout.NoBorders (lessBorders, Ambiguity(OnlyScreenFloat))
import XMonad.Layout.Reflect (reflectHoriz)
import qualified XMonad.StackSet as W
import XMonad.Util.Run (runProcessWithInput, spawnPipe)
import XMonad.Util.EZConfig (additionalKeysP)

main :: IO ()
main = do
    xmobarHandles <- xmobarOnScreens myScreens
    xmonad . ewmh . docks $ def -- 'docks' is required for 'avoidStruts'
        { manageHook =
            manageSpawn -- Required for spawnOn
            <+> manageHook def
        , layoutHook =
            lessBorders OnlyScreenFloat -- Do not draw borders for fullscreen windows
            $ avoidStruts -- Leave space for the status bar
            $ myLayouts
        , handleEventHook =
            fullscreenEventHook -- Handle applications that request to become fullscreen
            <+> handleEventHook def
        , startupHook =
            myStartupHook
            <+> startupHook def
        , terminal = "urxvt"
        -- Rebind Mod to the Windows key
        , modMask = mod4Mask
        -- Send info to xmobar
        , logHook = dynamicLogWithPP xmobarPP
            { ppOutput = multiHPutStrLn xmobarHandles
            , ppTitle = xmobarColor "green" "" . shorten 50
            }
        -- Set custom workspace names
        , workspaces = myWorkspaces
        } `additionalKeysP` myKeys

myScreens :: [Int]
{%@@ if profile == "home-desktop" @@%}
myScreens = [0, 1]
{%@@ else @@%}
myScreens = [0]
{%@@ endif @@%}

xmobarOnScreens :: [Int] -> IO [Handle]
xmobarOnScreens = traverse spawnXmobarOnScreen
  where
    spawnXmobarOnScreen sc = spawnPipe $ "xmobar -x " ++ show sc ++ " \"$HOME/.config/xmonad/xmobarrc\""

multiHPutStrLn :: Foldable t => t Handle -> String -> IO ()
multiHPutStrLn hs msg = traverse_ (\h -> hPutStrLn h msg) hs

{%@@ if profile == "home-desktop" @@%}
myLayouts :: Choose (ModifiedLayout AutoReflectX Tall) (Choose (Mirror Tall) Full) Window
myLayouts = autoReflectX [1] tall ||| Mirror tall ||| Full
  where
    tall = Tall nmaster delta ratio
    nmaster = 1 -- The default number of windows in the master pane
    delta = 3/100 -- Percent of screen to increment by when resizing panes
    ratio = 1/2 -- Default proportion of screen occupied by master pane

autoReflectX :: [ScreenId] -> l a -> ModifiedLayout AutoReflectX l a
autoReflectX screensToReflect = ModifiedLayout (AutoReflectX NotReflecting screensToReflect)

data AutoReflectX a = AutoReflectX !AutoReflection ![ScreenId]
    deriving (Read, Show)

data AutoReflection = NotReflecting | Reflecting
    deriving (Read, Show)

instance LayoutModifier AutoReflectX a where
    modifyLayoutWithUpdate (AutoReflectX _ screensToReflect) workspace rect = do
        maybeScreen <- workspaceScreenId (W.tag workspace)
        case maybeScreen of
            Just screen | screen `elem` screensToReflect -> runReflected
            _ -> runNormal
      where
        runReflected = do
            let reflectedWorkspace = workspace { W.layout = reflectHoriz (W.layout workspace) }
            (windowRects, newReflectedLayout) <- runLayout reflectedWorkspace rect
            let newLayout = fmap unmodifyLayout newReflectedLayout
            pure ((windowRects, newLayout), newModifier Reflecting)
        runNormal = (,) <$> runLayout workspace rect <*> pure (newModifier NotReflecting)
        newModifier refl = Just $ AutoReflectX refl screensToReflect

    modifierDescription (AutoReflectX refl _) = case refl of
        NotReflecting -> ""
        Reflecting -> "ReflectX"

workspaceScreenId :: WorkspaceId -> X (Maybe ScreenId)
workspaceScreenId wid = do
    screens <- gets (W.screens . windowset)
    let maybeScreen = find ((== wid) . W.tag . W.workspace) screens
    pure (W.screen <$> maybeScreen)

unmodifyLayout :: ModifiedLayout m l a -> l a
unmodifyLayout (ModifiedLayout _ l) = l
{%@@ else @@%}
myLayouts :: Choose Tall (Choose (Mirror Tall) Full) Window
myLayouts = layoutHook def
{%@@ endif @@%}

myStartupHook :: X ()
myStartupHook = do
{%@@ if profile == "home-desktop" @@%}
    windows $ W.view "1" -- Focus workspace 1 (instead of 2, because of screen order)
    spawnOn mailWorkspace "thunderbird"
{%@@ else @@%}
    pure ()
{%@@ endif @@%}

myWorkspaces :: [String]
myWorkspaces =
{%@@ if profile == "home-desktop" @@%}
    fmap (show :: Int -> String) [1..8] ++ [mailWorkspace]
{%@@ else @@%}
    workspaces def
{%@@ endif @@%}

{%@@ if profile == "home-desktop" @@%}
mailWorkspace :: String
mailWorkspace = "9.Mail"
{%@@ endif @@%}

myKeys :: Keymap
myKeys = workspaceKeys ++ screenKeys ++
    [ ("M-o", spawn "chromium")
    , ("M-S-o", spawn "chromium --incognito")
    , ("M-i", spawn "emacsclient -a '' -nqc")
    , ("M-S-p", spawn "power-menu")
    , ("M-S-q", promptQuit) -- Ask for confirmation before quitting
{%@@ if profile == "home-desktop" @@%}
    , ("M-0", swapNextScreen) -- Swap the workspaces on the two screens
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

promptQuit :: X ()
promptQuit = do
    response <- runProcessWithInput "dmenu" ["-p", "Really quit?"] "no\nyes\n"
    when (response == "yes\n") $ io exitSuccess

-- Do not swap workspaces across screens
workspaceKeys :: Keymap
workspaceKeys = do
    (tag, key) <- zip myWorkspaces "123456789"
    (otherModMasks, action) <-
        [ ("", windows . W.view)
        , ("S-", windows . W.shift)
        ]
    pure (otherModMasks ++ "M-" ++ [key], action tag)

-- Use physical screen order
screenKeys :: Keymap
screenKeys = do
    (key, screen) <- zip ['w', 'e', 'r'] [0..]
    (otherModMasks, action) <-
        [ ("", viewScreen def)
        , ("S-", sendToScreen def)
        ]
    pure (otherModMasks ++ "M-" ++ [key], action screen)

type Keymap = [(String, X ())]
