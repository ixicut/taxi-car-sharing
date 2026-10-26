# Матриця трасування

Наскрізний зв'язок «вимоги → архітектура → діаграми → рішення → перевірка». Заповнюється поступово, після кожного кроку.

| ASR | Джерело (US / NFR) | Стейкхолдери | UC | Компоненти / контейнери | Діаграми | ADR | STRIDE | FF |
|---|---|---|---|---|---|---|---|---|
| ASR-01 Геолокація в реальному часі | NFR-01, NFR-03, US-04, US-15 | ST-01, ST-02, ST-03 | UC-05, UC-08 | LocationService, MatchingService | 03-usecase, 03-domain-model, 03-components, 04-c4-container, 05-seq-order-trip (фаза 4), 05-activity-trip-process, 09-dfd-geolocation | ADR-001, ADR-003, ADR-004 | TH-15…TH-20 | FF-01 |
| ASR-02 Пікові навантаження | NFR-03, NFR-02 | ST-01, ST-03, ST-09 | UC-01, UC-02, UC-05 | TripService, PricingService, MatchingService, LocationService | 03-components, 04-c4-container, 05-seq-order-trip, 08-strangler-fig | ADR-001, ADR-003, ADR-008, ADR-009 | TH-13, TH-19 | FF-02, FF-03 |
| ASR-03 Доступність і стійкість | NFR-04, NFR-05, NFR-16 | ST-01, ST-03, ST-09 | UC-01 (A4, A7), UC-09 (A2), UC-11 | TripService, PaymentService, NotificationService | 03-usecase, 03-components, 05-seq-order-trip (PSP недоступний), 05-state-trip (PAYMENT_RETRY), 06-circuit-breaker | ADR-001, ADR-002, ADR-005, ADR-007 | TH-13 | FF-04 |
| ASR-04 Узгодженість «замовлення → оплата» | NFR-07, US-03, US-05, US-06, US-16 | ST-01, ST-03, ST-07, ST-09 | UC-01, UC-09, UC-10, UC-11, UC-12, UC-13, UC-14 | TripService, PaymentService, MatchingService | 03-usecase, 03-domain-model (`TripStatus`), 03-components, 05-seq-order-trip, 05-state-trip, 06-saga-orchestration, api/trip-api.yaml | ADR-002, ADR-003, ADR-009 | TH-08…TH-11 | FF-05 |
| ASR-05 Безпека водія і платежів | NFR-08, NFR-09, NFR-10, US-14, US-06 | ST-01, ST-03, ST-07, ST-10, ST-12 | UC-06, UC-13, UC-19 | IdentityService, PaymentService | 03-components, 03-usecase-carsharing-onboarding, 09-dfd-driver-auth, 09-dfd-payment | ADR-006, ADR-008, ADR-009 | TH-01…TH-08, TH-12, TH-14, TH-16, TH-18, TH-20 | FF-06, FF-07 |
| ASR-06 Розширюваність партнерами | NFR-11, NFR-12, US-22, US-10 | ST-04, ST-05, ST-09 | UC-02 (тариф без релізу), UC-15…UC-18, UC-20 | CarsharingService, PricingService | 03-domain-model (`Fleet`), 03-components, 03-usecase-carsharing-onboarding, 08-class-after (Adapter, Strategy) | ADR-001, ADR-007, ADR-009 | TH-03, TH-08 (відповіді зовнішніх систем) | FF-03 |

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

Заповнено на кроці 3, доповнено на кроці 10. UC-01…UC-14 (замовлення таксі) і UC-15…UC-20 (каршеринг, онбординг, партнери) описано в [03-uml-models.md](03-uml-models.md).

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
| US-10 Пошук авто | UC-15 | BC-07, BC-03 | CarsharingService |
| US-11 Бронювання | UC-16, UC-12 | BC-07, BC-05 | CarsharingService, PaymentService |
| US-12 Відкриття / закриття | UC-17 | BC-07 | CarsharingService |
| US-13 Завершення оренди | UC-18, UC-02, UC-11 | BC-07, BC-04, BC-05 | CarsharingService, PricingService, PaymentService |
| US-14 Онбординг водія | UC-19 | BC-06 | IdentityService |
| US-15 Вихід на лінію | UC-08 | BC-02, BC-03 | MatchingService, LocationService |
| US-16 Прийняття замовлення | UC-05, UC-07 | BC-02 | MatchingService |
| US-17 Баланс і виплати | UC-14 | BC-05 | PaymentService |
| US-18 Моніторинг поїздок | — | BC-01, BC-02 | TripService, MatchingService (консоль диспетчера — контейнер, крок 4) |
| US-19 Ручне призначення | UC-06 | BC-02 | MatchingService |
| US-20 Повернення коштів | — | BC-05 | PaymentService |
| US-21 Керування тарифами | UC-02 | BC-04 | PricingService |
| US-22 Підключення водіїв таксопарку | UC-20 | BC-07, BC-06 | CarsharingService (`Fleet`), IdentityService |

