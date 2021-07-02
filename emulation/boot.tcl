machine Boosted_MSX2_EN 
ext msxdos2 
bind F12 cycle videosource
plug joyporta mouse 
plug printerport simpl 
diska emulation/msx-dos2/
diskb bin/

proc wait_until_boot {} {
  global speed

  if {[string first "BOOT COMPLETED" [get_screen]] >= 0} {
    set speed 100
  } else {
    after time 5 wait_until_boot
  }
}

set save_settings_on_exit off
set speed 9999
set fullspeedwhenloading on
wait_until_boot