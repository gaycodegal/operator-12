# Operator 12

## About

Operator 12 is going to be my answer to why aren't there more puzzle/story driven games like [Nightfall](http://biomediaproject.com/bmp/files/LEGO/gms/online/Spybotics/TheNightfallIncident/). Hopefully will include a good story, some nice audio & visuals, and some fun puzzles. Planned as a series, with a smaller inital game to test the waters and then a larger v2 game to improve upon the story and gameplay of the first.

This project itself is a V2. The original Operator 12 only got so far as to have mock battles (A* pathing, quad-trees, visual representations etc.) and the code was lacking in quality. Now I've graduated college and have the skills to do this properly. Again I'll keep the scope generally quite small for the first release and try not to do anything fancy.

The name Operator 12 stems from Prisoner (TV 1967-68)-style naming system for your side of the battle. You are #12, you report to #2. There will be more story behind the names as you get to know your organization.


## Features

- Layout Generator
	- Generates resizing functions from layout definitions.
	- usage `./main ui/style-writer <name>`
		- see name:`screen` for a simple example
- UIElement
	- resizable elements generated from a layout style and a list of elements/data to be styled
- Button
	- can click them and they do *things*
- Movement Overlay
- Text
	- Can Render text in boxes
- TextBox
	- For when Text just isn't enough
