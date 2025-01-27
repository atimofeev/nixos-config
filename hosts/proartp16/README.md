# Asus ProArt P16 H7606

## Current issues

- Main Issues List: https://gitlab.com/asus-linux/asusctl/-/issues/555

  - Battery charging limit not working when laptop is off
  - HDMI not working
  - Keyboard lighting "breezes" or is on continuously. Cannot change/stop the keyboard lighting. ⌛ wait for k:6.14
  - Fn key (not even registering) ⌛ wait for k:6.14
  - Media keys (KB backlight, volume, screen brightness, microphone/webcam switches...) ⌛ wait for k:6.14
  - When using Hybrid mode (Optimus), the NVidia dGPU has a non-negligible power consumption. Seems the dGPU is not really off (Win11 does better)
  - Palm rejection on touchpad is meh ...
  - Webcam is kind slow in low light
  - ❓ Minimum screen brightness too high

- Dead KB Keys https://gitlab.com/asus-linux/asusctl/-/issues/585
- USB-C->HDMI adapter freezes https://gitlab.com/asus-linux/asusctl/-/issues/593
- Kernel OOPS during resume https://gitlab.com/asus-linux/asusctl/-/issues/594
