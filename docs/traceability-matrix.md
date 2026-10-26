# Матриця трасування

Наскрізний зв'язок «вимоги → архітектура → діаграми → рішення → перевірка». Заповнюється поступово, після кожного кроку.

| ASR | Джерело (US / NFR) | Стейкхолдери | UC | Компоненти / контейнери | Діаграми | ADR | STRIDE | FF |
|---|---|---|---|---|---|---|---|---|
| ASR-01 Геолокація в реальному часі | NFR-01, NFR-03, US-04, US-15 | ST-01, ST-02, ST-03 | UC-05, UC-08 | LocationService, MatchingService | 03-usecase, 03-domain-model, 03-components, 05-seq-order-trip (фаза 4), 05-activity-trip-process | ADR-001, ADR-003, ADR-004 | TH-15…TH-20 | FF-01 |
| ASR-02 Пікові навантаження | NFR-03, NFR-02 | ST-01, ST-03, ST-09 | UC-01, UC-02, UC-05 | TripService, PricingService, MatchingService, LocationService | 03-components | ADR-001, ADR-003, ADR-008, ADR-009 | TH-13, TH-19 | FF-02, FF-03 |
| ASR-03 Доступність і стійкість | NFR-04, NFR-05, NFR-16 | ST-01, ST-03, ST-09 | UC-01 (A4, A7), UC-09 (A2), UC-11 | TripService, PaymentService, NotificationService | 03-usecase, 03-components, 05-seq-order-trip (PSP недоступний), 05-state-trip (PAYMENT_RETRY), 06-circuit-breaker | ADR-001, ADR-002, ADR-005, ADR-007 | TH-13 | FF-04 |
| ASR-04 Узгодженість «замовлення → оплата» | NFR-07, US-03, US-05, US-06, US-16 | ST-01, ST-03, ST-07, ST-09 | UC-01, UC-09, UC-10, UC-11, UC-12, UC-13, UC-14 | TripService, PaymentService, MatchingService | 03-usecase, 03-domain-model (`TripStatus`), 03-components, 05-seq-order-trip, 05-state-trip, 06-saga-orchestration, api/trip-api.yaml | ADR-002, ADR-003, ADR-009 | TH-08…TH-11 | FF-05 |
| ASR-05 Безпека водія і платежів | NFR-08, NFR-09, NFR-10, US-14, US-06 | ST-01, ST-03, ST-07, ST-10, ST-12 | UC-06, UC-13 | IdentityService, PaymentService | 03-components | ADR-006, ADR-008, ADR-009 | TH-01…TH-08, TH-12, TH-14, TH-16, TH-18, TH-20 | FF-06, FF-07 |
| ASR-06 Розширюваність партнерами | NFR-11, NFR-12, US-22, US-10 | ST-04, ST-05, ST-09 | UC-02 (тариф без релізу) | CarsharingService, PricingService | 03-domain-model (`Fleet`), 03-components | ADR-001, ADR-007, ADR-009 | TH-03, TH-08 (відповіді зовнішніх систем) | FF-03 |

## Покриття user stories

| US | Стейкхолдер | Пов'язані NFR / ASR |
|---|---|---|
| US-01 Вхід за телефоном | ST-01 | NFR-09 |
| US-02 Розрахунок вартості | ST-01 | NFR-02 |
| US-03 Замовлення таксі | ST-01 | ASR-04, NFR-02, NFR-16 |
| US-04 Відстеження водія | ST-01 | ASR-01 |
| US-05 Скасування поїздки | ST-01 | ASR-04 |
| US-06 Оплата поїздки | ST-01, ST-07 | ASR-04, ASR-05 |
| US-07 Оцінка водія | ST-01 | — |
| US-08 Історія і чек | ST-01, ST-12 | NFR-05 |
| US-09 Промокод | ST-01 | — |
| US-10 Пошук авто каршерингу | ST-02, ST-05 | ASR-06 |
| US-11 Бронювання авто | ST-02, ST-05 | ASR-06 |
| US-12 Відкриття / закриття авто | ST-02, ST-05 | ASR-03, ASR-06 |
| US-13 Завершення оренди | ST-02 | ASR-04 |
| US-14 Онбординг водія | ST-03, ST-13 | ASR-05 |
| US-15 Вихід на лінію | ST-03 | ASR-01 |
| US-16 Прийняття замовлення | ST-03 | ASR-04, NFR-10 |
| US-17 Баланс і виплати | ST-03 | NFR-07 |
| US-18 Моніторинг поїздок | ST-06 | ASR-01 |
| US-19 Ручне призначення | ST-06 | NFR-10 |
| US-20 Повернення коштів | ST-06 | ASR-04, NFR-10 |
| US-21 Керування тарифами | ST-09 | NFR-12 |
| US-22 Підключення водіїв таксопарку | ST-04 | ASR-06 |

## US → UC → компонент

