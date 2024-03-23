## Part 1. Готовый докер

1. Взять официальный докер образ с nginx и выкачать его при помощи docker pull;

Выкачивание официального докер образа:
> sudo docker pull nginx

![alt text](./screenshot/image.png)

2. Проверить на наличие докер образа через docker images;

> sudo docker images

![alt text](./screenshot/image-1.png)

3. Запустить докер образ через docker run -d `[image_id|repository]`. Проверить, что образ запустился через docker ps;

> sudo docker run -d *image_id*

> sudo docker ps

![alt text](./screenshot/image-2.png)

4. Посмотреть информацию о контейнере через docker inspect [container_id|container_name];

> sudo docker inspect *container_id*

размер контейнера: **67108864**

список замапленных портов: **80/tcp**

ip контейнера: **172.17.0.2**

![alt text](./screenshot/image-3.png)

5. Остановить докер образ через docker stop [container_id|container_name];

> sudo docker stop *container_id*

![alt text](./screenshot/image-4.png)

6. Проверить, что образ остановился через docker ps;

> sudo docker ps

![alt text](./screenshot/image-5.png)

7. Запустить докер с портами 80 и 443 в контейнере, замапленными на такие же порты на локальной машине, через команду run;

> sudo docker run -d -p 80:80 -p 443:443 nginx

![alt text](./screenshot/image-6.png)

8. Проверить, что в браузере по адресу localhost:80 доступна стартовая страница nginx;

![alt text](./screenshot/image-7.png)

9. Перезапустить докер контейнер через docker restart `[container_id|container_name]`. Проверить любым способом, что контейнер запустился.

> sudo docker restart *container_id*

> sudo docker ps

![alt text](./screenshot/image-8.png)

## Part 2. Операции с контейнером

1. Прочитать конфигурационный файл nginx.conf внутри докер контейнера через команду exec;

> sudo docker exec *container_id* cat /etc/nginx/nginx.conf

![alt text](./screenshot/image-9.png)

2. Создать на локальной машине файл nginx.conf. Настроить в нем по пути /status отдачу страницы статуса сервера nginx;

> cat nginx.conf

![alt text](./screenshot/image-10.png)

3. Скопировать созданный файл nginx.conf внутрь докер образа через команду docker cp. Перезапустить nginx внутри докер образа через команду exec;

> sudo docker cp nginx.conf container_id:/etc/nginx/nginx.conf 

> sudo docker exec container_id nginx -s reload 

![alt text](./screenshot/image-11.png)

4. Проверить, что по адресу localhost:80/status отдается страничка со статусом сервера nginx;

> sudo curl localhost:80/status/

![alt text](./screenshot/image-12.png)

5. Экспортировать контейнер в файл container.tar через команду export;

> sudo docker export container_id -o container.tar

> ls

![alt text](./screenshot/image-13.png)

6. Остановить контейнер. Удалить образ через docker rmi [image_id|repository], не удаляя перед этим контейнеры. Удалить остановленный контейнер;

> sudo docker stop container_id

> sudo docker rmi nginx -f

> sudo docker rm container_id

![alt text](./screenshot/image-14.png)

7. Импортировать контейнер обратно через команду import;

> sudo docker import -c 'CMD ["nginx", "-g", "daemon off;"]' container.tar import_nginx

> sudo docker images

![alt text](./screenshot/image-15.png)

8. Запустить импортированный контейнер;

> sudo docker run -d -p 80:80 -p 443:443 import_nginx

![alt text](./screenshot/image-16.png)

9. Проверить, что по адресу localhost:80/status отдается страничка со статусом сервера nginx

> sudo curl localhost:80/status/

![alt text](./screenshot/image-17.png)

## Part 3. Мини веб-сервер

Для удобства, дальнейшие действия были прописаны в виде скрипта.

![alt text](./screenshot/image-18.png)

1. Запустить написанный мини сервер через spawn-fcgi на порту 8080;

