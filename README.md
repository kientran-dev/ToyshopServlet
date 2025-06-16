# ToyshopServlet 🧸🛒

A modern e-commerce website made with Java Servlet technology.

## Description ✨

ToyshopServlet is a full-featured e-commerce web application for selling toys online. It includes solutions for both customers and administrators. The project is modular, with an advanced AI module (Aishiba) for intelligent automation and analytics.

## Features 🚀

- 🔐 User authentication and authorization
- 🧸 Product browsing and searching with pagination
- 🛒 Shopping cart functionality
- 📦 Order management for users and admins
- 📊 Admin dashboard for analytics and management
- 📝 Product management (CRUD operations)
- 📱 Responsive design for all devices
- 🤖 AI-driven analytics and decision support (Aishiba module)
- 🗑️ Soft delete for products
- 🔎 Enhanced pagination and search

## Technologies Used 🛠️

- Java Servlet
- JSP (Jakarta Server Pages)
- Hibernate ORM (JPA)
- PostgreSQL Database
- HTML/CSS
- JavaScript
- Bootstrap for responsive design
- Lombok (Aishiba)

## Prerequisites ⚙️

- JDK 8 or higher (Java SDK 24 recommended for Aishiba)
- Apache Tomcat 8.5 or higher
- PostgreSQL 13 or higher
- Maven (for dependency management)

## Setup and Installation 🏗️

1. **Clone the repository**
   ```bash
   git clone https://github.com/kientran-dev/ToyshopServlet.git
   ```

2. **Configure PostgreSQL database**
  - Create a new database named `toyshop`
  - Import the provided SQL script from `database/toyshop_postgres.sql`
  - Ensure your PostgreSQL user has rights to this database
  - **Note:** The database is secured. If you need access or wish to use the production database, please contact me for credentials and further information.

3. **Configure database connection**
  - Update `src/main/resources/database.properties` with your PostgreSQL credentials and JDBC URL

4. **Build the project**
   ```bash
   mvn clean install
   ```

5. **Deploy to Tomcat server**
  - Copy the generated WAR file to Tomcat's `webapps` directory
  - Start Tomcat server

## Project Structure 🗂️

```
ToyshopServlet/
├── src/
│   ├── main/
│   │   ├── java/         # Java source files
│   │   ├── webapp/       # Web resources
│   │   └── resources/    # Configuration files
│   └── test/             # Test files
├── database/             # Database scripts 
├── Aishiba/              # AI module
├── Dashboard/            # Admin dashboard
└── pom.xml               # Maven configuration
```

## Usage 💡

- Access the application at: `http://localhost:8080/ToyshopServlet`
- Default admin credentials:
  - Username: admin
  - Password: password123

## Contributing 🤝

Contributions are welcome! Please submit pull requests following the project coding standards.

## License 📄

This project is licensed under the MIT License - see the LICENSE file for details.