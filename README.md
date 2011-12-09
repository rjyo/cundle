## Cundle

As iOS/Mac has more and more great libraries like ASIHTTPRequest, RestKit and etc. There's no good package management tool for it. Cundle is inspired by the simple but useful vim bundler `vundle` and aims to provide a tool with minimized functions to manage these packages.

## Usage

Run the following command under your project root. This will add ASIHttpRequest to SharedLib/asi-http-request. And by default, this command will also fetch all submodules or cundles defined inside the cundle.

	$ cundle install pokeb/asi-http-request

To list all install cundles
	
	$ cundle ls
	/Users/jyo/testproject/SharedLib
	├ pokeb/asi-http-request
	├ RestKit/RestKit
	└ enormego/EGOImageLoading

To remove a installed bundle. And you need to remove that dependency from you Xcode project manually.

	$ cundle remove RestKit/RestKit

If you have a `Cundlefile` at the project root. Use `cundle` to install all cundles defined in the `Cundlefile`.

	$ cat Cundlefile
	cundle "pokeb/asi-http-request"
	cundle "RestKit/RestKit"
	cundle "enormego/EGOImageLoading"
	
	$ cundle
	Installing "pokeb/asi-http-request" to ./SharedLib/asi-http-request ...
	Installing "RestKit/RestKit" to ./SharedLib/RestKit ...
	Installing "enormego/EGOImageLoading" to ./SharedLib/EGOImageLoading ...
	
	Done. All cundles installed.

## Install

Download and install cundle
	
	$ git clone git://github.com/rjyo/cundle.git ~/.cundle

To activate cundle, you need to source it from your bash shell

	$ . ~/.cundle/cundle.sh

Add this line to ~/.bashrc or ~/.zshrc (if you use oh-my-zsh like me) file to have it automatically sources upon login.