## ASR → стиль → контейнери

Заповнено на кроці 4. Рішення про стиль: мікросервіси + event-driven ([04-architecture-style-c4.md](04-architecture-style-c4.md), [ADR-001](07-adr/ADR-001-microservices-event-driven.md)).

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

## Крок 10. Перевірка повноти

Шукаємо «сиріт»: елементи, які не ведуть ні до чого або до яких не веде ніщо.

| Перевірка | Результат | Деталі |
|---|---|---|
| Кожна ASR має ADR | ✅ 6 / 6 | ASR-01 → ADR-001, 003, 004; ASR-02 → ADR-001, 003, 008, 009; ASR-03 → ADR-001, 002, 005, 007; ASR-04 → ADR-002, 003, 009; ASR-05 → ADR-006, 008, 009; ASR-06 → ADR-001, 007, 009 |
| Кожна ASR має fitness function | ✅ 6 / 6 | ASR-01 → FF-01; ASR-02 → FF-02, FF-03; ASR-03 → FF-04; ASR-04 → FF-05; ASR-05 → FF-06, FF-07; ASR-06 → FF-03 |
| Кожна ASR видна на діаграмах | ✅ 6 / 6 | Колонка «Діаграми» в першій таблиці |
| Кожна ASR пов'язана з NFR / US і стейкхолдером | ✅ 6 / 6 | Розділ 2.3 |
| Кожен ADR спирається на ASR і має ≥ 2 альтернативи | ✅ 9 / 9 | [Реєстр ADR](07-adr/index.md) |
| Кожна fitness function прив'язана до ASR і автоматизована | ✅ 7 / 7 | Розділ 9.3: інструмент, місце запуску, дія при провалі |
| Кожна загроза STRIDE має контрзахід | ✅ 20 / 20 | 0 високих залишкових ризиків |
| Кожна US має стейкхолдера і компонент | ✅ 22 / 22 | Таблиці «Покриття user stories» і «US → UC → компонент» |
| Кожна US має use case | ⚠️ 17 / 22 | Без UC: US-01 (вхід), US-07 (оцінка), US-08 (історія і чек), US-18 (моніторинг), US-20 (повернення коштів). Це прості CRUD- або консольні сценарії поза темою «замовлення поїздки»; вони покриті компонентом і ADR (US-01 → ADR-006, US-18 / US-20 → NFR-10, аудит) |
| Кожна сутність доменної моделі має use case | ⚠️ 21 / 22 | Після додавання UC-15…UC-20 на кроці 10. Без UC лишається `Rating` (US-07, оцінка після поїздки): простий сценарій поза замовленням, покритий TripService і зв'язком `TaxiTrip — Rating` |
| Кожен bounded context → один компонент → один контейнер | ✅ 8 / 8 | BC-01…BC-08 → 8 компонентів → CT-05…CT-12 |
| Кожен контейнер обґрунтований ASR або US | ✅ 13 / 13 | Колонка «ASR» у таблиці контейнерів (розділ 4.4) |
| Кожна інтеграція 6.1 — стрілка на C4 Container | ✅ 9 / 9 | INT-01…INT-09 |
| Кожна діаграма має джерело `.puml` і показана в документі | ✅ 18 / 18 | Перевірено скриптом: посилання `rendered/*.png` ↔ `diagrams/*.puml` ↔ `@startuml <name>` |
| Відносні посилання в Markdown | ✅ | Немає битих посилань (без урахування ще не згенерованих зображень) |

## Крок 10. Перевірка узгодженості назв і значень

Одні й ті самі речі мають однакові назви в усіх розділах.