Заповнено на кроці 3. UC-01…UC-14 описано в [03-uml-models.md](03-uml-models.md). Каршеринг-сценарії (US-10…US-13) і онбординг (US-14) мають окремі UC на наступних кроках; тут вказано лише відповідний компонент.

| US | UC | Bounded context | Компонент |
|---|---|---|---|
| US-01 Вхід за телефоном | — | BC-06 | IdentityService |
| US-02 Розрахунок вартості | UC-02, UC-03 | BC-04, BC-01 | PricingService, TripService |
| US-03 Замовлення таксі | UC-01, UC-05 | BC-01, BC-02 | TripService, MatchingService |
| US-04 Відстеження водія | UC-08 | BC-03 | LocationService |
| US-05 Скасування поїздки | UC-09, UC-10 | BC-01, BC-05 | TripService, PaymentService |
| US-06 Оплата поїздки | UC-11, UC-12, UC-13, UC-14 | BC-05 | PaymentService |
| US-07 Оцінка водія | — | BC-01 | TripService (`Rating`) |
| US-08 Історія і чек | — | BC-01, BC-05 | TripService, PaymentService (`Receipt`) |
| US-09 Промокод | UC-04 | BC-04 | PricingService |
| US-10 Пошук авто | — | BC-07, BC-03 | CarsharingService |
| US-11 Бронювання | — | BC-07 | CarsharingService |
| US-12 Відкриття / закриття | — | BC-07 | CarsharingService |
| US-13 Завершення оренди | — | BC-07, BC-05 | CarsharingService, PaymentService |
| US-14 Онбординг водія | — | BC-06 | IdentityService |
| US-15 Вихід на лінію | UC-08 | BC-02, BC-03 | MatchingService, LocationService |
| US-16 Прийняття замовлення | UC-05, UC-07 | BC-02 | MatchingService |
| US-17 Баланс і виплати | UC-14 | BC-05 | PaymentService |
| US-18 Моніторинг поїздок | — | BC-01, BC-02 | TripService, MatchingService (консоль диспетчера — контейнер, крок 4) |
| US-19 Ручне призначення | UC-06 | BC-02 | MatchingService |
| US-20 Повернення коштів | — | BC-05 | PaymentService |
| US-21 Керування тарифами | UC-02 | BC-04 | PricingService |
| US-22 Підключення водіїв таксопарку | — | BC-07, BC-06 | CarsharingService (`Fleet`), IdentityService |

## ASR → стиль → контейнери

Заповнено на кроці 4. Рішення про стиль: мікросервіси + event-driven ([04-architecture-style-c4.md](04-architecture-style-c4.md), ADR-001 на кроці 7).

| ASR | Внесок у вибір стилю | Контейнери C4 (CT-xx) | Діаграми |
|---|---|---|---|
| ASR-01 | Окремий Location зі своїм сховищем; WebSocket замість опитування | CT-02 Driver App, CT-08 Location, CT-07 Matching, CT-13 Kafka | 04-c4-container |
| ASR-02 | Незалежне масштабування Matching / Location / Pricing; Kafka як буфер | CT-04 Gateway, CT-06…CT-09, CT-13 | 04-c4-container |
| ASR-03 | Ізоляція відмов, CB + Retry навколо PSP, асинхронні сповіщення | CT-06 Trip, CT-10 Payment, CT-12 Notification | 04-c4-container |
| ASR-04 | Ціна мікросервісів: Saga + Outbox замість ACID | CT-06 Trip, CT-10 Payment, CT-07 Matching, CT-13 Kafka | 04-c4-container |
| ASR-05 | Виділений Identity і платіжний контур, межі довіри | CT-05 Identity, CT-10 Payment, CT-04 Gateway | 04-c4-context, 04-c4-container |
| ASR-06 | Адаптери партнерів, стабільні внутрішні контракти | CT-11 Carsharing, CT-04 Gateway | 04-c4-container |

## ASR → інтеграції та патерни стійкості

Заповнено на кроці 6 ([06-distributed-integration.md](06-distributed-integration.md)).

| ASR | Інтеграції | Патерни / механізми | Діаграми, контракти |
|---|---|---|---|
| ASR-01 | INT-04 (Matching → Location, gRPC), INT-05 (геопотік, WebSocket → Kafka) | Асинхронний потік, буферизація на клієнті | 05-seq-order-trip (фаза 4) |
| ASR-02 | INT-02 (Pricing, gRPC), INT-06 (пошук через Kafka) | Kafka як буфер сплесків, stateless-сервіси | 05-seq-order-trip |
| ASR-03 | INT-01 (Maps), INT-03 (PSP), INT-07…INT-09 | Circuit Breaker «psp» і «maps», Retry з експоненційною затримкою і jitter, Bulkhead, fallback `PENDING_RETRY` | 06-circuit-breaker |
| ASR-04 | INT-03, INT-06, INT-07, INT-08 | Оркестраційна Saga (S1–S5, C1–C4), Transactional Outbox, ідемпотентні споживачі, `Idempotency-Key`, звірка з PSP | 06-saga-orchestration, api/trip-api.yaml |
| ASR-05 | INT-08 (webhook з HMAC) | JWT на Gateway, перевірка власника поїздки, підпис webhook-ів | api/trip-api.yaml |
| ASR-06 | — | Стабільний внутрішній контракт (OpenAPI, `.proto`), версіонування `/v1` | api/trip-api.yaml |

