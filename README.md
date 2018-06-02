# Operator 12

## About

Operator 12 is going to be my answer to why aren't there more puzzle/story driven games like [Nightfall](http://biomediaproject.com/bmp/files/LEGO/gms/online/Spybotics/TheNightfallIncident/). Hopefully will include a good story, some nice audio & visuals, and some fun puzzles. Planned as a series, with a smaller inital game to test the waters and then a larger v2 game to improve upon the story and gameplay of the first.

This project itself is a V2. The original Operator 12 only got so far as to have mock battles (A* pathing, quad-trees, visual representations etc.) and the code was lacking in quality. Now I've graduated college and have the skills to do this properly, and this time it will be open-source as well. Again I'll keep the scope generally quite small for the first release and try not to do anything fancy.

The name Operator 12 stems from Prisoner (TV 1967-68)-style naming system for your side of the battle. You are #12, you report to #2. There will be more story behind the names as you get to know your organization.


## Features

- Battle/Map Class
    - currently handles drawing of a simple map
	- hopefully will eventually only handle map data and be moved to C++
	- can scroll/pan with arrow keys
- Slug/Slug Class
	- the basic entity of the game
	- will essentially be a linked list moving about the board
	- can move about the board if clicked one space away from 'head'
- Slug/Slugdefs
	- holds info on what sprites are associated with which slug-type
- Technically cross-platform, although you'll have the easiest time with Linux. I'm developing it on linux, releases will have multiple OS (and mobile if I'm not lazy).


## Planned Content

You can check the [org](./org) folder for more information about planned content. Although as I develop the story to my liking there will be spoilers there. Opening it in emacs' orgmode should allow you to avoid looking at anything involved with the story.


## About Code

- Started from my sdl2-lua project as a base.
- Many mocks will appear first in lua then become C++
- AIs will be done within lua, although time consuming algorithms like Quad-Tree search and pathing will be in C++
- Still very much a work in progress.


## Installation

Custom Libraries you'll need

- SDL2-Dev `apt-get install libsdl2-dev`
- SDL2-Image-Dev `apt-get install libsdl2-image-dev`
- SDL2-TTF-Dev `apt-get install libsdl2-ttf-dev`
- SDL2-Mixer-Dev `apt-get install libsdl2-mixer-dev`
- Lua 5.3.4
  - Installation instructions available at [www.lua.org](https://www.lua.org/download.html)
  - Should be located in ~/lua
  - You don't need command line lua


## Building

Just run `make` after installing all the software


## Classes Exposed to Lua via C++

Sprite

- new(Texture, x, y, w, h)
    - returns sprite
- move(self, x, y)
    - returns void
- size(self, w, h)
    - returns void
- draw(self, x, y)
    - returns void
- destroy(self)
    - returns void

Texture

- new(source)
  - doesn't create an object (userdata), only a pointer (lightuserdata)
  - returns texture, width, height
- destroy(texture)
  - returns void


## Globals Method Exposed to Lua via C++

- static.quit()
    - exits the engine
- static.wait(time)
	- wait `time` ms
