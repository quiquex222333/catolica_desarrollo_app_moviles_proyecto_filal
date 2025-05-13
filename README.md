# 📲 Registro de Entrada y Salida de Empleados

Una aplicación móvil desarrollada en **Flutter** que permite registrar las entradas y salidas de empleados usando la **cámara del dispositivo**, almacenando la información localmente con **SQLite**. La app está diseñada para situaciones donde no se requiere conexión a internet y necesita funcionar de forma sencilla, eficiente y amigable.

---

## 🧩 Características

✅ Registro de empleados mediante foto  
✅ Verificación facial: solo se aceptan fotos con personas  
✅ Entrada y salida múltiples por día (validación secuencial)  
✅ Cálculo de horas trabajadas por día, semana y mes  
✅ Historial por empleado  
✅ Búsqueda por nombre y filtro por fecha  
✅ Arquitectura limpia con **Riverpod**  
✅ Base de datos interna con **SQLite**  
✅ UI moderna y simple  
✅ Compatible con Android 📱  

---
## 📱 Funcionalidades clave
### Registro con cámara y validación facial
- El usuario toma una foto.
- Se valida que haya una persona visible.
- Se completa nombre y tipo (entrada/salida).

### Historial y control
- Visualiza el historial completo de cada empleado.
- Los registros se agrupan cronológicamente.
- Cada imagen se puede ampliar con detalles.

### Horas trabajadas
- La app detecta pares entrada/salida.
- Calcula la duración total trabajada por:
  * 🕐 Día
  * 📆 Semana
  * 🗓️ Mes

---

## 🖼️ Vista previa (GIFs e Imágenes)

### 🎥 Flujo de uso
Haz click sobre la imagen para ver el video :D
[![Mira el video](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSFvYnevTpW6ZalCiz1grTyy2HmoU7kjeFcg&s)](https://drive.google.com/file/d/1FAjwsM_9qLBNKyaZVUHJ9ePG7rw1wV9m/view?usp=sharing)

---

## 🛠️ Tecnologías utilizadas

- **Flutter** + Riverpod (arquitectura limpia)
- **SQLite** (almacenamiento local)
- **ML Kit (Face Detection)** — `google_mlkit_face_detection`
- `image_picker`, `path_provider`, `intl`
- Material 3

---

## 🚀 Instalación y ejecución

### Clona el repositorio

```bash
git clone https://github.com/quiquex222333/catolica_desarrollo_app_moviles_proyecto_filal.git
cd catolica_desarrollo_app_moviles_proyecto_filal
```

### Instala las dependencias
```
flutter pub get
```

### Ejecuta en modo desarrollo
```
flutter run
```

### Genera el APK release
```
flutter build apk --release
```

### Archivo generado en:
```
build/app/outputs/flutter-apk/app-release.apk
```

