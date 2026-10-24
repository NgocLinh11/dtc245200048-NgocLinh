# 🍜 Website Công Thức Nấu Ăn / Recipe

**Đề tài:** Đề 29 – Website Công thức Nấu ăn / Recipe
**Sinh viên thực hiện:** Nguyễn Ngọc Linh
**Mã số sinh viên (MSSV):** DTC245200048

## 1. Tổng quan đề tài

Website Công thức Nấu ăn / Recipe là hệ thống cho phép người dùng chia sẻ, khám phá
các công thức nấu ăn (món ăn, nguyên liệu, danh mục). Theo yêu cầu của đề tài
Triển khai và Quản trị Hệ thống Phần mềm (Mã đề 29), hệ thống được triển khai
bằng Docker Compose và áp dụng đầy đủ các yêu cầu:

1. Quản lý toàn bộ mã nguồn và file cấu hình trên GitHub (commit rõ ràng, có README).
2. Triển khai ứng dụng web, tích hợp Database và công cụ quản lý DB (MySQL + phpMyAdmin).
3. Cấu hình Nginx làm reverse proxy (có HTTPS tự ký hoặc security headers cơ bản).
4. Tích hợp Prometheus + Grafana để giám sát container, web server và database.
5. Triển khai hệ thống log tập trung Loki + Promtail, truy vấn log bằng LogQL.
6. Áp dụng các biện pháp hardening: non-root container, network isolation, mật khẩu mạnh, ...

## 2. Công nghệ sử dụng

- **Website:** HTML/CSS/JavaScript (Bootstrap 5) – Nginx phục vụ file tĩnh.
- **Database:** MySQL 8.0 + phpMyAdmin.
- **Reverse Proxy / TLS:** Nginx (có HTTPS self-signed, security headers).
- **Monitoring:** Prometheus + Grafana (+ MySQL Exporter).
- **Logging:** Loki + Promtail (+ LogQL).
- **Triển khai:** Docker + Docker Compose.

## 3. Yêu cầu môi trường

- Docker Engine & Docker Compose.
- Git.
- OpenSSL (để tạo SSL certificate self-signed).

## 4. Cấu trúc repository

```
cong-thuc-nau-an/
├── index.html                  # Trang chủ: banner, danh sách món ăn nổi bật
├── detail.html                 # Trang chi tiết công thức nấu ăn
├── Dockerfile                  # Docker image cho website (nginx)
├── docker-compose.yml          # Định nghĩa toàn bộ hệ thống
├── .env.example                # File mẫu các biến môi trường
├── .gitignore                  # Bỏ qua dữ liệu docker, cert
├── nginx/
│   ├── nginx.conf             # Cấu hình Nginx chính (reverse proxy)
│   ├── conf.d/
│   │   ├── web.conf           # Config server cho container web (port 8080)
│   │   └── reverse-proxy.conf # Config reverse proxy 80/443 -> web
│   └── certs/                 # SSL certificate (tao tu beat)
└── monitoring/
    ├── prometheus/
    │   └── prometheus.yml     # Cấu hình Prometheus scrape
    ├── grafana/
    │   ├── provisioning/      # Datasource + Dashboard provider
    │   └── dashboards/
    │       └── recipe-dashboard.json
    ├── loki/
    │   └── loki-config.yml
    └── promtail/
        └── promtail-config.yml
```

## 5. Hướng dẫn chạy

### Bước 1: Tao file môi trường

```bash
cp .env.example .env
```

### Bước 2: Tao SSL certificate self-signed

```bash
mkdir -p nginx/certs
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout nginx/certs/self-signed.key \
  -out nginx/certs/self-signed.crt \
  -subj "/CN=localhost"
```

### Bước 3: Khởi động toàn bộ hệ thống

```bash
docker compose up -d
```

### Bước 4: Kiem tra

- Website: <https://localhost> (accept the self-signed cert warning).
- phpMyAdmin: <http://localhost:8081>
- Grafana: <http://localhost:3000> (admin / grafana_admin_password_de_dai)
- Prometheus: <http://localhost:9091>

## 6. Cấu hình Nginx Reverse Proxy

- Container `nginx-proxy` (port 80/443) nhận request, `proxy_pass` sang service
  `recipe-web:8080` (container nginx serving website tĩnh).
- Môi đoạn HTTPS (443) suy ra TLS voi SSL certificate self-signed.
- Security headers: `X-Frame-Options`, `X-Content-Type-Options`, `X-XSS-Protection`,
  `Referrer-Policy`, `Content-Security-Policy`.

## 7. Giám sát với Prometheus + Grafana

- Prometheus scrape `recipe-web:8080/stub_status`, `nginx-proxy:80/stub_status` và
  MySQL exporter.
- Grafana tuỳ chỉnh datasource Prometheus da duoc cấu hình tu dong qua provisioning.

## 8. Log tập trung Loki + Promtail (LogQL)

- Promtail doc log tu Docker container (`logging=pstdout`) dua ve Loki.
- Cac truy van LogQL can thu thap:

```
{job="nginx"} |= "HTTP/1.1" 5"
{job="webapp"} |~ "(ERROR|Exception|Failed)"
```

## 9. Hardening

- Container web chạy voi vai tro non-root (`nginx-unprivileged`).
- Phân tách network nội bộ (`frontend`, `backend`).
- Mật khẩu mạnh qua biến môi trường `.env`.
- Security headers Nginx, non-root container, network isolation.

## 10. Quy trình Git / GitHub (3 commits)

1. **Commit 1:** Triển khai ứng dụng web + Database + phpMyAdmin + Nginx reverse proxy.
2. **Commit 2:** Tích hợp Prometheus + Grafana.
3. **Commit 3:** Tích hợp Loki + Promtail + Hardening.

## 11. Viết báo cáo

Báo cáo được thực hiện theo file mẫu `Bao_Cao_Trien_Khai_He_Thong.docx` (Báo cáo Bài tập
lớn Triển khai và Quản trị Hệ thống Phần mềm).

---

Chi tiết triển khai: xem chương 1 – 4 trong báo cáo.
