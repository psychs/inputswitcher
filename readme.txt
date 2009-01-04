
* What is InputSwitcher?

InputSwitcher is an utility software to save the input source state of each window on Leopard.  It cannot work on Tiger or below.

* How to Install

You need SIMBL at first.  Please download it from the url and install it:

  - http://www.culater.net/software/SIMBL/SIMBL.php

And copy these files as well.

  - InputSwitcher.app -> /Applications
  - InputSwitcherClient.bundle -> ~/Library/Application Support/SIMBL/Plugins

Then you start InputSwitcher.app and restart other applications, it will be working.  You can see it saves the input source states as pushing cmd+space or cmd+option+space on each application and move the focus to the other applications.

* How to Uninstall

Remove the login item for InputSwitcher in [System Preferences] -> [Accounts] -> [Login Items].

And delete these files.

  - /Applications/InputSwitcher.app
  - ~/Library/Application Support/SIMBL/Plugins/InputSwitcherClient.bundle

Then stop InputSwitcher.app on ActitivyMonitor.  That's all.

* How It Works

On Leopard, it doesn't save the input source state of each window any more.  For example, if you changed the input source for Japanese on an application, and you moved to another application, the input source remains Japanese.  In another word, the input source state becomes a global state on Leopard.

InputSwitcherClient.bundle gets into each application process via SIMBL to notify their activate and deactivate events to InputSwitcher.app.

InputSwitcher.app remembers the input source states of all applications.  When it receives an activate event, it restores the previous input source state.  For an deactive event, it saves the input source state.

Therefore all applications can keep the input source state even on Leopard.

Due to the current implementation, there are several constraints.

It works only on Cocoa applications.  So applications listed below woundn't work.

  - Finder
  - Firefox
  - Thunderbird
  - iTunes

But for such a kind of applications, InputSwitcher saves the global state and apply it to them.  So it should not be a problem ordinally.

Especially Firefox and Thunderbird seems to have a problem.  Sometimes it locks the input source state after changing the input source state on activate.  Therefore InputSwitcher doesn't restore the input source state only when the focus moved to Firefox or Thunderbird from other applications.  It's a workaround for Firefox and Thunderbird.

*** Please send your bug report to Apple

The root cause of this problem is that Apple removed the feature from Leopard.  That's the problem.

InputSwitcher fairly works well, but in some cases it doesn't work.  I tried to make it always working better, but it could not be perfect.

Please send your bug report to Apple Bug Reporter to put the feature back.  The more Apple receives bug reports, the easier the developers in Apple can decide to do it.

https://bugreport.apple.com/

* The Author

Satoshi Nakagawa <psychs AT limechat DOT net>
http://limechat.net/psychs/
#limechat on irc.freenode.net

* License

The MIT License

Copyright (c) 2007 Satoshi Nakagawa

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
