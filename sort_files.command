#!/bin/bash

# ユーザーに基本パスを尋ねる
echo "写真・動画の整理を行います。ベースディレクトリのパスを入力してください:"
read -r BASE_DIR

# 入力されたパスが存在するか確認
if [ ! -d "$BASE_DIR" ]; then
  echo "エラー: 指定されたディレクトリ「$BASE_DIR」は存在しません。"
  exit 1
fi

# baseディレクトリのパスを設定
BASE_SORTED_DIR="${BASE_DIR}/base"

# サブディレクトリのパスを設定
ARW_DIR="${BASE_SORTED_DIR}/arw"
JPG_DIR="${BASE_SORTED_DIR}/jpg"
MP4_DIR="${BASE_SORTED_DIR}/mp4"
EDITED_DIR="${BASE_DIR}/edited" # 編集済みディレクトリは現在の仕様通り

# baseディレクトリの確認と作成
if [ ! -d "$BASE_SORTED_DIR" ]; then
  echo "baseディレクトリが存在しないため作成します..."
  mkdir -p "$BASE_SORTED_DIR"
fi

# arwディレクトリの確認と作成
if [ ! -d "$ARW_DIR" ]; then
  echo "arwディレクトリが存在しないため作成します..."
  mkdir -p "$ARW_DIR"
fi

# jpgディレクトリの確認と作成
if [ ! -d "$JPG_DIR" ]; then
  echo "jpgディレクトリが存在しないため作成します..."
  mkdir -p "$JPG_DIR"
fi

# mp4ディレクトリの確認と作成
if [ ! -d "$MP4_DIR" ]; then
  echo "mp4ディレクトリが存在しないため作成します..."
  mkdir -p "$MP4_DIR"
fi

# editedディレクトリの確認と作成
if [ ! -d "$EDITED_DIR" ]; then
  echo "editedディレクトリが存在しないため作成します..."
  mkdir -p "$EDITED_DIR"
fi

# null ディレクトリを作成（メタデータが存在しないファイル用）
mkdir -p "$ARW_DIR/null"
mkdir -p "$JPG_DIR/null"
mkdir -p "$MP4_DIR/null"

# ARWファイルを処理する関数
process_arw_files() {
  echo "ARWファイルを処理しています..."
  
  # BASE_DIR内のすべてのARWファイルを検索して処理
  find "$BASE_DIR" -type f -iname "*.ARW" -not -path "$BASE_SORTED_DIR/*" | while read -r file; do
    # exiftoolを使用して撮影日時を取得（YYYY:MM:DD HH:MM:SS形式）
    date_time=$(exiftool -s -s -s -DateTimeOriginal "$file" 2>/dev/null)
    
    if [ -n "$date_time" ]; then
      # 日付形式を変換（YYYY:MM:DD HH:MM:SS → YYYY-MM-DD_HH）
      # 秒とミリ秒を除去して時間単位にする
      folder_date=$(echo "$date_time" | sed 's/\([0-9]\{4\}\):\([0-9]\{2\}\):\([0-9]\{2\}\) \([0-9]\{2\}\):[0-9]\{2\}:[0-9]\{2\}/\1-\2-\3_\4/')
      
      # 対象ディレクトリが存在しない場合は作成
      target_dir="$ARW_DIR/$folder_date"
      if [ ! -d "$target_dir" ]; then
        mkdir -p "$target_dir"
      fi
      
      # ファイルを移動
      mv "$file" "$target_dir/"
      echo "移動しました: $file → $target_dir/"
    else
      # メタデータが見つからない場合はnullディレクトリへ
      mv "$file" "$ARW_DIR/null/"
      echo "メタデータなし: $file → $ARW_DIR/null/"
    fi
  done
}

# JPGファイルを処理する関数
process_jpg_files() {
  echo "JPGファイルを処理しています..."
  
  # BASE_DIR内のすべてのJPGファイルを検索して処理
  find "$BASE_DIR" -type f -iname "*.JPG" -not -path "$BASE_SORTED_DIR/*" | while read -r file; do
    # exiftoolを使用して撮影日時を取得
    date_time=$(exiftool -s -s -s -DateTimeOriginal "$file" 2>/dev/null)
    
    if [ -n "$date_time" ]; then
      # 日付形式を変換（時間単位）
      folder_date=$(echo "$date_time" | sed 's/\([0-9]\{4\}\):\([0-9]\{2\}\):\([0-9]\{2\}\) \([0-9]\{2\}\):[0-9]\{2\}:[0-9]\{2\}/\1-\2-\3_\4/')
      
      # 対象ディレクトリが存在しない場合は作成
      target_dir="$JPG_DIR/$folder_date"
      if [ ! -d "$target_dir" ]; then
        mkdir -p "$target_dir"
      fi
      
      # ファイルを移動
      mv "$file" "$target_dir/"
      echo "移動しました: $file → $target_dir/"
    else
      # メタデータが見つからない場合はnullディレクトリへ
      mv "$file" "$JPG_DIR/null/"
      echo "メタデータなし: $file → $JPG_DIR/null/"
    fi
  done
}

# MP4ファイルを処理する関数
process_mp4_files() {
  echo "MP4ファイルを処理しています..."
  
  # BASE_DIR内のすべてのMP4ファイルを検索して処理
  find "$BASE_DIR" -type f -iname "*.MP4" -not -path "$BASE_SORTED_DIR/*" | while read -r file; do
    # exiftoolを使用して撮影日時を取得
    date_time=$(exiftool -s -s -s -CreateDate "$file" 2>/dev/null)
    
    if [ -n "$date_time" ]; then
      # 日付形式を変換（時間単位）
      folder_date=$(echo "$date_time" | sed 's/\([0-9]\{4\}\):\([0-9]\{2\}\):\([0-9]\{2\}\) \([0-9]\{2\}\):[0-9]\{2\}:[0-9]\{2\}/\1-\2-\3_\4/')
      
      # 対象ディレクトリが存在しない場合は作成
      target_dir="$MP4_DIR/$folder_date"
      if [ ! -d "$target_dir" ]; then
        mkdir -p "$target_dir"
      fi
      
      # ファイルを移動
      mv "$file" "$target_dir/"
      echo "移動しました: $file → $target_dir/"
    else
      # メタデータが見つからない場合はnullディレクトリへ
      mv "$file" "$MP4_DIR/null/"
      echo "メタデータなし: $file → $MP4_DIR/null/"
    fi
  done
}

# 各ファイルタイプの処理を実行
process_arw_files
process_jpg_files
process_mp4_files

# 編集済みファイルを移動（元の仕様を踏襲）
echo "編集済みファイルを移動しています..."
find "$BASE_DIR" -type f -iname "*_edited*" -not -path "$EDITED_DIR/*" -exec mv {} "$EDITED_DIR/" \;

echo "処理が完了しました"
