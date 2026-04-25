# Aura Health API Documentation

Base URL: `http://localhost:3000/api`

## Response Format
```json
{
  "success": true,
  "message": "string",
  "data": {}
}
```

---

## AUTH `/api/auth`

| Method | Endpoint | Auth | Body | Description |
|--------|----------|------|------|-------------|
| POST | `/register` | - | `{ name, email, password }` | Daftar akun |
| POST | `/login` | - | `{ email, password }` | Login |
| POST | `/refresh` | - | `{ refreshToken }` | Perbarui access token |
| POST | `/logout` | Bearer | - | Logout + blacklist token |
| POST | `/otp/request` | - | `{ email }` | Request OTP |
| POST | `/otp/verify` | - | `{ email, otp }` | Verifikasi OTP |

---

## USERS `/api/users`

| Method | Endpoint | Auth | Body/Params | Description |
|--------|----------|------|-------------|-------------|
| GET | `/me` | Bearer | - | Profil saya |
| PUT | `/me` | Bearer | `{ name?, bio? }` | Update profil |
| POST | `/me/avatar` | Bearer | `form-data: avatar` | Upload avatar |
| GET | `/:userId` | Bearer | - | Profil publik user |

---

## ARTICLES `/api/articles`

| Method | Endpoint | Auth | Query | Description |
|--------|----------|------|-------|-------------|
| GET | `/` | - | `?page&limit&category` | List artikel |
| GET | `/categories` | - | - | Daftar kategori |
| GET | `/:id` | - | - | Detail artikel |

---

## EDUCATION `/api/education`

| Method | Endpoint | Auth | Params | Description |
|--------|----------|------|--------|-------------|
| GET | `/categories` | - | - | Kategori edukasi |
| GET | `/category/:category` | - | - | Konten per kategori |
| GET | `/:id` | - | - | Detail konten |

---

## COMMUNITY POSTS `/api/posts`

| Method | Endpoint | Auth | Body | Description |
|--------|----------|------|------|-------------|
| GET | `/` | - | `?page&limit` | Feed semua post |
| GET | `/:id` | - | - | Detail post |
| POST | `/` | Bearer | `form-data: content, image?` | Buat post |
| DELETE | `/:id` | Bearer | - | Hapus post |
| POST | `/:id/like` | Bearer | - | Like/unlike post |
| GET | `/:id/comments` | - | `?page&limit` | Komentar post |
| POST | `/:id/comments` | Bearer | `{ comment }` | Tambah komentar |
| DELETE | `/:id/comments/:commentId` | Bearer | - | Hapus komentar |

---

## CHATBOT AI `/api/chat`

> Hanya menjawab topik TBC. Dilindungi 3 layer security.

| Method | Endpoint | Auth | Body | Description |
|--------|----------|------|------|-------------|
| POST | `/` | Bearer | `{ message }` | Kirim pesan ke AI |
| GET | `/history` | Bearer | `?page&limit` | Riwayat chat |
| DELETE | `/history` | Bearer | - | Hapus riwayat |

**Rate limit:** 20 req/menit per user

---

## NOTIFICATIONS `/api/notifications`

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/` | Bearer | Semua notifikasi |
| PATCH | `/read-all` | Bearer | Tandai semua dibaca |
| PATCH | `/:id/read` | Bearer | Tandai satu dibaca |

---

## Health Check

```
GET /health
```

---

## Error Codes

| Code | Meaning |
|------|---------|
| 400 | Bad Request / Validation Error |
| 401 | Unauthorized (token invalid/expired) |
| 403 | Forbidden (bukan pemilik resource) |
| 404 | Not Found |
| 409 | Conflict (data duplikat) |
| 429 | Too Many Requests |
| 500 | Internal Server Error |

---

## Authentication

Gunakan Bearer Token di header:
```
Authorization: Bearer <accessToken>
```

Access Token expire: **15 menit**
Refresh Token expire: **7 hari**
