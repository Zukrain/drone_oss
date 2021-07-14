# Создание образа Drone OSS

### Сборка drone-server
Для использования Drone CE необходимо собрать бинарник с тегом `oss nolimit`. Это накладывает ограничение по сравнению с EE версией:

1. Не работает TLS
2. Нет поддержки runner
3. В качестве БД можно использовать только sqlite3

Сборка проекта

    git clone https://github.com/drone/drone.git
    go install -tags "oss nolimit" /path/to/drone/cmd/drone-server

Бинарник будет лежать в `$GOPATH/bin`

### Сборка образа docker
В образе указанны переменные окружения для работы на localhost в single-mode.

    docker build -f Dockerfile -t zukrain/drone-oss:latest .

### Запуск docker контейнера
Запускаем конейнер для работы с собственной инсталяцией gitlab под systemd `/etc/systemd/system/drone.service`

    [Unit]
    Description=Drone Continuous Delivery system
    After=docker.service network-online.target
    Requires=docker.service network-online.target
    
    [Service]
    Restart=always
    
    WorkingDirectory=/etc/docker-compose.d
    
    ExecStart=-/usr/local/bin/docker-compose -f drone/docker-compose.yml up --no-color --abort-on-container-exit
    ExecStop=/bin/bash -c '/usr/local/bin/docker-compose -f drone/docker-compose.yml down -t 5 || true'
    
    [Install]
    WantedBy=multi-user.target

Для запуска сервиса выполняем команды:

    cd /etc/systemd/system/multi-user.target.wants/
    ln -s /etc/systemd/system/drone.service drone.service
    systemctl daemon-reload
    systemctl start drone.service

### Использование самоподписанного сертификата
Если для gitlab используется самоподписанный сертификат, тогда нужно его прокинуть в контейнер для возможности
клонирования репозиторием. Для этого в docker-compose.yml добавлены парметры тома сертификата и опция `DRONE_RUNNER_VOLUMES`
