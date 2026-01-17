# Vibes Weather App 🌦️

Una aplicación meteorológica moderna construida con Flutter, enfocada en la escalabilidad, el código limpio (Clean Architecture) y una experiencia de usuario fluida. La app permite conocer el clima en tiempo real basado en la ubicación del usuario y gestionar una lista de las ciudades favoritas.

## 🚀 Características Actuales
- **Ubicación en Tiempo Real:** Obtención automática del clima local mediante GPS al iniciar la app.
- **Buscador de Ciudades:** Búsqueda dinámica de condiciones climáticas por nombre de ciudad.
- **Gestión de Estados:** Implementación robusta de estados (Carga, Éxito, Error y Permisos) utilizando el patrón **BLoC**.
- **Sistema de Alertas:** Diálogos informativos (In-App) que alertan al usuario si se detectan condiciones de lluvia en su ubicación o ciudad buscada.
- **Código Documentado:** Comentarios detallados en cada capa (Core, Data, Domain, Presentation) explicando la arquitectura y lógica.
- **Interfaz Premium:** Diseño modular con gradientes, micro-animaciones y widgets reutilizables.

## 🛠️ Stack Técnico y Arquitectura

Para este proyecto se ha implementado **Clean Architecture**, asegurando que la lógica de negocio esté desacoplada de la interfaz y las fuentes de datos.

### Capas:
1. **Domain (Capa de Negocio):** Contiene las Entidades puras y los Casos de Uso (Usecases). Es el núcleo de la aplicación y no depende de ninguna librería externa.
2. **Data (Capa de Datos):** Implementación de los Repositorios, Modelos (Data Transfer Objects) y Data Sources (API OpenWeatherMap).
3. **Presentation (Capa de UI):** Gestión de estados con `flutter_bloc`. Los componentes visuales están modularizados en una carpeta `widgets` para maximizar la reutilización.

### Decisiones Técnicas Relevantes:
- **BLoC (Business Logic Component):** Elegido por su capacidad para manejar flujos de datos complejos y estados de forma predecible.
- **Dependency Injection (DI):** Uso de `get_it` para una gestión eficiente de dependencias y desacoplamiento de servicios.
- **Modularización de Widgets:** Extracción de componentes (tarjetas, buscadores, diálogos) para mantener las páginas (`Pages`) limpias y fáciles de mantener.

## ⚖️ Trade-offs (Decisiones de Compromiso)
- **In-App Alerts vs Local/Remote Notifications:** Se optó por el uso de **Diálogos In-app** para las alertas de lluvia. Esta decisión garantiza una entrega inmediata y una interacción directa con el usuario dentro de la experiencia de la app, eliminando la dependencia de configuraciones nativas y permisos de sistema que suelen ser menos confiables para una prueba técnica inmediata.
- **Persistencia en Memoria:** Debido al tiempo de la prueba, la lista de ciudades se gestiona en memoria. Sin embargo, la arquitectura está preparada para integrar una base de datos local (como Isar o Hive) simplemente añadiendo un nuevo Data Source.

## 🔮 Roadmap (Siguientes Pasos)
La aplicación está diseñada bajo el principio de "listo para escalar". En futuras versiones se planea:

1. **Google Maps Integration:** Implementación de un mapa interactivo con capas climáticas (radar de nubes, temperatura) centralizado en cada ciudad.
2. **Ecosistema Firebase:**
   - **Cloud Messaging:** Migración a notificaciones Push remotas para alertas climáticas en segundo plano/segundo plano matado.
   - **Firestore:** Sincronización de la lista de ciudades favoritas en la nube, permitiendo persistencia multiplataforma.
3. **Soporte Multi-idioma (i18n):** Implementación de internacionalización para alcanzar una audiencia global.
4. **Dark Mode Dinámico:** Soporte nativo para temas oscuros y claros basado en la configuración del sistema o preferencia del usuario.

## ⚙️ Cómo Ejecutar la Aplicación

### Requisitos Previos
- Flutter SDK (Versión estable más reciente).
- Dart SDK.
- Conexión a Internet.
- Un dispositivo físico o simulador (iOS/Android).

### Pasos
1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/totem451/weatherApp.git
   ```
2. **Obtener dependencias:**
   ```bash
   flutter pub get
   ```
3. **Configuración de API Key:**
   - La aplicación utiliza OpenWeatherMap API. Asegúrate de que la API Key esté configurada en el archivo correspondiente (ej. `.env` o dentro de los DataSources).
4. **Ejecutar:**
   ```bash
   flutter run
   ```

---
**Candidato:** Tomas Ledesma  
**Prueba Técnica:** Mobile Developer - VIB3S.