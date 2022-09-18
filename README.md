# お天気ちゃん

美少女育成型新感覚天気予報アプリ、お天気ちゃんです！

## COTOHAについて

<p>本プロジェクトにおいてCOTOHAの文章の感情認識APIを使用しています。</p>
<p>COTOHAはアクセス権の譲渡を禁止しているため、利用者個人個人がAPIの使用申請を行う必要があります。</p>
<p>申請ページ：https://api.ce-cotoha.com/contents/developers/index.html</p>

<p>申請後、libファイル直下に以下の内容で「token.dart」を作成して下さい。???は各自が取得した内容を使用して下さい。</p>
<code>
class tokens{\n
    static const String clientId="???";\n
    static const String clientSecret="???";\n
    static const String AccessTokenPublishURL="???";\n
    static const String APIBaseURL="???";\n
}
</code>

