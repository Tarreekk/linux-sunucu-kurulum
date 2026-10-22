# Linux Sunucu Kurulum Betikleri

Boş bir Ubuntu sunucusunu **tek komutla** çalışan bir nginx web sunucusuna çeviren Bash betikleri.
Kurulum, güvenlik duvarı, servis izleme ve kendi kendini test etme dahil.

## Ne yapar?

`kurulum.sh` sırasıyla:

1. Yönetici (root) yetkisini kontrol eder
2. nginx, curl ve ufw paketlerini kurar
3. Sunucu adı, IP ve kurulum zamanını gösteren bir web sayfası oluşturur (eski sayfayı yedekler)
4. Güvenlik duvarını açar (sadece 22/SSH ve 80/HTTP izinli)
5. nginx'i başlatır ve açılışta otomatik başlamasını sağlar
6. `curl` ile siteyi test eder; başarısızsa hata verip durur

Her adım zaman damgasıyla `/var/log/kurulum.log` dosyasına yazılır.

## Dosyalar

| Dosya | Görevi |
|---|---|
| `kurulum.sh` | Sunucuyu sıfırdan kurar ve test eder |
| `servisler.sh` | nginx, ssh, cron servislerini kontrol eder; duranı yeniden başlatır (cron ile 5 dakikada bir) |
| `disk.sh` | Disk doluluğunu NORMAL / UYARI / KRİTİK olarak raporlar |

## Kullanım

```bash
git clone https://github.com/Tarreekk/linux-sunucu-kurulum.git
cd linux-sunucu-kurulum
sudo ./kurulum.sh
```

Servis izlemeyi otomatik çalıştırmak için (`sudo crontab -e`):

```
*/5 * * * * /tam/yol/servisler.sh
```

## Örnek çıktı

```
18:34:26 ===== Kurulum başladı =====
18:34:27 ✅ Paketler kuruldu
18:34:27 🌐 Web sayfası oluşturuldu
18:34:27 🔥 Güvenlik duvarı açık (22, 80 izinli)
18:34:28 🚀 nginx çalışıyor ve açılışta otomatik başlayacak
18:34:29 ✅ TEST BAŞARILI: Site yayında → http://10.0.2.15
18:34:29 ===== Kurulum tamamlandı =====
```

## Test edildi

- Ubuntu (VirtualBox)
- nginx tamamen silindikten (`apt purge`) sonra sıfırdan kurulum başarılı

## Kullanılan teknikler

Bash · systemctl · ufw · cron · heredoc · log fonksiyonu (`tee -a`) · çıkış kodları ile hata yönetimi

## Yazar

Tarık Gökçe · Bilgisayar Mühendisliği

