# 7. Журнал ADR

> Технічна вимога №7 · Напрям 3 — журнал ADR

Кожне рішення записуємо в окремий файл `ADR-NNN-<коротка-назва>.md` за [шаблоном](template.md). Усі записи мають ≥ 2 розглянуті альтернативи, явні позитивні та негативні наслідки, посилання на ASR і діаграми.

## Реєстр

| ID | Рішення | Статус | Дата | Пов'язані ASR | Ключові альтернативи |
|---|---|---|---|---|---|
| [ADR-001](ADR-001-microservices-event-driven.md) | Мікросервісна подієво-орієнтована архітектура | Accepted | 2026-10-26 | ASR-01, 02, 03, 06 | моноліт, модульний моноліт, SOA |
| [ADR-002](ADR-002-eventual-consistency-saga-outbox.md) | Eventual consistency + оркестраційна Saga + Outbox | Accepted | 2026-10-26 | ASR-04, 03 | 2PC / XA, хореографічна Saga |
| [ADR-003](ADR-003-kafka-event-broker.md) | Apache Kafka як брокер подій | Accepted | 2026-10-26 | ASR-01, 02, 04 | RabbitMQ, Redis Streams |
| [ADR-004](ADR-004-geolocation-redis-websocket.md) | Геолокація: Redis GEO + WebSocket push | Accepted | 2026-10-26 | ASR-01, 02 | PostGIS, polling |
| [ADR-005](ADR-005-circuit-breaker-retry-psp.md) | Circuit Breaker + Retry з експоненційною затримкою для PSP | Accepted | 2026-10-26 | ASR-03, 04 | лише таймаути, лише Retry, повністю асинхронні виклики, retry у service mesh |
| [ADR-006](ADR-006-driver-authentication.md) | Автентифікація водіїв: OAuth2/OIDC + прив'язка пристрою + MFA | Accepted | 2026-10-26 | ASR-05 | пароль, лише SMS-OTP, власна автентифікація в сервісах |
| [ADR-007](ADR-007-adapters-for-partners.md) | Адаптери (GoF Adapter) для партнерів і зовнішніх систем | Accepted | 2026-10-26 | ASR-06, 03 | прямі виклики SDK, ESB, сервіс на партнера |
| [ADR-008](ADR-008-api-gateway.md) | API Gateway (Kong) як єдина точка входу | Accepted | 2026-10-26 | ASR-02, 05 | без Gateway, BFF на клієнта, лише service mesh |
| [ADR-009](ADR-009-database-per-service.md) | Database-per-service | Accepted | 2026-10-26 | ASR-02, 05, 06 | спільна БД, спільний інстанс з окремими схемами |

## Залежності між рішеннями

```
ADR-001 (мікросервіси + events)
 ├─ ADR-002 (Saga + Outbox)  ── ADR-005 (CB + Retry для PSP)
 ├─ ADR-003 (Kafka)          ── ADR-004 (Redis GEO + WebSocket)
 ├─ ADR-008 (API Gateway)    ── ADR-006 (автентифікація)
 ├─ ADR-009 (database-per-service)
 └─ ADR-007 (адаптери партнерів)
```

## Статуси

`Proposed` → `Accepted` → `Deprecated` або `Superseded by ADR-NNN`. Змінене рішення не переписуємо, а замінюємо новим ADR, а в старому ставимо `Superseded`.
