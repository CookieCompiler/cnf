#!/bin/bash

# Автоматически берем полный путь к текущей папке и приклеиваем имя файла
TARGET_HTML="$(pwd)/newtab.html"

# Проверяем, существует ли файл рядом со скриптом
if [ ! -f "$TARGET_HTML" ]; then
    echo "❌ Ошибка: Файл $TARGET_HTML не найден в текущей папке!"
    echo "Запусти скрипт находясь в той же директории, где лежит твой HTML."
    exit 1
fi

echo "⚙️ Настраиваем системные файлы Firefox для файла: $TARGET_HTML"
FF_DIR="/usr/lib/firefox"
PREF_DIR="$FF_DIR/defaults/pref"

if [ ! -d "$FF_DIR" ]; then
    echo "❌ Ошибка: Директория $FF_DIR не найдена. Firefox установлен?"
    exit 1
fi

sudo mkdir -p "$PREF_DIR"

# 1. Заставляем Firefox читать настройки из mozilla.cfg
echo 'pref("general.config.filename", "mozilla.cfg");' | sudo tee "$PREF_DIR/autoconfig.js" > /dev/null
echo 'pref("general.config.obscure_value", 0);' | sudo tee -a "$PREF_DIR/autoconfig.js" > /dev/null

# 2. Создаем скрипт подмены URL новой вкладки
cat << EOF > "/tmp/mozilla.cfg"
// Первая строка обязательно должна быть комментарием!
var {classes:Cc,interfaces:Ci,utils:Cu} = Components;
try {
  var newTabURL = "file://$TARGET_HTML";
  try {
    const aboutNewTabService = Cc["@mozilla.org/browser/aboutnewtab-service;1"].getService(Ci.nsIAboutNewTabService);
    aboutNewTabService.newTabURL = newTabURL;
  } catch(e) {
    const { AboutNewTab } = ChromeUtils.import("resource:///modules/AboutNewTab.jsm");
    AboutNewTab.newTabURL = newTabURL;
  }
} catch(e) { Cu.reportError(e); }
EOF

sudo mv "/tmp/mozilla.cfg" "$FF_DIR/mozilla.cfg"

echo "✅ Готово! Установщик успешно отработал."
echo "Полностью перезапусти Firefox (закрой все окна)."
