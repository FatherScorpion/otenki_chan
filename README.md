# お天気ちゃん

美少女育成型新感覚天気予報アプリ、お天気ちゃんです！

## COTOHAについて

<p>
本アプリでは<a href="https://api.ce-cotoha.com/contents/index.html">COTOHA API</a>の文章の感情認識APIを使用しています。<br>
COTOHAはアクセス権の譲渡を禁止しているため、利用者個人個人がAPIの使用申請を行う必要があります。<br>
申請ページ：https://api.ce-cotoha.com/contents/developers/index.html
</p>

<p>申請後、libファイル直下に以下の内容で「token.dart」を作成して下さい。???は各自が取得したDeveloper Client id、Developer Client secretを使用して下さい。URLは各自が取得したAccess Token Publish URLとDeveloper API Base URLを使用してください。各URLの末尾に"/"は必要ありません。</p>
<pre>
<code>
class tokens{
    static const String clientId="???";
    static const String clientSecret="???";
    static const String AccessTokenPublishURL="https://Access/Token/Publish/URL";
    static const String APIBaseURL="https://Developer/API/Base/URL";
}
</code>
</pre>

