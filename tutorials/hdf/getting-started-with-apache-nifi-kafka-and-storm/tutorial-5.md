Stormで処理したリアルタイム分析の結果をKafkaトピックから受信し、ファイルシステムに保存しましょう。

## 5-1: 必要なプロセッサを追加する

`Reporting` ProcessGroup内にプロセッサを追加します。

![](assets/flow.png)

- ConsumeKafka_0_10: `report`トピックからメッセージを受信します
- UpdateAttribute: `filename` Attributeを設定します
- PutFile: ファイルシステムへFlowFileを出力します

もうRelationshipの設定にも慣れてきたのではないでしょうか。

- 正常系をつなぐ
- 異常系を別ルートへ
- 不要なものはAuto-Terminate

です。

## 5-2: ConsumeKafka_0_10

| Property | Value |
|----------|-------|
| Kafka Brokers | 0.hdf.aws.mine:6667 |
| Topic Name(s) | report |
| Group ID | nifi |

## 5-3: UpdateAttribute

| Property | Value | Memo |
|----------|-------|------|
| filename | latest.json | |
| mime.type | application/json | 必須ではありませんが、設定しておくとFlowFileのPreviewがちゃんと見えたりして便利です |

## 5-4: PutFile

| Property | Value | Memo |
|----------|-------|------|
| Directory | /opt/hdf-handson/report | |
| Conflict Resolution Strategy | replace | すでに同一のファイル名がある場合は上書きします |

## 5-5: 分析結果を確認しながらテスト

ターミナルを２つ開きます。それぞれ、サーバにSSHでログインし、

一つ目のターミナルでは、次のコマンドでNiFiにHTTPでデータを登録しましょう。curlだと値を変えながら実行するのが多少面倒なので、スクリプトを用意しておきました:

```bash
# /opt/hdf-handson/bin/post-data <name> <age>
/opt/hdf-handson/bin/post-data A 35
```

もう一つのターミナルでは、watchコマンドでファイルを監視しておきましょう:

```bash
watch cat /opt/hdf-handson/report/latest.json
```

![](assets/test.png)

### [前へ](tutorial-4.md) | [次へ](tutorial-6.md)
