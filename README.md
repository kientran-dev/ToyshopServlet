# ToyshopServlet 🧸🛒

A modern e-commerce website using Java Servlet technology.

## Live Demo 🌐

🔗 [https://toyshop.up.railway.app/Aishiba](https://toyshop.up.railway.app/Aishiba)

## Description ✨

ToyshopServlet is a feature-rich e-commerce web application for selling toys online, with dedicated modules for customers and administrators. The project is modular and includes a main AI-powered application written in the `Aishiba` directory.

## Features 🚀

* 🧸 Product browsing and searching with pagination
* 📦 Order management for users and admins
* 📊 Admin dashboard for analytics and management
* 📝 Product management (CRUD operations)
* 📱 Responsive design for all devices
* 🗑️ Soft delete for products
* 🔎 Enhanced pagination and search

## Technologies Used 🛠️

* Java Servlet
* JSP (Jakarta Server Pages)
* Hibernate ORM (JPA)
* PostgreSQL Database
* HTML/CSS, JavaScript, Bootstrap
* Lombok
* Docker

## Prerequisites ⚙️

* JDK 17 or higher (Java SDK 24 recommended)
* Apache Tomcat 10 or higher
* PostgreSQL 13 or higher
* Maven

## Setup and Installation 🏗️

1. **Clone the repository**
   ```bash
   git clone https://github.com/kientran-dev/ToyshopServlet.git
   ```

2. **Configure PostgreSQL database**
   - Create a new database named `toyshop`
   - Import the SQL script from `database/toyshop_postgres.sql`
   - Update `src/main/resources/database.properties` with your credentials

3. **Build the project**
   ```bash
   mvn clean install
   ```

4. **Deploy to Tomcat**
   - Copy the WAR file to Tomcat's `webapps` directory and start Tomcat

## 🐳 Docker Compose (Quick Setup)

1. Ensure Docker and Docker Compose are installed
2. Build the WAR file:
   ```bash
   mvn clean package
   ```
3. Start services:
   ```bash
   docker-compose up
   ```
4. Access the app at: [http://localhost:8080/Aishiba](http://localhost:8080/Aishiba)

## Project Structure 🗂️
```
ToyshopServlet/
├── database/             # Database scripts(hided)
├── Aishiba/              
│   ├── Dockerfile        # Build configuration for the app
│   └── src/
│       └── main/
│           ├── java/
│           │   └── com/kiendey/
│           │       ├── common/     # Shared constants and utilities
│           │       ├── dao/        # Data Access Objects (JPA Repositories)
│           │       ├── dto/        # Data Transfer Objects
│           │       ├── model/      # Entity classes
│           │       ├── security/   # Authentication & authorization
│           │       ├── servlet/    # Servlet controllers
│           │       └── utils/      # Utility/helper classes
│           ├── webapp/             # Web resources (JSP, static files)
│           └── resources/          # Configuration files
├── Dashboard/            # Admin dashboard
└── pom.xml               # Maven configuration
```
## Usage 💡

* Access the application at: `http://localhost:8080/Aishiba`
  * Username: `admin`
  * Password: `password123`

## Contributing 🤝

Contributions are welcome! Please submit pull requests following project guidelines.

## License 📄

MIT License – see the LICENSE file for details.

---

See more project details and source code on [GitHub](https://github.com/kientran-dev/ToyshopServlet).