- Escape key closes game.
- Map
	- Can load map and slug data from Lua file exported by [Tiled](https://www.mapeditor.org/)
		- Sample map file found in resources/maps
	- currently handles drawing of a loaded map
	- hopefully will eventually only handle map data and be moved to C++
	- can scroll/pan with arrow keys
- Segment
	- Linked list node part of the slug
- Slug
	- the basic entity of the game
	- essentially a linked list moving about the game-board
	- can move about the board if clicked one space away from 'head'
	- can damage other slugs and kill them
	- regen size as they move up to a max size
	- Enemy slugs controlled by computer AI
- Slug/Slugdefs
	- holds info on what sprites are associated with which slug-type
- Technically cross-platform, although you'll have the easiest time with Linux. I'm developing it on linux, releases will have multiple OS (and mobile if I'm not lazy).
	- I got windows working actually!


## Planned Content

You can check the [org](./org) folder for more information about planned content. Although as I develop the story to my liking there will be spoilers there. Opening it in emacs' orgmode should allow you to avoid looking at anything involved with the story.


## About Code

- Started from my sdl2-lua project as a base.
- C++ provides access to SDL2 rendering tools
- Most of the Code base is Lua, which creates the game.
	- Project runs quickly on my 2013 chromebook, so it'll probably run fine on mobile.


## Installation

Custom Libraries you'll need

- SDL2-Dev `apt install libsdl2-dev`
- SDL2-Image-Dev `apt install libsdl2-image-dev`
- SDL2-TTF-Dev `apt install libsdl2-ttf-dev`
- SDL-Mixer-Dev `apt install libsdl-mixer1.2-dev`
- Lua 5.3.4
  - Installation instructions available at [www.lua.org](https://www.lua.org/download.html)
  - Should be located in ~/lua
  - You don't need command-line lua

And Obviously you'll need `g++` to compile, and `make` to use my makefile.


## Building

Just run `make` after installing all the software


## Running 

Just run `./main` after building is complete

You can also specify which lua file to run as the main. For instance `./main surface-tests` will run the surface tests lua file as the main lua file.


## Doxygen

Run `python3 extract-docs.py > out.hidden.c && doxygen Doxyfile` to generate the docs. It's a horrible way to do it but it was easiest for me


## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md)


## C++ / Lua Methods

You can generate method stubs with `python3 luahelper.py < surface.txt > surface.hidden.c` anything with `.hidden.` in it's file name is ignored by the git ignore. See surface.txt and luahelper.py for understanding of what's generated. You'll have to use auto-indentation from something like emacs or a C++ IDE to indent it, but at least you don't have to write it.

## Special Lua Methods Called by C++

- Start(argc, argv)
- Update(msFraction, msTrue)
	- Called every frame, and after every event
- End
- Resize(width, height)
	- Window has resized to (width, height).
	- Globals will not be modified by this at this time.
- KeyDown(which)
- KeyUp(which)
- MouseDown(x, y)
- MouseMove(x, y)
- MouseUp(x, y)

## Classes Exposed to Lua via C++

### Music

- new(source)
    - returns 1
- play(music,times)
    - returns 0
- setPosition(music,position)
    - returns 0
- pause(music)
    - returns 0
- resume(music)
    - returns 0
- destroy(music)
    - returns 0


### Sprite

- new(Texture, x, y, w, h, sx, sy)
    - returns sprite
- move(self, x, y)
    - returns void
- size(self, w, h)
    - returns void
- draw(self, x, y)
    - returns void
- destroy(self)
    - returns void


### Texture

- new(source)
	- doesn't create an object (userdata), only a pointer (lightuserdata)
	- returns texture, width, height
- destroy(texture)
	- returns 0
- newTarget(width,height)
    - returns 1
- setRGBMask(texture,r,g,b)
    - returns 0
- setAMask(texture,a)
    - returns 0
- renderCopy(texture,sx,sy,sw,sh,dx,dy,dw,dh)
    - returns 0
- blendmode(texture,mode)
    - returns 0


### Surface

- new(source)
    - returns 1
- newBlank(width,height)
    - returns 1
- blendmode(surface,mode)
    - returns 0
- fill(surface,x,y,width,height,r,g,b,a)
    - returns 0
- size(surface)
    - returns 2
- blit(dst,src,x,y)
    - returns 0
- textureFrom(surface)
    - returns 1
- blitScale(dst,src,sx,sy,sw,sh,dx,dy,dw,dh)
    - returns 0
- destroy(surface)
    - returns 0


### TTF

- surface(text,r,g,b,a)
    - returns 1
- size(text)
    - returns 2


## Globals Method Exposed to Lua via C++

- static.quit()
    - exits the engine
- static.wait(time)
	- wait `time` ms immediately
- static.framedelay(time)
	- wait `time` ms after screen is displayed
- static.setRenderTarget(texture)
    - returns 0
- static.unsetRenderTarget()
    - returns 0
- static.renderClear()
    - returns 0
- static.renderBlendmode(mode)
    - returns 0


## Global Constants Exposed to Lua via C++

- Keys
	- `KEY_UP`, `KEY_DOWN`, `KEY_LEFT`, `KEY_RIGHT`, `KEY_ESCAPE`
- Screen Dimensions
	- `SCREEN_WIDTH`, `SCREEN_HEIGHT`
- Blend Modes
	- `BLENDMODE_NONE`, `BLENDMODE_BLEND`, `BLENDMODE_ADD`, `BLENDMODE_MOD`


## Tests

- Text
	- `./main text/test`
	- Use arrow keys to navigate the rendered README!
- Surface
	- `./main surface-tests`
- Texture
	- `./main texture-tests`

## View Controllers

- Battle
  - `./main battle/load <map-name>.lua`
  - controls battles
- Viewer
  - `./main viewer/load <path> <sep>`
  - view shit, mostly just the copyright infos for stuff
- MainMenu
  - `./main`
  - mostly just for easy access to stuff
- MapSelect
  - `./main level-select/load`
  - map loading menu, based on maps in the [resources/maps](./resources/maps) folder
  - As there isn't a cross-platform listdir operation in SDL2 or Lua, I've opted to handle this with a python script. Running `python3 listdir.py` from within the resources folder will refresh the list. If you don't like python, just edit the `.contents.lua` file in whatever directory you've added files to.
  
  
## Legal

[MIT license](./LICENSE) for the project.
I'm going to work in a Powered-by-Lua image eventually into the project. 
Also the MOZART NBP font (by Nate Halley) is used by this project. See [its readme](./resources/fonts/mozart_readme.txt) for details.

Thanks/Licenses page in testing at `./main viewer/load` this simply displays all the licenses used by/planned to be used by the project when compiled & linked. These are located [here](./resources/licenses/).

I have obtained permission to do the work necessary to finish this project from my company via [iarc](https://opensource.google.com/docs/iarc/), which is a wonderful thing.
