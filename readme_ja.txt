
* InputSwitcher とは

InputSwitcher とは、Leopard 上で、入力ソースの状態をアプリケーションごとに保持するようにするためのユーティリティです。Tiger 以前では、動作しません。

* インストール方法

InputSwitcher の動作には、SIMBL が必要です。
以下の URL からダウンロードして、インストールしておいてください。

  - http://www.culater.net/software/SIMBL/SIMBL.php

InputSwitcher をインストールするには、

  - InputSwitcher.app を /Applications に
  - InputSwitcherClient.bundle を ~/Library/Application Support/SIMBL/Plugins に

それぞれコピーしてください。

その後、InputSwitcher.app を起動し、他のアプリケーションをすべていったん終了させて再起動すると使える状態になっています。

各アプリケーションで Cmd+Space や Cmd+Option+Space を押し、入力ソースの状態を切り替えてみて動作を確認してください。

* アンインストール方法

InputSwitcher は初回起動時にログイン時に起動するようになっているので、「システム環境設定」→「アカウント」→「ログイン項目」タブで InputSwitcher を削除してください。

次に、

  - /Applications/InputSwitcher.app
  - ~/Library/Application Support/SIMBL/Plugins/InputSwitcherClient.bundle

を削除してください。

これでアンインストールは完了です。

最後に、アクティビティモニタで動作中の InputSwticher.app を終了させることで、OS を再起動することなく完全に動作を停止させることができます。

* このソフトは何をしているのか

Leopard では、アプリケーションごとに入力ソースの状態を保持してくれなくなりました。つまり、入力ソースの状態はグローバルで、あるアプリケーションで日本語にすると、他のアプリケーションにフォーカスを移しても、日本語のままになります。

InputSwitcherClient.bundle は、SIMBL 経由で各アプリケーションのプロセスに潜り込み、アプリケーションの activate と、deactivate の2つのイベントを、あらかじめ起動しておいた InputSwitcher.app に通知します。

InputSwitcher.app は、各アプリケーションごとに入力ソースの状態を保持しています。activate イベントの通知を受け取ったときに、入力ソースをオン・オフして、以前の入力ソースの状態に復元します。deactivate イベントの通知のときに、入力ソースの状態を覚えておきます。

こうすることで、Leopard でも入力ソースの状態を各アプリケーションごとに別々に保持することができるようになります。

なお、現在の実装上、いくつかの制限があります。

Cocoa アプリケーションでしか動作しないので、以下のソフトでは動作しないことを確認しています。その場合でも、内部的にグローバル状態を別に保持しておいてそれを適用しているので、支障なく利用できると思います。

  - Finder
  - Thunderbird
  - iTunes

まれに、Thunderbird がアクティブになった瞬間に入力ソースの状態を変えると、そこから Cmd+Space を押しても入力ソースの状態を変えられなくなることがあるという不具合を確認しています。そのため、他のアプリケーションから Thunderbird にフォーカスを移したときにだけ、入力ソースの状態を変えないようにしてあります。

*** Apple にバグレポートを送ってください

問題の原因は、Apple が Leopard でウィンドウごとに入力ソースを保持するオプションをなくしてしまったことです。

この問題を回避するために InputSwitcher を開発しましたが、うまく動かない場合や問題が多く、やはり OS にオプションをもう一度付けてもらうことが一番いい解決策だと思います。

それを実現させるために、下の URL から Apple にバグレポートを送ってください。ユーザからの声が多く届けば届くほど、Apple 内部の開発者は要望に応えるように動きやすくなるようです。

https://bugreport.apple.com/

* 作者と連絡先

バグ報告・要望などあれば、ご連絡ください。

Satoshi Nakagawa <psychs AT limechat DOT net>
http://limechat.net/psychs/
#limechat on irc.freenode.net

* ライセンス

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
