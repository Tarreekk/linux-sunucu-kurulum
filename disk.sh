#!/bin/bash

DOLULUK=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

if [ -z "$DOLULUK" ]; then
    echo "Kullanım: ./disk.sh SAYI"
elif [ "$DOLULUK" -ge 90 ]; then
    echo "🔴 KRİTİK: Disk %$DOLULUK dolu!"
elif [ "$DOLULUK" -ge 70 ]; then
    echo "🟡 UYARI: Disk %$DOLULUK dolu"
else
    echo "🟢 NORMAL: Disk %$DOLULUK dolu"
fi
