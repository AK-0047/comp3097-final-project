# 🚗 RouteShare 

<p align="center">
  <b>Intercity Ride-Sharing Application</b><br>
  <i>Connect drivers with passengers traveling along the same route</i>
</p>

<p align="center">
  <a href="#overview">Overview</a> •
  <a href="#features">Features</a> •
  <a href="#screens">Screens</a> •
  <a href="#tech-stack">Tech Stack</a> •
  <a href="#data-storage">Data Storage</a> •
  <a href="#development">Development</a> •
  <a href="#future-work">Future Work</a> •
  <a href="#team">Team</a>
</p>

---

## 📋 Overview

**RouteShare** is a mobile application designed to facilitate intercity ridesharing by connecting drivers with passengers traveling along the same route. The app aims to reduce travel costs and improve efficiency by allowing users to search for and post trips.

This repository contains the iOS implementation of RouteShare, optimized for iPhone 14 in portrait mode.

---

## ✨ Features

- **User Authentication** - Secure login and registration system
- **Trip Creation** - Drivers can post upcoming trips with route details
- **Trip Search** - Passengers can find available rides matching their needs

---

## 📱 Screens

### 🏠 Home Screen
- Introduction to the app
- Navigation options for all the other pages

### 🔑 Login Screen
- Email/password authentication
- Navigation to signup for new users

### 📝 Signup Screen
- User registration with basic details:
  - First Name
  - Last Name
  - Email
  - Password
  - Password Confirmation

### 🚘 Posting a Trip Screen
- Form for drivers to enter trip details:
  - Departure city
  - Destination city
  - Departure time
  - Fare information
  - Available seats

### 🔍 Searching for a Trip Screen
- Search parameters:
  - Departure city
  - Destination city
  - Date preferences

### 📊 Search Results Screen
- Display of matching trips
- Essential trip details:
  - Route information
  - Date & time
  - Driver information
  - Price
- Option to book rides

---

## 🛠 Tech Stack

- **Frontend**: Swift (Xcode)
- **UI Design**: Following Apple's UI guidelines
- **Authentication & Database**: Firebase
- **Design Tool**: Figma (for wireframes)

---

## 💾 Data Storage

### Stored Data
- User credentials (email, password)
- User profiles (first name, last name)
- Trip details:
  - Driver information
  - Departure & destination locations
  - Date and time
  - Fare
  - Available seats
  - Payment preferences

### Storage Method
Firebase will be used for:
- User authentication
- Real-time database management
- Secure data storage and retrieval

---

## 👨‍💻 Development

### Device Optimization
- Primarily optimized for iPhone 14 Pro (Portrait Mode)

### Implementation Strategy
1. Initial implementation with hardcoded mock data
2. UI development and testing
3. Firebase integration
4. Final testing and refinement

---

## 🔮 Future Work

- **Real-time Chat** - In-app messaging between drivers and passengers
- **Payment Gateway** - Secure in-app payment processing
- **Push Notifications** - Trip updates and booking confirmations
- **Ratings & Reviews** - User feedback system
- **Trip History** - Record of past rides and bookings

---

## 👥 Team

**Group Number**: 39

| Name | Student ID | Section |
|------|------------|---------|
| Anshul Kamboya | 101416629 | 50492 |
| Piyush Patel | 101410303 | 50492 |
| Affan Shaikh | 101413399 | 50488 |

---

<p align="center">
  Made with ❤️ by Team 39
</p>
