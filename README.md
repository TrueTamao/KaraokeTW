* 此程序需要在 linux 環境下執行，需要安裝 postgres 套件，建議是 12 版。
* dump_to_csv.bash: 將 song.dump 分離出歌曲, 歌手以及類別的表格 （csv）。
* generate_patch.bash: 指定 Tag 產生歌庫的更新指令稿。 
* 更新指令稿會出現在 release 目錄內。

* 從 .dump 檔刷新 origin_songs database

```shell
# song
bash restore_origin_songs.bash

# YouTube
bash restore_origin_youtube.bash
```

* 從 origin_songs database 產生 csv 檔案

```shell
bash dump_to_csv.bash
```

* 產生 song patch file

```shell
# For tag 0.x.x
bash generate_patch.bash

# For tag 1.x.x
bash generate_patch_with_new_flag.bash
```

* 產生 cloud song patch file

```shell
bash generate_cloud_patch.bash
```

* 從 origin_songs database 備份 song dump 檔

```shell
bash backup_from_db.bash
```
* 從 origin_songs database 備份 youtube dump 檔

```shell
bash backup_youtube_from_db.bash
```
* 從 origin_songs database 產生 YouTube 表格資料

```shell
bash generate_youtube_data.bash
```

* 從 YouTube 表格資料更新資料庫

```
bash restore_youtube_from_table.bash
```

* 產生雲端歌檔的更新程序

```
bash storage.bash
```

