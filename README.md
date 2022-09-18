# お天気ちゃん

美少女育成型新感覚天気予報アプリ、お天気ちゃんです！

## COTOHAについて

本プロジェクトにおいてCOTOHAの文章の感情認識APIを使用しています。
COTOHAはアクセス権の譲渡を禁止しているため、利用者個人個人がAPIの使用申請を行う必要があります。
申請ページ：https://api.ce-cotoha.com/contents/developers/index.html

申請後、libファイル直下に以下の内容で「token.dart」を作成して下さい。???は各自が取得した内容を使用して下さい。
class tokens{
    static const String clientId="???";
    static const String clientSecret="???";
    static const String AccessTokenPublishURL="???";
    static const String APIBaseURL="???";
}

