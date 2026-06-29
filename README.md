# 🛒 Ecosystem Overview: E-Commerce Mobile App, Admin Panel, and Backend

Welcome to the central documentation for the full e-commerce ecosystem. This repository represents the Flutter Mobile Application, but this document provides a comprehensive overview of all three pillars of the platform:

1. **Flutter Mobile Application** (`ecommerce_app`)
2. **Node.js/Express Backend API** (`ecommerce_backend`)
3. **React Admin Dashboard** (`sofian_admin_panel_react`)

---

## 📱 1. Flutter Mobile Application (`ecommerce_app`)
A cross-platform mobile application built with Flutter, designed to provide a seamless and premium shopping experience for users.

### Key Features:
- **State Management & Architecture**: Built using `flutter_bloc` for robust state management and `get_it`/`injectable` for clean Dependency Injection.
- **Full Localization (l10n)**: Native multi-language support including English, French, and Arabic, applying to UI elements and dynamic backend error messages.
- **Dynamic Routing**: Utilizes `go_router` for deep linking and advanced navigation flows.
- **Forced Update Mechanism**: Intercepts the user at the Splash Screen to enforce critical APK updates by communicating with the backend's versioning API.
- **Local Notifications**: Polling-based local notification system (`flutter_local_notifications`) to keep users informed without relying on heavy external push services.
- **Responsive UI**: Built with `flutter_screenutil` to ensure pixel-perfect layouts across all screen sizes.
- **Security**: JWT tokens are securely stored using `flutter_secure_storage`.

---

## ⚙️ 2. Node.js Backend API (`ecommerce_backend`)
A robust, secure, and highly scalable REST API built with Express.js and MongoDB to power both the mobile app and the admin dashboard.

### Key Features:
- **MongoDB & Mongoose**: Flexible document-based data modeling for products, users, categories, brands, orders, and application versioning.
- **Advanced Security**: 
  - Centralized Error Handling preventing stack-trace leaks.
  - `helmet` for HTTP header security.
  - NoSQL Injection protection via custom object sanitization.
  - `express-rate-limit` implemented across public and CI endpoints to prevent DDoS.
- **App Versioning System**: Dedicated routes (`GET/POST /api/app-version`) securely managed by CI/CD secrets to enforce mobile app updates.
- **Cloud Storage**: Integration with Cloudinary for secure product and APK file hosting.
- **Standardized Formatting**: Global middleware to enforce consistent monetary price formatting (`n.XX`) across all endpoints.
- **Cron Jobs**: Integrated `node-cron` for automated server keep-alive pinging to prevent cold starts on hosting providers.

---

## 💻 3. React Admin Dashboard (`sofian_admin_panel_react`)
A comprehensive web-based back-office built with React for store managers to oversee operations.

### Key Features:
- **Role-Based Access Control (RBAC)**: Strict access limits ensure that only authorized administrators can view and manage sensitive routes like Managers, Dashboard analytics, and Feedback.
- **Localization**: Full multi-language support via `translation.json` ensuring admins can work in their preferred language (EN, FR, AR).
- **Order Management & Printing**: Professional, printer-optimized thermal receipt generation via an invisible iframe approach.
- **Dynamic Content Management**: Full CRUD capabilities for Products, Brands, and Categories.
- **Robust Error Handling**: Enhanced localized feedback for authentication flows and network errors.

---

## 🚀 CI/CD & Deployment
- **GitHub Actions**: Automated workflows for building the Flutter APK.
- **Cloudinary Integration**: The pipeline automatically builds the Android APK, uploads it securely to Cloudinary, and triggers the Backend API to update the latest downloadable version and release notes.

## 🛠 Prerequisites
- **Flutter**: SDK `^3.11.5`
- **Node.js**: v18+
- **React**: Standard npm/yarn setup.
- **MongoDB**: Atlas or local instance.

## 📜 License
This project is proprietary and confidential.
