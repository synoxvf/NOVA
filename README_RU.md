<div align="center">
  <picture>
    <img src="./.github/assets/banner.png" alt="NOVA Playbook - Windows 11 Optimization" width="800" height="auto">
  </picture>

  <h1>NOVA Playbook для Windows 11</h1>
  <p><strong>Оптимизация системы для максимальной производительности в играх и работе.</strong></p>

  <p>
    <a href="https://github.com/synoxvf/NOVA/releases/latest" aria-label="Последний релиз">
      <img src="https://img.shields.io/github/v/release/synoxvf/NOVA?display_name=release&style=for-the-badge&logo=github&label=RELEASE&color=5B3CA1" alt="Release">
    </a>
    <a href="https://github.com/synoxvf/NOVA/blob/main/LICENSE" aria-label="Лицензия">
      <img src="https://img.shields.io/github/license/synoxvf/NOVA?style=for-the-badge&label=LICENSE&color=5B3CA1" alt="License">
    </a>
    <a href="https://github.com/synoxvf/NOVA/releases" aria-label="Загрузки">
      <img src="https://img.shields.io/github/downloads/synoxvf/NOVA/total?style=for-the-badge&label=DOWNLOADS&color=5B3CA1" alt="Downloads">
    </a>
    <a href="https://youtu.be/gD3zmOf6Xqc" aria-label="YouTube обзор" rel="noopener" target="_blank">
      <img src="https://img.shields.io/badge/YOUTUBE-INTRODUCING-5B3CA1?style=for-the-badge&logo=youtube" alt="YouTube">
    </a>
  </p>

  <p>
    <a href="./README.md" hreflang="en">
      <img src="https://img.shields.io/badge/ENGLISH-5B3CA1?style=for-the-badge&logo=google-translate&logoColor=white" alt="English">
    </a>
    <a href="./README_RU.md" hreflang="ru">
      <img src="https://img.shields.io/badge/РУССКИЙ-5B3CA1?style=for-the-badge&logo=google-translate&logoColor=white" alt="Русский">
    </a>
  </p>
</div>

## Содержание

