## Cundle

As iOS/Mac has more and more great libraries like ASIHTTPRequest, RestKit and etc. There's no good package management tool for it. Cundle is inspired by the simple but useful vim bundler `vundle` and aims to provide a tool with minimized functions to manage these packages.

The command line is written in bash. No need for compile.

## Usage

	$ cundle

	Cundle - the Obj-C Library Manager
	
	Usage:
	    cundle help                    Show this message
	    cundle remove <lib>            Remove a <lib>
	    cundle ls                      List installed libs
	    cundle install                 Download and install all libs defined in ./Cundlefile
	    cundle install <lib>           Download and install a <lib>
	    cundle update                  Use the latest code for libs defined in ./Cundlefile
	    cundle update <lib>            Use the latest code for <lib> from git
	
	Example:
	    cundle install RestKit/RestKit Install latest version of RestKit
	    cundle remove RestKit/RestKit  Remove RestKit under SharedLib

Run the following command under your project root. This will add ASIHttpRequest to SharedLib/asi-http-request. And by default, this command will also fetch all submodules or cundles defined inside the cundle.

	$ cundle install pokeb/asi-http-request

To list all install cundles
	
	$ cundle ls
	Installed libs under /Users/jyo/Examples/SharedLib:
	✓ enormego/EGOImageLoading
	✓ pokeb/asi-http-request

To remove a installed bundle. And you need to remove that dependency from you Xcode project manually.

	$ cundle remove RestKit/RestKit

If you have a `Cundlefile` at the project root. Use `cundle` to install all cundles defined in the `Cundlefile`.

	$ cat Cundlefile
	cundle "pokeb/asi-http-request"
	cundle "RestKit/RestKit"
	cundle "enormego/EGOImageLoading"
	
	$ cundle install
	Cloning into '/Users/jyo/Examples/SharedLib/asi-http-request'...
	Cloning into '/Users/jyo/Examples/SharedLib/EGOImageLoading'...
	Submodule 'EGOCache' (git://github.com/enormego/EGOCache.git) registered for path 'EGOCache'
	Cloning into 'EGOCache'...
	Submodule path 'EGOCache': checked out '8b7c7ecfc8fad396b6547ad3fef085713644f794'

Use `cundle update` to update your all your cundles or `cundle update RestKit/RestKit` for just RestKit.

## Install

Download and install cundle
	
	$ git clone git://github.com/rjyo/cundle.git ~/.cundle

To activate cundle, you need to source it from your bash shell

	$ . ~/.cundle/cundle.sh

Add this line to ~/.bashrc or ~/.zshrc (if you use oh-my-zsh like me) file to have it automatically sources upon login.

## Limitations & Future plan

* Only support repositories on github.com now. Will support any git repository.
* Not able to use a certain commit, tag or branch. It just pulls the latest source.
* `cundle` is still at its alpha stage, but I'll make it better as I can. [Shoot me an email](mailto:jyo.rakuraku@gmail.com) if you have any question.

## License

(The MIT License)

Copyright (c) 2011 Rakuraku Jyo

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