| Що | Де використовується | Результат |
|---|---|---|
| Статуси поїздки `TripStatus` (12) | Доменна модель (3.2) · діаграма станів T-01…T-22 (5.3) · послідовність і діяльність (5.1, 5.2) · Saga (6.3) · OpenAPI `TripStatus` · `TripStateMachine` (8.2) | ✅ збігаються літера в літеру |
| Статуси платежу `PaymentStatus` (8) | Доменна модель · 6.3 · OpenAPI `paymentStatus` · fallback CB (6.4) · DFD 2 | ✅ |
| Статуси оренди `RentalStatus` (5) | Доменна модель · UC-15…UC-18 | ✅ |
| Сервіси | Компоненти (3.4) · контейнери CT-xx (4.4) · учасники послідовності (5.1) · Saga (6.3) · клас «після» (8.2) · Strangler Fig (8.3) · DFD (9.1) | ✅ `TripService` / Trip Service тощо, один сервіс на BC |
| Топіки Kafka | 4.4 · 5.1 · 6.1 · 6.3 · ADR-003 · 8.2 (Observer) · DFD | ✅ нових топіків поза 4.4 немає |
| Підписка Matching на `trip.status.changed` | C4 Container · 4.4 · 6.3 (компенсація C3/C4) · ADR-002 · 8.2 | ✅ |
| Параметри Circuit Breaker і Retry | 6.4 · ADR-005 · `06-circuit-breaker` · FF-04 | ✅ вікно 20, поріг 50 %, slow 1 с / 60 %, OPEN 30 с, HALF_OPEN 3; профілі interactive (3 / 200 мс / 1,2 с) і background (5 / 500 мс / 3 с) |
| Кроки Saga S1–S5, компенсації C1–C4, pivot | 5.3 · 6.3 · `06-saga-orchestration` · ADR-002 | ✅ |
| Пороги | NFR (2.2) · ASR-сценарії (2.3) · UC · діаграми · FF (9.3) | ✅ 2 с, 3 с, 15 с, 3 хв, 2 хв, 200 м, 10×, 99,9 %, ≤ 5 хв, ≤ 30 с |
| Ідемпотентні ключі | 5.1 · 6.2 · 6.3 · ADR-002 · TH-10 · FF-05 | ✅ клієнтський `Idempotency-Key` для hold; `{tripId}:{operation}` для capture / release / refund |
| Нумерація fitness functions | 4, 6, ADR-001/002/005/007/009, 8, 9 | ✅ `FF-0N` |
| Зовнішні провайдери | 1.2 · C4 Context · 6.1 · ADR-007 · 8.2 | ✅ LiqPay / WayForPay, Google Maps / Visicom, «Дія», FCM / APNs / SMS, ПРРО |

## Крок 10. Що виправлено під час зведення

| # | Де | Було | Стало | Чому |
|---|---|---|---|---|
| 1 | 3.1, `03-usecase-carsharing-onboarding` | Каршеринг і онбординг «будуть на наступних кроках»; `Fleet`, `Vehicle`, `SharingCar`, `CarsharingRental`, `DriverDocument` без UC | Додано UC-15…UC-20 і другу use-case діаграму, повторно використано UC-02, UC-11, UC-12, UC-13 | Критерій оцінювання №2: доменна модель має відповідати use-case моделі |
| 2 | ADR-004, DFD 3 | «Кожен ключ має TTL» для позицій у Redis GEO | Heartbeat-ключ водія з TTL 60 с + фонове очищення індексу (`ZREM`) | У Redis GEO позиції — члени одного sorted set; TTL на окремого члена неможливий |
| 3 | `08-class-after` | `queue` у діаграмі класів | Додано `allowmixing` | Без цього PlantUML не дозволяє змішувати елементи різних типів діаграм |
| 4 | ADR-003 | Consumer groups без Trip | Додано Trip | Trip споживає `driver.assigned` і `payment.*` |
| 5 | 4.4, матриця | «Буде зафіксовано в ADR … на кроці 7» | Посилання на наявні ADR | Застарілі посилання вперед |
| 6 | 9.4 | Граматична помилка в рядку про ASR-06 | Виправлено | Редакційне |
| 7 | README | Лише імена учасників | Таблиця відповідальності, «пакет у цифрах», інструкція з рендерингу | Технічна вимога №10 |
