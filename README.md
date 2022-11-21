# Operator 12

## About

Operator 12 is going to be my answer to why aren't there more puzzle/story driven games like [Nightfall](http://biomediaproject.com/bmp/files/LEGO/gms/online/Spybotics/TheNightfallIncident/). Hopefully will include a good story, some nice audio & visuals, and some fun puzzles. Planned as a series, with a smaller inital game to test the waters and then a larger v2 game to improve upon the story and gameplay of the first.

This project itself is a V2. A version of the current work compiled to WebAssembly can be found [here](http://gaycodegal.github.io/apps/operator-12/).  The original Operator 12 only got so far as to have mock battles (A* pathing, quad-trees, visual representations etc.) and the code was lacking in quality. Now I've graduated college and have the skills to do this properly. Again I'll keep the scope generally quite small for the first release and try not to do anything fancy.

The name Operator 12 stems from Prisoner (TV 1967-68)-style naming system for your side of the battle. You are #12, you report to #2. There will be more story behind the names as you get to know your organization.


## Planned Content

You can check the [org](./org) folder for more information about planned content. Although as I develop the story to my liking there will be spoilers there. Opening it in emacs' orgmode should allow you to avoid looking at anything involved with the story.


## About Code

- Started from my sdl2-lua project as a base.
- C++ provides access to SDL2 rendering tools
- Most of the Code base is Lua, which creates the game.
    - Project runs quickly on my 2013 chromebook, so it'll probably run fine on mobile.


## Installation, Building, Running

Builds are similar across platforms, but library installation usually differs. For each platform you will need [bazel.build](https://bazel.build) set up for C++ development targeting whatever platform you wish to build for. Specific instruction is available for:
- [Linux](./LINUX.md)
- [Windows](./WINDOWS.md)
- [MacOS](./MAC_OS.md)
- [Android](./ANDROID.md)
- [WASM](./WASM.md)

In general assume that if copying in a folder for a `third_party` library you should merge the source and my corresponding `third_party` sub-directory. If you are asked whether to replace a specific file, you should assume the version that came with this project's git is the correct version.


## Doxygen

Run `python3 extract-docs.py > out.hidden.c && doxygen Doxyfile` to generate the docs. It's a horrible way to do it but it was easiest for me. Eventually I'll have a bazel target for generating docs.


## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md)


## Features

- Flexible display (weight based + pixel based)
- Movement Overlay
- Text
    - Can Render text in boxes
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
- Cross-platform.


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
- MouseWheel(x, y, dx, dy)
    - x & y are the current mouse position
    - dx & dy are the scroll delta
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

- Surface
    - `bazel run //:main test/surface`
- Texture
    - `bazel run //:main test/texture`


## View Controllers

- Battle
    - `bazel run //:main battle <map-name>.lua`
    - controls battles
- Viewer
    - `bazel run //:main viewer <path>/ <sep>`
    - view stuff, mostly just the copyright infos for stuff
- MainMenu
    - `bazel run //:main`
    - mostly just for easy access to stuff
- MapSelect
    - `bazel run //:main level-select`
    - map loading menu, based on maps in the [resources/maps](./resources/maps) folder
    - As there isn't a cross-platform listdir operation in SDL2 or Lua, I've opted to handle this with a python script. Running `python3 listdir.py` from within the resources folder will refresh the list. If you don't like python, just edit the `contents.lua` file in whatever directory you've added files to.
  
  
## Legal

[MIT license](./LICENSE) for the project.
I'm going to work in a Powered-by-Lua image eventually into the project. 
Also the MOZART NBP font (by Nate Halley) is used by this project. See [its readme](./resources/fonts/mozart_readme.txt) for details.

Thanks/Licenses page in testing at `bazel run //:main viewer` this simply displays all the licenses used by/planned to be used by the project when compiled & linked. These are located [here](./resources/licenses/).

I have obtained permission to do the work necessary to finish this project from my company via [iarc](https://opensource.google.com/docs/iarc/), which is a wonderful thing.
