{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE RankNTypes #-}

import Control.Monad (when)
import Data.Foldable (find)
import System.Exit (exitSuccess)
import XMonad
import XMonad.Actions.CycleWS (swapNextScreen)
import XMonad.Actions.PhysicalScreens (sendToScreen, viewScreen)
import XMonad.Actions.SpawnOn (manageSpawn, spawnOn)
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.ManageDocks (avoidStruts, docks)
import XMonad.Hooks.StatusBar (StatusBarConfig, statusBarProp, withSB)
import XMonad.Hooks.StatusBar.PP (PP(..), shorten, xmobarColor, xmobarPP)
import XMonad.Layout.LayoutModifier
    ( LayoutModifier(modifyLayoutWithUpdate, modifierDescription)
    , ModifiedLayout(..)
    )
import XMonad.Layout.NoBorders (lessBorders, Ambiguity(OnlyScreenFloat))
import XMonad.Layout.Reflect (reflectHoriz)
import qualified XMonad.StackSet as W
import qualified XMonad.Util.Hacks as Hacks
import XMonad.Util.Run (runProcessWithInput)
import XMonad.Util.EZConfig (additionalKeysP)

data Profile
    = HomeDesktop
    | Laptop
    deriving (Eq)

profile :: Profile
{%@@ if profile == "home-desktop" @@%}
profile = HomeDesktop
{%@@ elif profile == "laptop" @@%}
profile = Laptop
{%@@ endif @@%}

main :: IO ()
main = withMyLayouts $ \myLayouts ->
    xmonad
    . withSB (xmobarOnScreens myScreens)
    . Hacks.javaHack -- Tell Java that xmonad is a non-reparenting window manager
    . ewmhFullscreen -- Handle applications that request to become fullscreen
    . ewmh
    . docks -- Required for 'avoidStruts'
    . (`additionalKeysP` myKeys)
    $ def
        { manageHook =
            manageSpawn -- Required for 'spawnOn'
            <+> manageHook def
        , layoutHook =
            lessBorders OnlyScreenFloat -- Do not draw borders for fullscreen windows
            $ avoidStruts -- Leave space for the status bar
            $ myLayouts
        , startupHook =
            myStartupHook
            <+> startupHook def
        , terminal = "alacritty"
        -- Rebind Mod to the Windows key
        , modMask = mod4Mask
        -- Set custom workspace names
        , workspaces = myWorkspaces
        }

myScreens :: [Int]
myScreens = case profile of
    HomeDesktop -> [0, 1]
    Laptop -> [0]

xmobarOnScreens :: [Int] -> StatusBarConfig
xmobarOnScreens = foldMap $ \screen -> statusBarProp (xmobarCommand screen) (pure myPP)
  where
    xmobarCommand screen = "xmobar --screen " ++ show screen
    myPP = xmobarPP { ppTitle = xmobarColor "#00ff00" "" . shorten 50 }

-- Workaround for runtime selection between layouts of different types
-- (inspired by https://stackoverflow.com/a/60715978)
withMyLayouts :: (forall l. (LayoutClass l Window, Read (l Window)) => l Window -> r) -> r
withMyLayouts cont = case profile of
    HomeDesktop -> cont $ autoReflectX [1] tall ||| others
    Laptop -> cont defaultLayout
  where
    defaultLayout :: Choose Tall (Choose (Mirror Tall) Full) Window
    defaultLayout@(Choose _ tall others) = layoutHook def

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

myStartupHook :: X ()
myStartupHook = when (profile == HomeDesktop) $ do
    windows $ W.view "1" -- Focus workspace 1 (instead of 2, because of screen order)
    spawnOn mailWorkspace "thunderbird"

myWorkspaces :: [String]
myWorkspaces = case profile of
    HomeDesktop -> fmap (show :: Int -> String) [1..8] ++ [mailWorkspace]
    Laptop -> workspaces def

mailWorkspace :: String
mailWorkspace = "9.Mail"

type Keymap = [(String, X ())]

myKeys :: Keymap
myKeys = workspaceKeys ++ screenKeys ++ commonKeys ++ profileKeys

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

commonKeys :: Keymap
commonKeys =
    [ ("M-o", spawn "firefox")
    , ("M-S-o", spawn "firefox --private-window")
    , ("M-i", spawn "emacsclient -a '' -nqc")
    , ("M-S-p", spawn "power-menu")
    , ("M-S-q", promptQuit) -- Ask for confirmation before quitting
    , ("M-0", swapNextScreen) -- Swap workspaces between two screens
    ]

profileKeys :: Keymap
profileKeys = case profile of
    HomeDesktop ->
        -- Media keys
        [ ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
        , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
        , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
        , ("<XF86AudioPlay>", spawn "playerctl play-pause")
        , ("<XF86AudioStop>", spawn "playerctl stop")
        , ("<XF86AudioNext>", spawn "playerctl next")
        , ("<XF86AudioPrev>", spawn "playerctl previous")
        ]
    Laptop -> [("M-b", spawn "toggle-touchpad")]
