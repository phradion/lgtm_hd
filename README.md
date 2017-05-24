# LgtmHd
[![Build Status](https://travis-ci.org/phradion/lgtm_hd.svg?branch=master)](https://travis-ci.org/phradion/lgtm_hd)
[![Code Climate](https://codeclimate.com/github/phradion/lgtm_hd/badges/gpa.svg)](https://codeclimate.com/github/phradion/lgtm_hd)
[![Test Coverage](https://codeclimate.com/github/phradion/lgtm_hd/badges/coverage.svg)](https://codeclimate.com/github/phradion/lgtm_hd/coverage)
[![Gem Version](https://badge.fury.io/rb/lgtm_hd.svg)](https://badge.fury.io/rb/lgtm_hd)

This game is for LGTM lovers that want to generate cool shits without leaving their terminal.

Check out the magic below

Source             |  Kawaii!
:-------------------------:|:-------------------------:
![](./images/example_1_before.gif?raw=true)  |  ![](./images/example_1_after.gif?raw=true)

Source             |  Happy Taeyeon!
:-------------------------:|:-------------------------:
![](./images/example_2_before.png?raw=true)  |  ![](./images/example_2_after.jpg?raw=true)


## Installation

    $ gem install lgtm_hd

## Usage

    $ lgtm_hd [transform] <source_uri> <output_folder> [--clipboard] [--interactive]
    $ lgtm_hd http://domain.com/image.jpg /path/lgtm.jpg 
    
    # --clipboard will let the OS copy content of the file for direct pasting to Github comment box
    # --interactive is for lazy people who can\'t bother to type
    # Default command is transform so you can just leave the command empty.

## Features

* Smart Color - render White or Black caption based on the background\'s darkness
* Source Image - Support Offline (file) or Online (url) 
* Caption Position - Top Center or Bottom Center positions for the caption
* Auto Clipboard - MacOSX user can just paste directly to comment box on Github after running the programm. On other OSes the clipboard only returns the path to the generated LGTM image.
* Formats - GIF, PNG, JPEG (SVG and TIFF not tested yet)
* Max Image size is 500px by 500px


## Features TODO List

* Add options for \[font size, positions\] (Code already setup for this, expect new version soon!)
* Add --source-random option incase there is no source provided.
* Add --caption-color for more colorful captions
* Integration to lgtm.in
    * Submission to lgtm.in
    * Query lgtm or google images and return the first found item
* Interactive mode with image preview in ASCII generation
* Interactive mode that allow adjusting LGTM captions
* Add progress bar for the whole generation process
* Support multiple LGTM texts


## Development

* Need to add RSpect test. Target is 90% code coverage on code climate.
* Need to refactor Lgtm_HD module for a more generic approach so it can become a meme generator in the future, not just LGTM.


## Contributing

As I am new in Ruby. Please feel free to help me improving this gem in whatever way you want, for examples, code contributing, code reviewing, manual testing or even just brushing up ideas :)

Bug reports and pull requests are welcome on GitHub at https://github.com/phradion/lgtm_hd. Of course as long as  you follow the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


## About Me

Ruby Newbie and Chandler Bing's big fan.
