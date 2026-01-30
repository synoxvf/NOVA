<div align="center">
  <picture>
    <source srcset="https://github.com/user-attachments/assets/d146db6a-f725-403b-b87f-b0814592c5ee" type="image/webp">
    <img src="https://github.com/user-attachments/assets/d146db6a-f725-403b-b87f-b0814592c5ee" alt="NOVA Playbook - оптимизация Windows 11" width="800" height="auto">
  </picture>

  <h1>NOVA Playbook для Windows 11</h1>
  <p><strong>Оптимизация системы для максимальной производительности в играх и работе</strong></p>

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
- [Установка](#инструкция-по-установке)
- [Рекомендации после установки](#рекомендации-после-установки)
- [Открытый исходный код](#открытый-исходный-код)
- [Благодарности](#благодарности)
- [Поддержка](#поддержка)

## Описание

NOVA — это playbook для AME Wizard, нацеленный на повышение производительности, удаление системного мусора и отключение слежки. Проект строго ориентирован на **ISO Injection** (модификация образа до установки) для обеспечения максимальной стабильности системы.

## Возможности

- 🚀 **Производительность** — снижает фоновую активность системы, отключает телеметрию и настраивает параметры питания и системы для более стабильной работы.
- ✨ **Удобство использования** — удаляет встроенную рекламу и ненужные компоненты, а также настраивает интерфейс Windows для упрощения повседневного использования.
- 🔒 **Конфиденциальность** — ограничивает сбор данных Microsoft и удаляет Edge и предустановленные компоненты, которые не требуются для работы системы.

## Системные требования

> [!WARNING]  
> **Только ISO Injection.** Этот плейбук разработан исключительно для чистой установки Windows. Запуск на уже установленной системе **не поддерживается**, возможны критические ошибки.

- **ОС:** Windows 11 (Версии 24H2, 25H2)
- **Метод:** [AME Wizard ISO Injection](https://docs.amelabs.net/iso_injection.html)
- **Оборудование:** USB-флешка (от 8 ГБ)

## Инструкция по установке

### 1. Подготовка образа Windows 11

Рекомендуется использовать **UUP Dump** для интеграции последних обновлений.

**Метод UUP Dump (Рекомендуемый):**

1. Перейдите на [uupdump.net](https://uupdump.net/) и выберите **Latest Public Release build (x64)**.
2. Выберите **Язык** и **Редакцию**.
3. На этапе конвертации выберите **«Download and convert to ISO»** и отметьте галочки:
   - ✅ **Include updates**
   - ✅ **Run component cleanup**
   - ✅ **Integrate .NET Framework 3.5**
   - ✅ **Use solid (ESD) compression**
4. Скачайте архив, распакуйте и запустите скрипт загрузки. Дождитесь создания ISO-файла.

**Альтернативный метод:**

- Скачайте официальный ISO с [сайта Microsoft](https://www.microsoft.com/software-download/windows11).

### 2. Сборка модифицированного образа

1. Скачайте файл плейбука **NOVA** (`.apbx`) из раздела [Releases](../../releases).
2. Скачайте и запустите [**AME Wizard Beta**](https://ame-wizard.com/).
3. Перетащите **ISO** в окно программы, затем выберите файл `.apbx`.
4. Выберите нужные настройки в меню и следуйте инструкциям.
5. Дождитесь окончания процесса сборки.

### 3. Запись и Установка

1. Запишите полученный модифицированный ISO на флешку, используя встроенную функцию AME Wizard или программу [Rufus](https://rufus.ie/).
2. Загрузитесь с USB-накопителя (через BIOS/UEFI) и выполните чистую установку Windows.
3. Система будет настроена автоматически при первом входе на рабочий стол.

## Рекомендации после установки
>
> [!IMPORTANT]
> **НЕ ИСПОЛЬЗУЙТЕ** сторонние оптимизаторы, твикеры или другие «плейбуки» поверх NOVA. Для настройки системы используйте встроенное меню **Post-Install**.

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
  - [Скачать с Intel.com](https://www.intel.com/content/www/us/en/products/docs/arc-discrete-graphics/software/drivers.html).

### 3. Сеть

- **Realtek** — [Realtek PCIe FE / GBE / 2.5G / Gaming Family Controller](https://www.realtek.com/Download/List?cate_id=584)
- **Intel** — [Intel® Ethernet Adapter Complete Driver Pack](https://www.intel.com/content/www/us/en/download/15084/intel-ethernet-adapter-complete-driver-pack.html)
- **Intel (Wi-Fi)** — [Intel® Wireless Wi-Fi Drivers](https://www.intel.com/content/www/us/en/download/19351/windows-10-and-windows-11-wi-fi-drivers-for-intel-wireless-adapters.html)

</details>

<details>
<summary><strong>Настройки Windows</strong></summary>

- **Проводник:** При необходимости используйте batch-файлы в папке «Post-Install», чтобы убрать разделы **«Главная»** и **«Галерея»** из Проводника.
- **Электропитание:** По умолчанию активна **Сбалансированная** схема, но вы можете выбрать любую другую.
- **Дата и время:** Вручную установите **Часовой пояс** и выполните синхронизацию времени.
- **Службы и компоненты:** Используйте меню «Post-Install» для включения или отключения дополнительных функций Windows (печать, Bluetooth и т.д.) в соответствии с вашими потребностями.

</details>

## Открытый исходный код

Проект NOVA придерживается принципов Open Source. Файл плейбука (`.apbx`) представляет собой стандартный [ZIP-архив с паролем `malte`](https://docs.amelabs.net/developers/getting-started/creation.html), содержимое которого доступно для распаковки и аудита.

## Благодарности

В проекте использованы наработки и фрагменты кода следующих авторов и проектов:

- **zoicware** - [DefenderProTools](https://github.com/zoicware/DefenderProTools).
- **Ameliorated-LLC** - [AME Wizard](https://github.com/Ameliorated-LLC), [Privacy+](https://github.com/Ameliorated-LLC/privacy_plus)
- **undergroundwires** - [privacy.sexy](https://github.com/undergroundwires/privacy.sexy)
- **valleyofdoom** - [MouseTester](https://github.com/valleyofdoom/MouseTester)
- **spddl** - [GoInterruptPolicy](https://github.com/spddl/GoInterruptPolicy)

## Поддержка

Есть идеи или нашли ошибку? Присоединяйтесь к обсуждению на GitHub!

<div>
  <a href="https://github.com/synoxvf/NOVA/issues" aria-label="Обсуждения и вопросы">
    <img src="https://img.shields.io/badge/JOIN-THE_DISCUSSION%2FISSUES%2FFEATURES-5B3CA1?style=for-the-badge&logo=github&logoColor=white" alt="Discussion">
  </a>
</div>
