#!/bin/bash

# ユーザーに基本パスを尋ねる
echo "写真・動画の整理を行います。ベースディレクトリのパスを入力してください:"
read -r BASE_DIR

# 入力されたパスが存在するか確認
if [ ! -d "$BASE_DIR" ]; then
  echo "エラー: 指定されたディレクトリ「$BASE_DIR」は存在しません。"
  exit 1
fi

# サブディレクトリのパスを設定
ARW_DIR="${BASE_DIR}/arw"
JPG_DIR="${BASE_DIR}/jpg"
MP4_DIR="${BASE_DIR}/mp4"

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

# ARWファイルを移動
echo "ARWファイルを移動しています..."
find "$BASE_DIR" -type f -iname "*.ARW" -not -path "$ARW_DIR/*" -exec mv {} "$ARW_DIR/" \;

# JPGファイルを移動
echo "JPGファイルを移動しています..."
find "$BASE_DIR" -type f -iname "*.JPG" -not -path "$JPG_DIR/*" -exec mv {} "$JPG_DIR/" \;

# MP4ファイルを移動
echo "MP4ファイルを移動しています..."
find "$BASE_DIR" -type f -iname "*.MP4" -not -path "$MP4_DIR/*" -exec mv {} "$MP4_DIR/" \;

echo "処理が完了しました"