![alt text](./screenshot/image-19.png)

2. Написать свой nginx.conf, который будет проксировать все запросы с 81 порта на 127.0.0.1:8080;

![alt text](./screenshot/image-20.png)

> ./build.sh

![alt text](./screenshot/image-21.png)

3. Проверить, что в браузере по localhost:81 отдается написанная вами страничка.

![alt text](./screenshot/image-22.png)

## Part 4. Свой докер

1. Написать свой докер образ, который:
- собирает исходники мини сервера на FastCgi из Части 3;
- запускает его на 8080 порту;
- копирует внутрь образа написанный ./nginx/nginx.conf;
- запускает nginx.

`Dockerfile`

![alt text](./screenshot/image-23.png)

`hello_world.c`

![alt text](./screenshot/image-24.png)

`start.sh`

![alt text](./screenshot/image-25.png)

`nginx.conf`

![alt text](./screenshot/image-26.png)

1. Собрать написанный докер образ через docker build при этом указав имя и тег;

> docker build -t helloworld:latest .

![alt text](./screenshot/image-27.png)

2. Проверить через docker images, что все собралось корректно. Запустить собранный докер образ с маппингом 81 порта на 80 на локальной машине и маппингом папки ./nginx внутрь контейнера по адресу, где лежат конфигурационные файлы nginx'а ;

> docker images

> docker run -it -p 80:81 -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf -d helloworld:latest

> docker ps -a 

![alt text](./screenshot/image-28.png)

3. Проверить, что по localhost:80/status отдается страничка со статусом nginx. Проверить, что по localhost:80 доступна страничка написанного мини сервера;

![alt text](./screenshot/image-29.png)

## Part 5. Dockle

Перед выполнением нужно установить Dockle. Для удобвство установка записана в виде скрипта `install_Dockle.sh`.

![alt text](./screenshot/image-40.png)

1. Просканировать образ из предыдущего задания через dockle [image_id|repository]

> dockle helloworld

![alt text](./screenshot/image-30.png)

2. Исправить образ так, чтобы при проверке через dockle не было ошибок и предупреждений

![alt text](./screenshot/image-31.png)

После этого загружаем обновлённую версию.

> docker build -t helloworld:fixed .

В случае возникновения ошибок CIS-DI-0010, может понадобвится прописать дополнительные параметры:

Команда --ak NGINX_GPGKEY_PATH указывает путь к ключу GPG, который Dockle должен использовать в процессе сканирования.

Команда --ak NGINX_GPGKEY предоставляет метку или псевдоним для ключа GPG, указанного с помощью --ak.

> dockle --ak NGINX_GPGKEY_PATH --ak NGINX_GPGKEY helloworld:fixed

![alt text](./screenshot/image-32.png)

## Part 6. Базовый Docker Compose

Написать файл docker-compose.yml, с помощью которого:

1) Поднять докер контейнер из Части 5 (он должен работать в локальной сети, т.е. не нужно использовать инструкцию EXPOSE и мапить порты на локальную машину)
2) Поднять докер контейнер с nginx, который будет проксировать все запросы с 8080 порта на 81 порт первого контейнера

`Содержание файла docker-compose.yml`

![alt text](./screenshot/image-33.png)

`Содержание файла Dockerfile`

![alt text](./screenshot/image-34.png)

`Содержание bash-скрипта start.sh`

![alt text](./screenshot/image-35.png)

`Содержание nginx.conf`

![alt text](./screenshot/image-36.png)

1. Остановить все запущенные контейнеры. Cобрать и запустить проект с помощью команд docker-compose build и docker-compose up;

> docker images

> docker ps

> docker-compose build

![alt text](./screenshot/image-37.png)

> docker-compose up -d

> docker ps

> curl http://localhost:80

> curl http://localhost:80/status/

![alt text](./screenshot/image-38.png)

2. Проверить, что в браузере по localhost:80 отдается написанная вами страничка

![alt text](./screenshot/image-39.png)