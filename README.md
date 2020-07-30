# amazonlinux2-init.sh description
- amazonlinux2にgit, docker, docker-compose, aws cli2をインストール
- datetimeをJSTに変更、オプションでhostname設定
- yumコマンドでエラーが出ないようshebangのpythonをpython2に変更
## usage
``` bash amazonlinux2-init.sh```

# centos7-python3updater.sh description
- centos7にpython3をインストール
- デフォルトのpythonコマンドを変更するためシンボリックリンクを上書き
- yumコマンドでエラーが出ないようshebangのpythonをpython2に変更
## usage
```bash centos7-python3updater.sh python3.7```
- epelリポジトリのパッケージ形式にのみ対応しているため、参照するrepositoryにより適宜yumの行を変更する
