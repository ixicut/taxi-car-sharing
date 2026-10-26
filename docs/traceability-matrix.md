# Матриця трасування

Наскрізний зв'язок «вимоги → архітектура → діаграми → рішення → перевірка». Заповнюється поступово, після кожного кроку.

| ASR | Джерело (US / NFR) | Стейкхолдери | UC | Компоненти / контейнери | Діаграми | ADR | STRIDE | FF |
|---|---|---|---|---|---|---|---|---|
| ASR-01 Геолокація в реальному часі | NFR-01, NFR-03, US-04, US-15 | ST-01, ST-02, ST-03 | UC-05, UC-08 | LocationService, MatchingService | 03-usecase, 03-domain-model, 03-components | | | |
| ASR-02 Пікові навантаження | NFR-03, NFR-02 | ST-01, ST-03, ST-09 | UC-01, UC-02, UC-05 | TripService, PricingService, MatchingService, LocationService | 03-components | | | |
| ASR-03 Доступність і стійкість | NFR-04, NFR-05, NFR-16 | ST-01, ST-03, ST-09 | UC-01 (A4, A7), UC-09 (A2), UC-11 | TripService, PaymentService, NotificationService | 03-usecase, 03-components | | | |
| ASR-04 Узгодженість «замовлення → оплата» | NFR-07, US-03, US-05, US-06, US-16 | ST-01, ST-03, ST-07, ST-09 | UC-01, UC-09, UC-10, UC-11, UC-12, UC-13, UC-14 | TripService, PaymentService, MatchingService | 03-usecase, 03-domain-model (`TripStatus`), 03-components | | | |
| ASR-05 Безпека водія і платежів | NFR-08, NFR-09, NFR-10, US-14, US-06 | ST-01, ST-03, ST-07, ST-10, ST-12 | UC-06, UC-13 | IdentityService, PaymentService | 03-components | | | |
| ASR-06 Розширюваність партнерами | NFR-11, NFR-12, US-22, US-10 | ST-04, ST-05, ST-09 | UC-02 (тариф без релізу) | CarsharingService, PricingService | 03-domain-model (`Fleet`), 03-components | | | |

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
