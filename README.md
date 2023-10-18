# Проект: Mail Logs Viewer
### Проект "Mail Logs Viewer" - это FCGI-приложение на Perl, которое позволяет просматривать и фильтровать записи из почтовых логов, хранящиеся в базе данных. Приложение предоставляет веб-интерфейс для ввода адреса получателя и отображения соответствующих записей из базы данных.

## Использование
Для использования приложения выполните следующие шаги:
1. Убедитесь, что на вашем сервере установлены модули Perl: FCGI, DBI и DBD::mysql.
2. Создайте базу данных MySQL и импортируйте в нее данные из почтовых логов. Создайте таблицы message и log с соответствующими полями.
3. Создайте файл mysql.conf с параметрами подключения к базе данных. Пример файла лежит в директории conf
4. Настройте веб-сервер (например, Apache) для обработки FCGI-запросов и настройте путь к FCGI-скрипту, в данном проекте это **perl/cgi-bin/mail_log_data.fcgi**
5. Откройте приложение в веб-браузере, введите адрес получателя в поле ввода формы и отправьте форму. Вы увидите список записей из базы данных.


## Автор
#### Данилов Илья