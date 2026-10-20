#!/bin/bash

# ===== Ayarlar =====
LOG="/var/log/kurulum.log"

# ===== Bölüm 1: Root kontrolü =====
if [ "$EUID" -ne 0 ]; then
    echo "❌ Bu betik yönetici yetkisi ister."
    echo "Kullanım: sudo ./kurulum.sh"
    exit 1
fi

echo "✅ Yönetici olarak çalışıyor"

# ===== Log fonksiyonu =====                              ← YENİ
log() {
    echo "$(date '+%H:%M:%S') $1" | tee -a "$LOG"
}

log "===== Kurulum başladı ====="

# ===== Bölüm 2: Paket kurulumu =====                     ← YENİ
log "📦 Paket listesi güncelleniyor..."
apt-get update -qq

log "📦 nginx, curl, ufw kuruluyor..."
if apt-get install -y -qq nginx curl ufw; then
    log "✅ Paketler kuruldu"
else
    log "❌ Paket kurulumu başarısız"
    exit 1
fi

# ===== Bölüm 3: Web sayfası =====
SAYFA="/var/www/html/index.html"
SUNUCU=$(hostname)
IP=$(hostname -I | awk '{print $1}')
TARIH=$(date '+%d.%m.%Y %H:%M')

if [ -f "$SAYFA" ]; then
    cp "$SAYFA" "$SAYFA.yedek"
    log "💾 Eski sayfa yedeklendi: $SAYFA.yedek"
fi

cat > "$SAYFA" <<EOF
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>$SUNUCU</title>
</head>
<body>
  <h1>Merhaba Bulut! ☁️</h1>
  <p>Sunucu: $SUNUCU</p>
  <p>IP adresi: $IP</p>
  <p>Kurulum zamanı: $TARIH</p>
  <p>Bu sayfa kurulum.sh tarafından otomatik oluşturuldu.</p>
</body>
</html>
EOF

chown www-data:www-data "$SAYFA"
chmod 644 "$SAYFA"
log "🌐 Web sayfası oluşturuldu"

# ===== Bölüm 4: Güvenlik duvarı =====
ufw allow 22/tcp > /dev/null
ufw allow 80/tcp > /dev/null
ufw --force enable > /dev/null
log "🔥 Güvenlik duvarı açık (22, 80 izinli)"

# ===== Bölüm 5: nginx'i başlat =====
systemctl enable --now nginx > /dev/null 2>&1
systemctl reload nginx
log "🚀 nginx çalışıyor ve açılışta otomatik başlayacak"

# ===== Bölüm 6: Kendini test et =====
sleep 1
if curl -s localhost | grep -q "Merhaba Bulut"; then
    log "✅ TEST BAŞARILI: Site yayında → http://$IP"
else
    log "❌ TEST BAŞARISIZ: Site cevap vermiyor"
    log "   Kontrol et: systemctl status nginx / journalctl -u nginx"
    exit 1
fi

log "===== Kurulum tamamlandı ====="
