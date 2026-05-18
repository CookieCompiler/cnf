#!/bin/bash

echo "🚀 Начинаем установку темы Hyprland из ветки 'new-arch'..."

# 1. Установка базовых зависимостей (панели, шрифты, терминал, обои)
# Добавлены Nerd Fonts и иконки, чтобы в Waybar не было "квадратиков" вместо значков
echo "📦 Устанавливаем необходимые пакеты..."
sudo pacman -S --needed git hyprland waybar kitty rofi-wayland dunst swww ttf-jetbrains-mono-nerd otf-font-awesome papirus-icon-theme polkit-gnome starship wl-clipboard

# 2. Переход во временную папку и клонирование
echo "📥 Скачиваем репозиторий..."
cd ~/
# Удаляем старую папку, если она осталась от прошлых попыток
rm -rf ~/dotfiles_temp
# Клонируем строго ветку new-arch
git clone -b new-arch https://github.com/szymonwilczek/dotfiles.git ~/dotfiles_temp

# 3. Бэкап старых конфигов
echo "🛡️ Создаем бэкап старых настроек (на всякий случай)..."
mkdir -p ~/.config_backup_theme
# Прячем старые папки, чтобы они не конфликтовали
for dir in hypr waybar kitty rofi dunst; do
    if [ -d "$HOME/.config/$dir" ]; then
        mv "$HOME/.config/$dir" "$HOME/.config_backup_theme/"
    fi
done

# 4. Копирование новых конфигов
echo "⚙️ Устанавливаем новые настройки..."
mkdir -p ~/.config
# Копируем всё содержимое из папки .config скачанного репозитория
cp -r ~/dotfiles_temp/.config/* ~/.config/

# Очистка мусора
rm -rf ~/dotfiles_temp

echo "✅ Установка завершена!"
echo "Теперь можешь запустить оболочку командой: Hyprland"