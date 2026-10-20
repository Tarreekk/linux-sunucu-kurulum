#!/bin/bash

DOLULUK=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

if [ -z "$DOLULUK" ]; then
    echo "❌ Disk bilgisi okunamadı"
    exit 1
elif [ "$DOLULUK" -ge 90 ]; then
    echo "🔴 KRİTİK: Disk %$DOLULUK dolu!"
    echo "En çok yer kaplayan klasörler:"
    du -sh /var/* 2>/dev/null | sort -rh | head -5
elif [ "$DOLULUK" -ge 70 ]; then
    echo "🟡 UYARI: Disk %$DOLULUK dolu"
else
    echo "🟢 NORMAL: Disk %$DOLULUK dolu"
fi
