# <img alt="Fightcade+ Installer Icon" src="https://github.com/blueminder/fcplus-windows-installer/assets/504581/60dd558c-f871-4943-883c-36e59aefe822" width="25" /> FC+ Windows Installer

__[Download Latest Version](https://github.com/blueminder/fcplus-windows-installer/releases/latest/download/fcplus.zip)__

The **Fightcade+ Installer** performs the most common post-installation steps [Fightcade](https://www.fightcade.com/) users take, and provides an easy way for users to switch between Flycast Dojo versions without manually messing with folders.

Intended to be run immediately after using the [official installer](https://www.fightcade.com/download/windows), or on existing Fightcade installations with the original bundled Flycast version.

<img alt="Fightcade+ Post Setup: Installation Folder" src="https://github.com/blueminder/fcplus-windows-installer/assets/504581/0719d447-4d59-407c-a902-bdf52e93c3fd" width="400" />
<img alt="Fightcade+ Post Setup: Component Listing" src="https://github.com/blueminder/fcplus-windows-installer/assets/504581/b8aa608b-518b-4eac-bb7f-d9273454c194" width="400" />

## Demonstration

A demonstration of the installer in action, run immediately after the official Fightcade installer. The end result is a fresh install of Fightcade with the latest Flycast Dojo, CvS2, and controller settings in ~2.5 minutes total.

[![FC+ Installer Demonstration](https://img.youtube.com/vi/jf00CETU7zI/0.jpg)](https://www.youtube.com/watch?v=jf00CETU7zI)

## Fightcade Game Controller / Numpad Control

By default, the installer retrieves and installs the [Fightcade Game Controller / Numpad Control script](https://github.com/blueminder/fightcade-joystick-kb-controls). This allows you to navigate the main Fightcade interface using only a joystick or numpad. Once you have mapped your controls to the emulators, (nearly) mouse-free use of everything Fightcade has to offer is in your grasp.

![Example of Fightcade joystick navigation. Opens game lobbies, cycles through game options, closes game lobbies.](https://github.com/blueminder/fcplus-windows-installer/assets/504581/b2845470-4ce0-4fd1-9f5c-d9254266f452)

## Latest Flycast Dojo & Version Switching

The latest [Flycast Dojo](https://github.com/blueminder/flycast-dojo) prereleases are made available to those who want the newest features before Fightcade updates. Just make sure that you have the same version as your opponent.

Switching between Flycast Dojo versions is as simple as selecting "Switch Fightcade Flycast Version". The next time you open Fightcade, the title bar will let you know which version you're on.

![Start Menu showing Fightcade Icons](https://github.com/blueminder/fcplus-windows-installer/assets/504581/dc4b3a2e-bfee-4286-888d-72d53052885f)
![Fightcade window title showing current Flycast version](https://github.com/blueminder/fcplus-windows-installer/assets/504581/001b3a3a-57cd-4432-b5ce-fa6cff5b70da)

## Preinstalled Lua Scripts

Downloads & installs the following Lua scripts:
  * [Grouflon's SFIII 3rd Strike Training Lua](https://github.com/Grouflon/3rd_training_lua)
  * [Nailok's VF4 Training Mode](https://github.com/Nailok/VF4-Training)

If you have any suggestions for more Lua scripts you would like me to bundle, let me know. I would like to expand this to more games.

## Custom Zip Extraction

You can create a custom zip file containing your modifications to the `emulator` folder in a Fightcade installation, and upload it to a web server for sharing. This is useful for distributing emulator scripts, preset controller mappings, and custom savestates to new installations (i.e., for tournament prep, multiple personal machines).

From there, anyone with the Fightcade+ installer can select the **Download custom ZIP archive and extract to emulator folder** option and paste the URL in the provided text box. Once the installer is run, the contents will be extracted to the `emulator` folder.

![image](https://github.com/blueminder/fcplus-windows-installer/assets/504581/868485ad-0fc6-4af7-b803-6cef87afaea8)