- [Описание](#описание)
- [Возможности](#возможности)
- [Системные требования](#системные-требования)
- [Установка](#установка)
- [Рекомендации после установки](#рекомендации-после-установки)
- [FAQ](#faq)
- [Открытый исходный код](#открытый-исходный-код)
- [Благодарности](#благодарности)
- [Поддержка](#поддержка)

## Описание

NOVA — это playbook (автоматизированный сценарий настройки) для [AME Wizard](https://ame-wizard.com/), который подготавливает установочный образ Windows 11. Удаляет ненужные компоненты системы, снижает фоновую активность и отключает отправку данных в Microsoft.

Настройки применяются к установочному образу *до* установки Windows — этот подход называется **ISO Injection**. Модификация уже установленной системы не поддерживается.

## Возможности

- **Производительность** — снижает фоновую активность системы, отключает телеметрию и настраивает параметры питания и системы для более стабильной работы.
- **Удобство использования** — удаляет встроенную рекламу и ненужные компоненты, а также настраивает интерфейс Windows для упрощения повседневного использования.
- **Конфиденциальность** — ограничивает сбор данных Microsoft и удаляет Edge и предустановленные компоненты, которые не требуются для работы системы.

## Системные требования

> [!WARNING]
> **Только ISO Injection.** Playbook разработан для чистой установки Windows. Запуск на уже установленной системе **не поддерживается** и может привести к критическим ошибкам.

- **ОС:** Windows 11 (версии 24H2, 25H2)
- **Метод:** [AME Wizard ISO Injection](https://docs.amelabs.net/iso_injection.html)
- **Оборудование:** USB-флешка (от 8 ГБ)

## Установка

### 1. Подготовка образа Windows 11

Рекомендуется использовать **UUP Dump** — он интегрирует последние накопительные обновления в образ.

**Метод A — UUP Dump (рекомендуется):**

1. Перейдите на [uupdump.net](https://uupdump.net/) и выберите **Latest Public Release build (x64)**.
2. Выберите **Язык** и **Редакцию**.
3. На этапе конвертации выберите **«Download and convert to ISO»** и отметьте:
   - ✅ **Include updates**
   - ✅ **Run component cleanup**
   - ✅ **Integrate .NET Framework 3.5**
   - ✅ **Use solid (ESD) compression**
4. Скачайте архив, распакуйте и запустите скрипт загрузки. Дождитесь создания ISO-файла.

**Метод B — официальный ISO:**

- Скачайте ISO напрямую с [сайта Microsoft](https://www.microsoft.com/software-download/windows11). Обновления в нём не интегрированы.

### 2. Сборка модифицированного образа

1. Скачайте playbook **NOVA** (файл `.apbx`) из раздела [Releases](../../releases).
2. Скачайте и запустите [**AME Wizard Beta**](https://ame-wizard.com/).
3. Перетащите **ISO** в окно программы, затем выберите файл `.apbx`.
4. Выберите нужные опции в меню и следуйте инструкциям на экране.
5. Дождитесь окончания процесса сборки.

### 3. Запись и установка

1. Запишите модифицированный ISO на USB-флешку — через встроенный инструмент AME Wizard или [Rufus](https://rufus.ie/).
2. Загрузитесь с USB-накопителя (через BIOS/UEFI) и выполните чистую установку Windows.
3. Система будет настроена автоматически при первом входе на рабочий стол.

## Рекомендации после установки

> [!IMPORTANT]
> **Не используйте** сторонние оптимизаторы, твикеры или другие playbook поверх NOVA. Для дальнейшей настройки используйте встроенное меню **Post-Install**.

<details>
<summary><strong>Драйверы</strong></summary>

### 1. Чипсет

- **AMD** — [Скачать с AMD.com](https://www.amd.com/en/support)
- **Intel** — [Скачать с Intel.com](https://www.intel.com/content/www/us/en/download-center/home.html)

### 2. Видеокарта (GPU)

- **NVIDIA:**
  - **Рекомендуется** — [NVCleanstall](https://www.techpowerup.com/download/techpowerup-nvcleanstall/)
- **AMD:**
  - **Рекомендуется** — [RadeonSoftwareSlimmer](https://github.com/GSDragoon/RadeonSoftwareSlimmer)
  - **Кастомные** — [Amernime Zone](https://www.amernimezone.com/)
- **Intel Arc:**
  - [Скачать с Intel.com](https://www.intel.com/content/www/us/en/products/docs/arc-discrete-graphics/software/drivers.html)

### 3. Сеть

- **Realtek** — [Realtek PCIe FE / GBE / 2.5G / Gaming Family Controller](https://www.realtek.com/Download/List?cate_id=584)
- **Intel** — [Intel® Ethernet Adapter Complete Driver Pack](https://www.intel.com/content/www/us/en/download/15084/intel-ethernet-adapter-complete-driver-pack.html)
- **Intel (Wi-Fi)** — [Intel® Wireless Wi-Fi Drivers](https://www.intel.com/content/www/us/en/download/19351/windows-10-and-windows-11-wi-fi-drivers-for-intel-wireless-adapters.html)

</details>

<details>
<summary><strong>Настройки Windows</strong></summary>

- **Проводник:** При необходимости используйте batch-файлы в папке «Post-Install», чтобы убрать разделы **«Главная»** и **«Галерея»** из Проводника.
- **Электропитание:** По умолчанию активна **Сбалансированная** схема — при желании выберите другую.
- **Дата и время:** Вручную установите **Часовой пояс** и выполните синхронизацию времени.
- **Службы и компоненты:** Используйте меню «Post-Install» для включения или отключения дополнительных функций Windows (печать, Bluetooth и т. д.) при необходимости.

</details>

## FAQ

### Поддерживаются ли античиты с защитой ядра? (Vanguard, FACEIT, EAC, BattlEye)

> [!IMPORTANT]
> **Да.** NOVA сохраняет системные компоненты, необходимые для работы античитов уровня ядра.

- **VBS** (Virtualization-Based Security — аппаратная защита памяти на уровне виртуализации) включён по умолчанию. Это требуется для Vanguard и FACEIT AC. При необходимости VBS можно отключить через меню Post-Install, если вы не играете в игры, которым он нужен.
- Принудительная проверка подписи драйверов и **Целостность памяти** (Memory Integrity) остаются включёнными.
- Сервисы и компоненты, связанные с античитами, не удаляются.

### Можно ли откатить изменения NOVA?

> [!WARNING]
> **Автоматического отката нет.** Так как изменения применяются к установочному образу, NOVA нельзя «деинсталлировать» с уже работающей системы.

- Чтобы вернуться к стандартной Windows 11, выполните чистую установку с оригинального ISO.
- Часть настроек можно вернуть вручную через меню **Post-Install** (например, заново включить Windows Defender или VBS).

### Можно ли устанавливать Windows Update?

> [!WARNING]
> **Не рекомендуется.** Windows Update может откатить изменения NOVA и восстановить отключённые компоненты.

- **Избегайте накопительных обновлений** — они могут быть нестабильными и приводить к ошибкам.
- Чтобы получать свежие обновления безопасности, пересоберите образ заново с актуальным ISO из UUP Dump, а не устанавливайте обновления поверх.

## Открытый исходный код

NOVA следует принципам Open Source. Файл playbook (`.apbx`) — это стандартный [ZIP-архив с паролем `malte`](https://docs.amelabs.net/developers/getting-started/creation.html), содержимое которого доступно для распаковки и аудита.

## Благодарности

В проекте использованы наработки и фрагменты кода следующих авторов и проектов:

- **zoicware** — [DefenderProTools](https://github.com/zoicware/DefenderProTools)
- **Ameliorated-LLC** — [AME Wizard](https://github.com/Ameliorated-LLC), [Privacy+](https://github.com/Ameliorated-LLC/privacy_plus)
- **undergroundwires** — [privacy.sexy](https://github.com/undergroundwires/privacy.sexy)
- **valleyofdoom** — [MouseTester](https://github.com/valleyofdoom/MouseTester)
- **spddl** — [GoInterruptPolicy](https://github.com/spddl/GoInterruptPolicy)

## Поддержка

Есть идеи или нашли ошибку? Откройте issue или присоединяйтесь к обсуждению на GitHub.

<div>
  <a href="https://github.com/synoxvf/NOVA/issues" aria-label="Обсуждения и вопросы">
    <img src="https://img.shields.io/badge/JOIN-THE_DISCUSSION%2FISSUES%2FFEATURES-5B3CA1?style=for-the-badge&logo=github&logoColor=white" alt="Discussion">
  </a>
</div>
