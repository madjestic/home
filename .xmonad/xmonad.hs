import XMonad
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import System.IO

main = do
  xmproc <-spawnPipe "xmobar /home/madjestic/.xmobarrc"
  xmonad $ defaultConfig
    { terminal   = "urxvt"
    , normalBorderColor  = "#000000" 
    , focusedBorderColor = "#335533"
    , manageHook = manageDocks <+> manageHook defaultConfig
    , layoutHook = avoidStruts  $  layoutHook defaultConfig
    , logHook    = dynamicLogWithPP xmobarPP
                       { ppOutput = hPutStrLn xmproc
		       , ppTitle  = xmobarColor "green" "" . shorten 50
		       }
    , modMask    = mod4Mask
    } `additionalKeys`
    [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
    , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
    , ((0, xK_Print), spawn "scrot")
    ]
