# install chrome headless
if [ ! -f "/usr/bin/google-chrome" ]; then
    echo -e "\e[32mInstalling chrome headless\e[39m"
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub > linux_signing_key.pub
    install -D -o root -g root -m 644 linux_signing_key.pub /etc/apt/keyrings/linux_signing_key.pub
    sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/linux_signing_key.pub] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
    apt-get update
    apt-get install -y google-chrome-stable

    if [ ! -d "/tmp/Crashpad" ]; then
        mkdir /tmp/Crashpad
    fi
    chown -R www-data:www-data /tmp/Crashpad
    chmod -R 775 /tmp/Crashpad/
    echo  "chrome headless version: $(google-chrome --version)"
else
    echo  "chrome headless is already installed"
    echo "chrome headless version: $(google-chrome --version)"
fi
