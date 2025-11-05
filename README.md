# 📱 Flutter Technical Assessment

### *Splash Animation • SIM Number Auto-Fill • Login Flow*

A clean, functional, and responsive Flutter app built as part of a **technical assessment** — showcasing real-world Flutter concepts such as animation, native integration, and smooth UI transitions.

---

## 🚀 Features

* ✨ **Animated Splash Screen** with bounce logo effect
* 📲 **Login Page** with mobile number field
* 📡 **SIM Card Auto-Fill** using the device’s SIM information
* 🔄 **Permission Handling** with `permission_handler`
* ✅ **Modern & Responsive UI** with Material 3 design
* 🎨 **Clean Navigation Flow:**
  *Splash → Login → SIM Popup → Success Page*

---

## 🧰 Tech Stack

* **Flutter:** 3.x (Dart SDK 3.x)
* **Packages Used:**

  * [`mobile_number`](https://pub.dev/packages/mobile_number) – SIM info retrieval
  * [`permission_handler`](https://pub.dev/packages/permission_handler) – runtime permissions

---

## ⚙️ Getting Started

```bash
# Clone the repository
git clone https://github.com/mdsababalam/read_sim_from_uerphone.git

# Navigate into the project
cd read_sim_from_uerphone

# Get dependencies
flutter pub get

# Run the app
flutter run
```

🧩 *Test on a **real Android device** (emulators don’t have SIM cards).*

---

## 🪪 Permissions Required

```xml
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
<uses-permission android:name="android.permission.READ_PHONE_NUMBERS" />
<uses-permission android:name="android.permission.READ_SMS" />
<uses-permission android:name="android.permission.INTERNET" />
```

---

## 📸 App Flow

| Screen           | Description                       |
| ---------------- | --------------------------------- |
| 🟦 Splash Screen | Bouncing logo animation           |
| 🔢 Login Screen  | Number input + Auto SIM detection |
| 📶 SIM Selection | Choose a number from active SIMs  |
| ✅ Success Screen | Confirms login completion         |

---

## 👨‍💻 Developer

**Sabab Alam**
Flutter Developer | 3+ Years Experience
