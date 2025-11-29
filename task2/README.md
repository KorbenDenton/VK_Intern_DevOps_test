# VK Intern DevOps Тестовое задание 2
**Выполнил:** Зайнуллин Айзат Маратович

## Описание

Проект реализует минимальную автоматическую установку ClickHouse в Kubernetes с помощью Helm.

## Данный проект реализует систему мониторинга простого веб-приложения с функциями:

- Развёртывание single-node ClickHouse  
- Указание версии ClickHouse  
- Настройка пользователей с паролями через Kubernetes Secret  
- Автоматическое создание постоянного хранилища для Pod с помощью StatefulSet  

## Компоненты

Helm Chart — шаблоны для развёртывания ClickHouse

**values.yaml** — конфигурация чарта (версия, пользователи, пароли, хранилище)  
**templates/statefulset.yaml** — StatefulSet для запуска ClickHouse с постоянным PVC  
**templates/service.yaml** — сервис для доступа к базе  
**templates/secret.yaml** — Kubernetes Secret с пользователями и паролями  
**Charts.yaml** - метаданные чарта  

## Проверка работы

Установка релиза из архива чарта:
```bash
helm install chart-name click-house-0.1.0.tgz
```

Проверяем все ресурсы релиза
```bash
kubectl get statefulset
kubectl get pods
kubectl get pv,pvc,secret
```