## ADR → ASR → діаграми

Заповнено на кроці 7. Реєстр — [07-adr/index.md](07-adr/index.md).

| ADR | Рішення | ASR | Де видно рішення |
|---|---|---|---|
| ADR-001 | Мікросервіси + event-driven | ASR-01, 02, 03, 06 | 04-c4-container, розділ 4.1 |
| ADR-002 | Eventual consistency, Saga, Outbox | ASR-04, 03 | 06-saga-orchestration, 05-state-trip, 05-seq-order-trip |
| ADR-003 | Kafka | ASR-01, 02, 04 | 04-c4-container (CT-13), топіки в 4.4 |
| ADR-004 | Redis GEO + WebSocket | ASR-01, 02 | 04-c4-container (CT-08), 05-seq-order-trip (фаза 4) |
| ADR-005 | CB + Retry для PSP | ASR-03, 04 | 06-circuit-breaker, 05-seq-order-trip (PSP недоступний) |
| ADR-006 | OAuth2/OIDC + пристрій + MFA | ASR-05 | 04-c4-container (CT-05) |
| ADR-007 | Adapter для партнерів | ASR-06, 03 | 03-components (зовнішні інтерфейси), 04-c4-container |
| ADR-008 | API Gateway | ASR-02, 05 | 04-c4-container (CT-04) |
| ADR-009 | Database-per-service | ASR-02, 05, 06 | 04-c4-container (сховища), 03-domain-model (BC) |

## Патерни та міграція

Заповнено на кроці 8 ([08-antipattern-migration.md](08-antipattern-migration.md)).

| Проблема легасі | Патерн / підхід | ASR / NFR | ADR | Діаграма |
|---|---|---|---|---|
| `if/else` тарифів у `TripManager` | Strategy (`PricingStrategy`), тарифи як дані `Tariff` | NFR-12, US-21 | ADR-001 | 08-class-after |
| Комбінації нічного тарифу, surge, промокоду | Decorator (`PricingDecorator`) | NFR-12, US-09 | — | 08-class-after |
| Прямі виклики SDK PSP, карт, push | Adapter | ASR-06, NFR-11 | ADR-007 | 08-class-after |
| Збої PSP в бізнес-коді | Decorator `ResilientPaymentGateway` (CB + Retry) | ASR-03, NFR-05 | ADR-005 | 08-class-after, 06-circuit-breaker |
| Прямі виклики сповіщень при зміні статусу | Observer (`TripStatusListener`, Kafka `trip.status.changed`) | ASR-03, NFR-05 | ADR-003 | 08-class-after |
| God Object керує процесом | Оркестратор Saga + `TripStateMachine` | ASR-04 | ADR-002 | 08-class-after, 06-saga-orchestration |
| Спільна БД легасі | Database-per-service, поетапна передача володіння | ASR-02, NFR-12 | ADR-009 | 08-strangler-fig |
| Міграція без «великого вибуху» | Strangler Fig (E1…E7) | ASR-01, ASR-02, ASR-04 | ADR-001, ADR-008 | 08-strangler-fig |

## Загрози і fitness functions

Заповнено на кроці 9 ([09-stride-fitness.md](09-stride-fitness.md)).

| Точка | Загрози | ASR | Контрзаходи (ADR) | Fitness functions |
|---|---|---|---|---|
| Автентифікація водія | TH-01…TH-07 | ASR-05 | ADR-006, ADR-008 | FF-06, FF-07 |
| Обробка платежу | TH-08…TH-14 | ASR-04, ASR-05, ASR-03 | ADR-002, ADR-005, ADR-008 | FF-05, FF-06, FF-04 |
| Потік геолокації | TH-15…TH-20 | ASR-01, ASR-02 | ADR-004, ADR-008 | FF-01, FF-02, FF-03, FF-07 |

| FF | Що перевіряє | ASR | Захищає рішення |
|---|---|---|---|
| FF-01 | Затримка геопозиції ≤ 2 с | ASR-01 | ADR-004 |
| FF-02 | 10× пік | ASR-02 | ADR-001, ADR-003 |
| FF-03 | Відповідність архітектурі | ASR-06, ASR-02 | ADR-007, ADR-009 |
| FF-04 | Chaos: відмова PSP / Maps | ASR-03 | ADR-005 |
| FF-05 | Узгодженість, ідемпотентність | ASR-04 | ADR-002 |
| FF-06 | SAST/DAST, залежності, відсутність PAN | ASR-05 | ADR-006, NFR-09 |
| FF-07 | Негативні сценарії автентифікації | ASR-05 | ADR-006 |
