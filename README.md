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

## Requirements

This gem needs [imagemagick](https://www.imagemagick.org/) installed on local machine for image processing

See if it has been installed already (should be able to see similar output like below)
```{r, engine='sh'}
$ convert -version
Version: ImageMagick 6.9.2-6 Q16 x86_64 2015-11-15 http://www.imagemagick.org
Copyright: Copyright (C) 1999-2015 ImageMagick Studio LLC
```
If not, follow below command to install it
```{r, engine='sh'}
$ sudo apt-get install imagemagick libmagickwand-dev # for Ubuntu, Debian
$ yum install -y ImageMagick ImageMagick-devel # for RHEL, CentOS, Fedora
$ brew install imagemagick # Mac with Brew
$ sudo port install imagemagick # Mac with Port
```

## Installation
```{r, engine='sh'}
$ gem install lgtm_hd
```

## Usage

Add LGTM caption to image
```{r, engine='sh'}
$ lgtm_hd <source_image_uri>
```    
Fetch random image from LGTM.in    
```{r, engine='sh'}
 $ lgtm_hd random 
```
Global Options: 
```{r, engine='sh'}
--interactive (-i) is for lazy people who can't bother to type
--dest <DIR> (-d) is for changing output folder
--preview high/low/none (-p) for changing quality of image previewing on terminal
```    

## Examples 
Add LGTM caption to image (with output)
```{r, engine='sh'}
$ lgtm_hd http://nogitweet.com/wp-content/uploads/2015/03/fbf5c1c80ffea521bad6e231061731a5.gif
Reading and inspecting source at http://nogitweet.com/wp-content/uploads/2015/03/fbf5c1c80ffea521bad6e231061731a5.gif
Transforming Image
Exporting to file
Exported LGTM image to /Users/huydq/Desktop/lgtm_hd_20170529005457.gif
Copied file to OS's clipboard for direct pasting to Github comments or Slack
```
Fetch random image from LGTM.in (with output)
```{r, engine='sh'}    
$ bundle exec bin/lgtm_hd random
Fetching from lgtm.in
Loading image at http://www.storyofbing.com/pics3/ff0040_kids_thumbs_up_sharp_mooiplaas.jpg
Exported image to /Users/huydq/Works/lgtm_hd/lgtm_hd_20170529011541.jpg
Copied file to OS's clipboard for direct pasting to Github comments or Slack

Or you can copy the markdown format below provided by lgtm.in
[![LGTM](https://lgtm.in/p/mdVnGXxym)](https://lgtm.in/i/mdVnGXxym)
if the lgtm.in's image does not have LGTM texts on it, run the cmd below
lgtm_hd /Users/huydq/Works/lgtm_hd/lgtm_hd_20170529011541.jpg
```   
    
Interaction Mode
```{r, engine='sh'} 
$ lgtm_hd -i
-- LGTM HD Interactive Mode --
Source Image (URL or Path/to/file): lgtm_hd_20170527122725.jpg
Destination Directory (Enter to skip):
...
```
Image Preview

![](./images/preview_kawaii.png?raw=true)
![](./images/preview_random.png?raw=true)

## Features

* Smart Color - render White or Black caption based on the background\'s darkness
* Auto Clipboard - MacOSX user can just paste directly to comment box on Github after running the programm. On other OSes the clipboard only returns the path to the generated LGTM image.
* Random image from LGTM.in
* Image Preview on terminal
* Formats - GIF, PNG, JPEG (SVG and TIFF not tested yet)
* Max Image size is 500px by 500px


## Features TODO List
* Caption Position - Top Center or Bottom Center positions for the caption
* Add options for \[font size, positions\] (Code already setup for this, expect new version soon!)
* Add --source-random option incase there is no source provided.
* Add --caption-color for more colorful captions
* Submission to lgtm.in
* Keyword's based Query google images and return the first found item
* Interactive mode that allow adjusting LGTM captions
* Add progress bar for the whole generation process
* Support multiple LGTM texts
* Need to add RSpect test. Target is 90% code coverage on code climate.
* Need to refactor Lgtm_HD module for a more generic approach so it can become a meme generator in the future, not just LGTM.

## Development
```{r, engine='sh'} 
bundle install
bundle exec bin/lgtm_hd 

# Local gem build and testing
rake build
gem install pkg/lgtm_hd_x.x.x.gem
```

## Contributing

I am new to Ruby, I wrote this gem for self-educating. So, please feel welcome to correct me where I am wrong, contribute & review code, or test it on multiple platforms, or just bring up ideas.

Bug reports and pull requests are welcome on GitHub at https://github.com/phradion/lgtm_hd.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


## About Me

AJAX Amsterdamche FC & Chandler Bing's big fan.
