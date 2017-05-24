# LgtmHd
[![Build Status](https://travis-ci.org/phradion/lgtm_hd.svg?branch=master)](https://travis-ci.org/phradion/lgtm_hd)
[![Code Climate](https://codeclimate.com/github/phradion/lgtm_hd/badges/gpa.svg)](https://codeclimate.com/github/phradion/lgtm_hd)
[![Test Coverage](https://codeclimate.com/github/phradion/lgtm_hd/badges/coverage.svg)](https://codeclimate.com/github/phradion/lgtm_hd/coverage)

This game is for LGTM lovers that want to generate cool shits without leaving their terminal.

Check out the magic below
Source             |  Kawaii!
:-------------------------:|:-------------------------:
![](./images/example_1_before.gif?raw=true)  |  ![](./images/example_1_after.gif?raw=true)

Source             |  Happy Taeyeon!
:-------------------------:|:-------------------------:
![](./images/example_2_before.jpg?raw=true)  |  ![](./images/example_2_after.jpg?raw=true)

## Installation
    $ gem install lgtm_hd

## Usage
    $ lgtm_hd <source> <output> [--clipboard]
    $ lgtm_hd http://domain.com/image.jpg /path/lgtm.jpg

## Features
* Smart Color - render White or Black caption based on the background's darkness
* Source Image - Support Offline (file) or Online (url) 
* Caption Position - Top Center or Bottom Center positions for the caption
* Auto Clipboard - MacOSX user can just paste directly to comment box on Github after running the programm. On other OSes the clipboard only returns the path to the generated LGTM image.
* Formats - GIF, PNG, JPEG (SVG and TIFF not tested yet)

## TODO List
* Add --source-random option incase there is no source provided.
* Add --caption-color for more colorful captions
* Integrate with lgtm.in or google images
    * Submission to lgtm.in
    * Query lgtm or google images and return the first found item
* Interactive mode with image preview in ASCII generation
* Interactive mode that allow adjusting LGTM captions
* Add progress bar for the whole generation process
* Support multiple LGTM texts

## Contributing
As I am new in Ruby. Please feel free to help me improving this gem in whatever way you want, for examples, code contributing, code reviewing, manual testing or even just brushing up ideas :)

Bug reports and pull requests are welcome on GitHub at https://github.com/phradion/lgtm_hd. Of course as long as  you follow the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## About Me
Ruby Newbie and Chandler Bing's big fan.
