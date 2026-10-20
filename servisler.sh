#!/bin/bash

LOG="/home/vboxuser/servis.log"                  # ← 1. değişiklik: $HOME yerine tam yol
ZAMAN=$(date '+%Y-%m-%d %H:%M:%S')

for SERVIS in nginx ssh cron; do
    if systemctl is-active --quiet "$SERVIS"; then
        echo "$ZAMAN ✅ $SERVIS çalışıyor" >> "$LOG"
    else
        echo "$ZAMAN ❌ $SERVIS çalışmıyor, başlatılıyor" >> "$LOG"
        systemctl start "$SERVIS"                # ← 2. değişiklik: sudo'yu sil
    fi
done
