# ----------------------------------------------
# PROJECT:   $TARGET_NAME
# BUILD:     $BUILD_DATE
# GENERATOR: mikrocfg
# ----------------------------------------------
{
# startup delay 15s (to initialize interfaces...weak workaround..)
:delay 15

# outputbeep signal - 3 short tones
:beep frequency=3000 length=100ms;:delay 150ms; :beep frequency=3000 length=100ms;:delay 150ms; :beep frequency=3000 length=100ms;:delay 150ms
